// import 'package:flutter/material.dart';
// import '../Payment/payment_screen.dart';
// // Import payment screen
//
// class BusPassForm extends StatefulWidget {
//   @override
//   _BusPassFormState createState() => _BusPassFormState();
// }
//
// class _BusPassFormState extends State<BusPassForm> {
//   String? selectedPassType;
//   String? selectedDestination;
//   final List<String> passTypes = ['Daily Pass', 'Monthly Pass', 'Yearly Pass'];
//   final List<String> destinations = ['Pune Station', 'Swargate', 'Shivajinagar'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: Text('Bus Pass Form'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Select Pass Type:',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             DropdownButtonFormField<String>(
//               value: selectedPassType,
//               items: passTypes.map((String type) {
//                 return DropdownMenuItem<String>(
//                   value: type,
//                   child: Text(type),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedPassType = value;
//                 });
//               },
//               decoration: InputDecoration(border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Select Destination:',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             DropdownButtonFormField<String>(
//               value: selectedDestination,
//               items: destinations.map((String dest) {
//                 return DropdownMenuItem<String>(
//                   value: dest,
//                   child: Text(dest),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedDestination = value;
//                 });
//               },
//               decoration: InputDecoration(border: OutlineInputBorder()),
//             ),
//             SizedBox(height: 30),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => PaymentScreen()),
//                   );
//                 },
//                 child: Text('Proceed to Payment'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:digital_bus_pass_system/Payment/payment_screen.dart';
//
// class BusPassFormScreen extends StatefulWidget {
//   @override
//   _BusPassFormScreenState createState() => _BusPassFormScreenState();
// }
//
// class _BusPassFormScreenState extends State<BusPassFormScreen> {
//   String selectedPaymentMethod = "Others";
//   int fullTickets = 1;
//   int halfTickets = 0;
//   String selectedMode = "By Ending stop";
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedDateTime = DateFormat("d MMM, yyyy | hh:mm a").format(DateTime.now());
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: const Text("Ticket Details"),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 15),
//             child: Center(
//               child: Text(
//                 "04:21",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Date & Time
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(12),
//             color: Colors.green,
//             child: Text(
//               formattedDateTime,
//               style: const TextStyle(color: Colors.white, fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//           ),
//
//           // Ticket Form
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Route Selection
//                     TextField(
//                       decoration: InputDecoration(
//                         prefixIcon: const Icon(Icons.directions_bus, color: Colors.green),
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                         hintText: "Select or enter route",
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//
//                     // Starting & Ending Stop
//                     Row(
//                       children: const [
//                         Icon(Icons.radio_button_off, color: Colors.grey),
//                         SizedBox(width: 10),
//                         Text("Starting stop"),
//                       ],
//                     ),
//                     const SizedBox(height: 5),
//                     Divider(color: Colors.grey.shade400),
//                     const SizedBox(height: 10),
//
//                     Row(
//                       children: [
//                         const Icon(Icons.radio_button_checked, color: Colors.black),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: TextField(
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                               hintText: "Enter ending stop",
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//
//                     // Selection Buttons
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 selectedMode = "By Fare";
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: selectedMode == "By Fare" ? Colors.green : Colors.white,
//                               foregroundColor: selectedMode == "By Fare" ? Colors.white : Colors.black,
//                               side: BorderSide(color: Colors.green),
//                             ),
//                             child: const Text("By Fare"),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 selectedMode = "By Ending stop";
//                               });
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: selectedMode == "By Ending stop" ? Colors.green : Colors.white,
//                               foregroundColor: selectedMode == "By Ending stop" ? Colors.white : Colors.black,
//                               side: BorderSide(color: Colors.green),
//                             ),
//                             child: const Text("By Ending stop"),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//
//                     // Ticket Selection
//                     const Text("Select Tickets", style: TextStyle(fontWeight: FontWeight.bold)),
//
//                     _buildTicketCounter("Full", fullTickets, (value) {
//                       setState(() {
//                         fullTickets = value;
//                       });
//                     }),
//
//                     _buildTicketCounter("Half", halfTickets, (value) {
//                       setState(() {
//                         halfTickets = value;
//                       });
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // Payment Section
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               border: Border(top: BorderSide(color: Colors.grey.shade300)),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     const Text("PAY USING", style: TextStyle(fontWeight: FontWeight.bold)),
//                     const SizedBox(width: 10),
//                     DropdownButton<String>(
//                       value: selectedPaymentMethod,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedPaymentMethod = newValue!;
//                         });
//                       },
//                       items: ["Others", "UPI", "Credit Card", "Debit Card"]
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                  if (_formKey.currentState!.validate()) {
//                  Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => PaymentScreen()),
//         );
//       }
//     },
//                     // Handle Payment Logic Here
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   child: const Text(
//                     "Pay",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Widget for Ticket Counter (Full/Half)
//   Widget _buildTicketCounter(String label, int count, Function(int) onChange) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 16)),
//           Row(
//             children: [
//               _counterButton("-", () {
//                 if (count > 0) onChange(count - 1);
//               }),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Text(
//                   "$count",
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               _counterButton("+", () {
//                 onChange(count + 1);
//               }),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Counter Button Widget
//   Widget _counterButton(String text, VoidCallback onPressed) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black),
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Text(
//           text,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:digital_bus_pass_system/Payment/payment_screen.dart';
import '../localizations/app_localizations.dart';

class BusPassFormScreen extends StatefulWidget {
  @override
  _BusPassFormScreenState createState() => _BusPassFormScreenState();
}

class _BusPassFormScreenState extends State<BusPassFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedPaymentMethod = "Others";
  int fullTickets = 1;
  int halfTickets = 0;
  String selectedMode = "By Ending stop";

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalization.of(context);
    String formattedDateTime = DateFormat("d MMM, yyyy | hh:mm a").format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(tr.translate("Ticket Details")),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Center(
              child: Text(
                "04:21",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Date & Time
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

            // Ticket Form
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Route Selection
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.directions_bus, color: Colors.green),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          hintText: tr.translate("Select or enter route"),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return tr.translate("Please enter a route.");
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Starting Stop (static)
                      Row(
                        children: [
                          Icon(Icons.radio_button_off, color: Colors.grey),
                          const SizedBox(width: 10),
                          Text(tr.translate("Starting stop")),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Divider(color: Colors.grey.shade400),
                      const SizedBox(height: 10),

                      // Ending Stop
                      Row(
                        children: [
                          const Icon(Icons.radio_button_checked, color: Colors.black),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                hintText: tr.translate("Enter ending stop"),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return tr.translate("Please enter an ending stop.");
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Selection Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedMode = "By Fare";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedMode == "By Fare" ? Colors.green : Colors.white,
                                foregroundColor: selectedMode == "By Fare" ? Colors.white : Colors.black,
                                side: const BorderSide(color: Colors.green),
                              ),
                              child: Text(tr.translate("By Fare")),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedMode = "By Ending stop";
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedMode == "By Ending stop" ? Colors.green : Colors.white,
                                foregroundColor: selectedMode == "By Ending stop" ? Colors.white : Colors.black,
                                side: const BorderSide(color: Colors.green),
                              ),
                              child: Text(tr.translate("By Ending stop")),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Ticket Selection
                      Text(
                        tr.translate("Select Tickets"),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      _buildTicketCounter(tr.translate("Full"), fullTickets, (value) {
                        setState(() {
                          fullTickets = value;
                        });
                      }),

                      _buildTicketCounter(tr.translate("Half"), halfTickets, (value) {
                        setState(() {
                          halfTickets = value;
                        });
                      }),
                    ],
                  ),
                ),
              ),
            ),

            // Payment Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(tr.translate("PAY USING"), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: selectedPaymentMethod,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPaymentMethod = newValue!;
                          });
                        },
                        items: ["Others", "UPI", "Credit Card", "Debit Card"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PaymentScreen()),
                        );
                      }
                    },
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
                child: Text(
                  "$count",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
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
}
