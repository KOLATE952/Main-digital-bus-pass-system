import 'package:flutter/material.dart';
import 'package:digital_bus_pass_system/Payment/payment_screen.dart';

class MonthlyPassScreen extends StatefulWidget {
  @override
  _MonthlyPassScreenState createState() => _MonthlyPassScreenState();
}

class _MonthlyPassScreenState extends State<MonthlyPassScreen> {
  String selectedPassType = "Only PMC - ₹40.0";
  final TextEditingController _idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  get selectedMonthlyPassAmount => null; // Key for form validation

  @override
  Widget build(BuildContext context) {
    String formattedDateTime = _getFormattedDateTime(); // Fetch current date & time

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Monthly Pass"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Date and Time
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

            // Pass Selection
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey, // Assign form key
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Select pass type",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    _buildPassOption("Student pass - ₹750.0"),
                    _buildPassOption("Senior citizen pass - ₹500.0"),
                    _buildPassOption("Passenger monthly pass ONLY PMC - ₹900.0"),
                    _buildPassOption("Passenger monthly pass PMC & PCMC - ₹1200.0"),

                    const SizedBox(height: 20),

                    // Aadhar / PAN Input
                    const Text("Enter last 4 digits of your Aadhar Card or Pan Card"),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _idController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your card number';
                        } else if (value.length != 4) {
                          return 'Enter exactly 4 digits';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "1234",
                      ),
                    ),

                    // Warning Message
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.orange.shade100,
                      child: const Text(
                        "You should have a valid ID with the above details.",
                        style: TextStyle(color: Colors.orange, fontSize: 14),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text("AMOUNT PAYABLE",
                        style: TextStyle(fontWeight: FontWeight.bold)),

                    const SizedBox(height: 20),

                    // Payment Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                          //   MaterialPageRoute(builder: (context) => PaymentScreen()),
                          //
                            MaterialPageRoute(
                                builder:
                                    (context) => PaymentScreen(amount: selectedMonthlyPassAmount.toString())
                            ),

                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 30),
                      ),
                      child: const Text(
                        "Pay",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get current date & time
  String _getFormattedDateTime() {
    DateTime now = DateTime.now();
    return "${now.day} ${_getMonthName(now.month)}, ${now.year} | ${_formatTime(now)}";
  }

  // Format time
  String _formatTime(DateTime time) {
    int hour = time.hour;
    String period = hour >= 12 ? "PM" : "AM";
    hour = hour % 12 == 0 ? 12 : hour % 12;
    String minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }

  // Get month name
  String _getMonthName(int month) {
    List<String> months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  // Widget for Pass Type Selection
  Widget _buildPassOption(String passType) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPassType = passType;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: selectedPassType == passType ? Colors.blue.withOpacity(0.2) : Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          passType,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
