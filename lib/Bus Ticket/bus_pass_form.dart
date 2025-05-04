import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:digital_bus_pass_system/Payment/payment_screen.dart';
import 'package:digital_bus_pass_system/localizations/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BusPassFormScreen extends StatefulWidget {
  @override
  _BusPassFormScreenState createState() => _BusPassFormScreenState();
}

class _BusPassFormScreenState extends State<BusPassFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final routeController = TextEditingController();
  final startStopController = TextEditingController();
  final endStopController = TextEditingController();

  String selectedPaymentMethod = "Others";
  int fullTickets = 1;
  int halfTickets = 0;
  String selectedMode = "By Ending stop";

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalization.of(context)!;
    String formattedDateTime = DateFormat("d MMM, yyyy | hh:mm a").format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(tr.translate("Ticket Details")),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Center(
              child: Text("04:21", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.green,
              child: Text(
                formattedDateTime,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: routeController,
                      icon: Icons.directions_bus,
                      hint: tr.translate("Select or enter route"),
                      errorMsg: tr.translate("Please enter a route."),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: startStopController,
                      icon: Icons.radio_button_off,
                      hint: tr.translate("Enter starting stop"),
                      errorMsg: tr.translate("Please enter starting stop."),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: endStopController,
                      icon: Icons.radio_button_checked,
                      hint: tr.translate("Enter ending stop"),
                      errorMsg: tr.translate("Please enter an ending stop."),
                    ),
                    const SizedBox(height: 20),

                    // Mode selection
                    Row(
                      children: [
                        _buildModeButton(tr.translate("By Fare"), "By Fare"),
                        const SizedBox(width: 10),
                        _buildModeButton(tr.translate("By Ending stop"), "By Ending stop"),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text(tr.translate("Select Tickets"), style: const TextStyle(fontWeight: FontWeight.bold)),
                    _buildTicketCounter(tr.translate("Full"), fullTickets, (val) {
                      setState(() => fullTickets = val);
                    }),
                    _buildTicketCounter(tr.translate("Half"), halfTickets, (val) {
                      setState(() => halfTickets = val);
                    }),
                  ],
                ),
              ),
            ),

            // Payment section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      tr.translate("Pay"),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper: Text Form Field
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required String errorMsg,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: hint,
      ),
      validator: (value) => value == null || value.isEmpty ? errorMsg : null,
    );
  }

  /// Helper: Mode Selection Buttons
  Widget _buildModeButton(String label, String value) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() => selectedMode = value);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedMode == value ? Colors.green : Colors.white,
          foregroundColor: selectedMode == value ? Colors.white : Colors.black,
          side: const BorderSide(color: Colors.green),
        ),
        child: Text(label),
      ),
    );
  }

  /// Helper: Ticket Counter
  Widget _buildTicketCounter(String label, int count, Function(int) onChange) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              _counterButton("-", () {
                if (count > 0) onChange(count - 1);
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("$count", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              _counterButton("+", () {
                onChange(count + 1);
              }),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper: Counter Button
  Widget _counterButton(String text, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Submit button logic
  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final passData = {
          "userId": user.uid,
          "route": routeController.text.trim(),
          "boardingStop": startStopController.text.trim(),
          "destinationStop": endStopController.text.trim(),
          "passType": routeController.text.trim(), // ✅ Now saving route as passType
          "fullTickets": fullTickets,
          "halfTickets": halfTickets,
          "paymentMethod": selectedPaymentMethod,
          "timestamp": FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance.collection('passHistory').add(passData);

        // Calculate total amount
        double totalAmount = (fullTickets * 15) + (halfTickets * 10); // Adjust prices if needed

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              amount: totalAmount.toString(),
              from: startStopController.text.trim(),
              to: endStopController.text.trim(),
              passType: routeController.text.trim(), // ✅ Also passed route as passType to next screen
              ticketCount: fullTickets + halfTickets,
            ),
          ),
        );
      }
    }
  }
}
