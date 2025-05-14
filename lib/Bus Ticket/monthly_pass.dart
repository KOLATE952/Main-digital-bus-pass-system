// import 'package:flutter/material.dart';
// import 'package:digital_bus_pass_system/Payment/payment_screen.dart';
// import 'package:digital_bus_pass_system/localizations/app_localizations.dart';
//
// class MonthlyPassScreen extends StatefulWidget {
//   @override
//   _MonthlyPassScreenState createState() => _MonthlyPassScreenState();
// }
//
// class _MonthlyPassScreenState extends State<MonthlyPassScreen> {
//   String selectedPassType = "Student pass - ₹750.0";
//   double selectedPassPrice = 750.0;
//   int selectedTicketCount = 1;
//   final TextEditingController _idController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     final tr = AppLocalization.of(context)!;
//     String formattedDateTime = _getFormattedDateTime();
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: Text(tr.translate("Monthly Pass")),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Current Date & Time
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(12),
//               color: Colors.green,
//               child: Text(
//                 formattedDateTime,
//                 style: const TextStyle(color: Colors.white, fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//
//             // Form & UI
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                    Text(tr.translate("Select pass type"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   _buildPassOption(tr.translate("Student_pass - ₹750.0")),
//                   _buildPassOption(tr.translate("Senior_citizen_pass - ₹500.0")),
//                   _buildPassOption(tr.translate("Passenger_monthly_pass_ONLY_PMC - ₹900.0")),
//                   _buildPassOption(tr.translate("Passenger_monthly_pass_PMC_&_PCMC - ₹1200.0")),
//
//
//                   const SizedBox(height: 20),
//
//                   Text(tr.translate("Enter last 4 digits of your Aadhar Card or Pan Card")),
//                   const SizedBox(height: 5),
//
//                   Form(
//                     key: _formKey,
//                     child: TextFormField(
//                       controller: _idController,
//                       keyboardType: TextInputType.number,
//                       maxLength: 4,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return tr.translate('Please enter your card number');
//                         } else if (!RegExp(r'^\d{4}$').hasMatch(value)) {
//                           return tr.translate('Enter exactly 4 digits');
//                         }
//                         return null;
//                       },
//                       decoration:  InputDecoration(
//                         border: const OutlineInputBorder(),
//                         hintText: tr.translate("1234"),
//                         counterText: "",
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 10),
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     color: Colors.orange.shade100,
//                     child: Text(
//                      tr.translate( "You should have a valid ID with the above details."),
//                       style: TextStyle(color: Colors.orange, fontSize: 14),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   Text(tr.translate("AMOUNT PAYABLE"), style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//
//                   Text(
//                     "₹${selectedPassPrice.toStringAsFixed(2)}",
//                     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Payment Button
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => PaymentScreen(
//                                 amount: selectedPassPrice.toString(),
//                                 from: 'StartLocation', // Replace with actual start location
//                                 to: 'EndLocation',     // Replace with actual end location
//                                 passType: 'Monthly',
//                                 ticketCount: selectedTicketCount,
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
//                       ),
//                       child:Text(
//                         tr.translate("Pay"),
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Get formatted date and time
//   String _getFormattedDateTime() {
//     DateTime now = DateTime.now();
//     return "${now.day} ${_getMonthName(now.month)}, ${now.year} | ${_formatTime(now)}";
//   }
//
//   /// Convert hour & minute to AM/PM format
//   String _formatTime(DateTime time) {
//     int hour = time.hour;
//     String period = hour >= 12 ? "PM" : "AM";
//     hour = hour % 12 == 0 ? 12 : hour % 12;
//     String minute = time.minute.toString().padLeft(2, '0');
//     return "$hour:$minute $period";
//   }
//
//   /// Convert month number to month name
//   String _getMonthName(int month) {
//     const months = [
//       "Jan", "Feb", "Mar", "Apr", "May", "Jun",
//       "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
//     ];
//     return months[month - 1];
//   }
//
//   /// Pass selection option
//   // Widget _buildPassOption(String passType, double price) {
//   Widget _buildPassOption(String passWithPrice) {
//     // Try splitting by " - ₹" or handle any whitespace differences
//     List<String> parts = passWithPrice.split(RegExp(r"\s*-\s*₹"));
//     String type = parts[0];
//     double price = parts.length > 1 ? double.tryParse(parts[1].replaceAll("₹", "").trim()) ?? 0.0 : 0.0;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedPassType = passWithPrice;
//           selectedPassPrice = price;
//         });
//       },
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         margin: const EdgeInsets.only(bottom: 10),
//         decoration: BoxDecoration(
//           color: selectedPassType == passWithPrice ? Colors.blue.withOpacity(0.2) : Colors.white,
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Text(passWithPrice, style: const TextStyle(fontSize: 16)),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:digital_bus_pass_system/Payment/payment_screen.dart';
import 'package:digital_bus_pass_system/localizations/app_localizations.dart';

class MonthlyPassScreen extends StatefulWidget {
  @override
  _MonthlyPassScreenState createState() => _MonthlyPassScreenState();
}

class _MonthlyPassScreenState extends State<MonthlyPassScreen> {
  String selectedPassType = "Student pass - ₹750.0";
  double selectedPassPrice = 750.0;
  final TextEditingController _idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int selectedTicketCount = 1;

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalization.of(context)!;
    String formattedDateTime = _getFormattedDateTime();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(tr.translate("Monthly_pass")),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr.translate("select_pass_type"),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // These remain unchanged
                  _buildPassOption(tr.translate("Student_pass - ₹750.0")),
                  _buildPassOption(tr.translate("Senior_citizen_pass - ₹500.0")),
                  _buildPassOption(tr.translate("Passenger_pass_ONLY_PMC - ₹900.0")),
                  _buildPassOption(tr.translate("Passenger_Pass_pmc_pcmc -₹1200.0")),

                  const SizedBox(height: 20),

                  Text(tr.translate("Enter last 4 digits of your Aadhar Card or Pan Card")),
                  const SizedBox(height: 5),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _idController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return tr.translate("Please enter your card number");
                        } else if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                          return tr.translate("Enter exactly 4 digits");
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: tr.translate("1234"),
                        counterText: "",
                      ),
                    ),
                  ),

                  // Warning Message
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 10),
                    color: Colors.orange.shade100,
                    child: Text(
                      tr.translate("You should have a valid ID with the above details."),
                      style: const TextStyle(color: Colors.orange, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(tr.translate("amount_payable"),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  Text(
                    "₹${selectedPassPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        DateTime now = DateTime.now();
                        DateTime validTill = now.add(const Duration(hours: 24));

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              amount: selectedPassPrice.toString(),
                              from: 'StartLocation',
                              to: 'EndLocation',
                              passType: 'Daily',
                              ticketCount: selectedTicketCount,
                              validTill: validTill.toIso8601String(),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                    ),
                    child: Text(
                      tr.translate("pay"),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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

  String _getFormattedDateTime() {
    DateTime now = DateTime.now();
    return "${now.day} ${_getMonthName(now.month)}, ${now.year} | ${_formatTime(now)}";
  }

  String _formatTime(DateTime time) {
    int hour = time.hour;
    String period = hour >= 12 ? "PM" : "AM";
    hour = hour % 12 == 0 ? 12 : hour % 12;
    String minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }

  String _getMonthName(int month) {
    List<String> months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  Widget _buildPassOption(String passWithPrice) {
    // Try splitting by " - ₹" or handle any whitespace differences
    List<String> parts = passWithPrice.split(RegExp(r"\s*-\s*₹"));
    String type = parts[0];
    double price = parts.length > 1 ? double.tryParse(parts[1].replaceAll("₹", "").trim()) ?? 0.0 : 0.0;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPassType = passWithPrice;
          selectedPassPrice = price;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: selectedPassType == passWithPrice
              ? Colors.blue.withOpacity(0.2)
              : Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(type, style: const TextStyle(fontSize: 16)),
            Text("₹${price.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
