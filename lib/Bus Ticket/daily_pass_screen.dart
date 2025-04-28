// import 'package:flutter/material.dart';
// import 'package:digital_bus_pass_system/Payment/payment_screen.dart';
//
// class DailyPassScreen extends StatefulWidget {
//   @override
//   _DailyPassScreenState createState() => _DailyPassScreenState();
// }
//
// class _DailyPassScreenState extends State<DailyPassScreen> {
//   String selectedPassType = "Only PMC - ₹40.0";
//   final TextEditingController _idController = TextEditingController();
//   final _formKey = GlobalKey<FormState>(); // Added form key for validation
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedDateTime = _getFormattedDateTime(); // Fetch current date & time
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: const Text("Daily Pass"),
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
//             // Date and Time
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
//             // Pass Selection
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Select pass type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//
//                   _buildPassOption("Only PMC - ₹40.0"),
//                   _buildPassOption("Only PCMC - ₹40.0"),
//                   _buildPassOption("PMC and PCMC - ₹50.0"),
//                   _buildPassOption("All Routes - ₹120.0"),
//
//                   const SizedBox(height: 20),
//
//                   // Aadhar / PAN Input
//                   const Text("Enter last 4 digits of your Aadhar Card or Pan Card"),
//                   const SizedBox(height: 5),
//
//                   Form(
//                     key: _formKey, // Form for validation
//                     child: TextFormField(
//                       controller: _idController,
//                       keyboardType: TextInputType.number,
//                       maxLength: 4,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your card number';
//                         } else if (!RegExp(r'^\d{4}$').hasMatch(value)) {
//                           return 'Enter exactly 4 digits';
//                         }
//                         return null;
//                       },
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: "1234",
//                         counterText: "",
//                       ),
//                     ),
//                   ),
//
//                   // Warning Message
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     margin: const EdgeInsets.only(top: 10),
//                     color: Colors.orange.shade100,
//                     child: const Text(
//                       "You should have a valid ID with the above details.",
//                       style: TextStyle(color: Colors.orange, fontSize: 14),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//                   const Text("AMOUNT PAYABLE", style: TextStyle(fontWeight: FontWeight.bold)),
//
//                   const SizedBox(height: 20),
//
//                   // Payment Button
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => PaymentScreen()),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
//                     ),
//                     child: const Text(
//                       "Pay",
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
//   // Get current date & time
//   String _getFormattedDateTime() {
//     DateTime now = DateTime.now();
//     return "${now.day} ${_getMonthName(now.month)}, ${now.year} | ${_formatTime(now)}";
//   }
//
//   // Format time
//   String _formatTime(DateTime time) {
//     int hour = time.hour;
//     String period = hour >= 12 ? "PM" : "AM";
//     hour = hour % 12 == 0 ? 12 : hour % 12;
//     String minute = time.minute.toString().padLeft(2, '0');
//     return "$hour:$minute $period";
//   }
//
//   // Get month name
//   String _getMonthName(int month) {
//     List<String> months = [
//       "Jan", "Feb", "Mar", "Apr", "May", "Jun",
//       "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
//     ];
//     return months[month - 1];
//   }
//
//   // Widget for Pass Type Selection
//   Widget _buildPassOption(String passType) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedPassType = passType;
//         });
//       },
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         margin: const EdgeInsets.only(bottom: 10),
//         decoration: BoxDecoration(
//           color: selectedPassType == passType ? Colors.blue.withOpacity(0.2) : Colors.white,
//           border: Border.all(color: Colors.grey),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Text(
//           passType,
//           style: const TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:digital_bus_pass_system/Payment/payment_screen.dart';

class DailyPassScreen extends StatefulWidget {
  @override
  _DailyPassScreenState createState() => _DailyPassScreenState();
}

class _DailyPassScreenState extends State<DailyPassScreen> {
  String selectedPassType = "Only PMC - ₹40.0";
  double selectedPassPrice = 40.0; // added price separately
  final TextEditingController _idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String formattedDateTime = _getFormattedDateTime();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Daily Pass"),
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
                  const Text("Select pass type", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  _buildPassOption("Only PMC - ₹40.0", 40.0),
                  _buildPassOption("Only PCMC - ₹40.0", 40.0),
                  _buildPassOption("PMC and PCMC - ₹50.0", 50.0),
                  _buildPassOption("All Routes - ₹120.0", 120.0),

                  const SizedBox(height: 20),

                  // Aadhar / PAN Input
                  const Text("Enter last 4 digits of your Aadhar Card or Pan Card"),
                  const SizedBox(height: 5),

                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _idController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your card number';
                        } else if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                          return 'Enter exactly 4 digits';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "1234",
                        counterText: "",
                      ),
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

                  const Text("AMOUNT PAYABLE", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // Display Selected Price
                  Text(
                    "₹${selectedPassPrice.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                  ),

                  const SizedBox(height: 20),

                  // Payment Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(amount: selectedPassPrice),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    ),
                    child: const Text(
                      "Pay",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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

  // Date and Time
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

  // Updated Pass Selection Widget
  Widget _buildPassOption(String passType, double price) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPassType = passType;
          selectedPassPrice = price;
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
