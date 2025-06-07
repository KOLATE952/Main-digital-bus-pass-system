// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:digital_bus_pass_system/Payment/payment_screen.dart';
// import 'package:digital_bus_pass_system/localizations/app_localizations.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class BusPassFormScreen extends StatefulWidget {
//   @override
//   _BusPassFormScreenState createState() => _BusPassFormScreenState();
// }
//
// class _BusPassFormScreenState extends State<BusPassFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final routeController = TextEditingController();
//   final routeFocusNode = FocusNode();
//   final startStopController = TextEditingController();
//   final endStopController = TextEditingController();
//
//   String selectedPaymentMethod = "Others";
//   int fullTickets = 1;
//   int halfTickets = 0;
//   String selectedMode = "By Ending stop";
//
//   List<String> allRoutes = [];
//   List<String> stopsForSelectedRoute = [];
//   List<String> filteredDestinationStops = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRoutesFromFirestore();
//
//     // Listen for changes in starting stop
//     startStopController.addListener(() {
//       final index = stopsForSelectedRoute.indexOf(startStopController.text.trim());
//       if (index != -1) {
//         setState(() {
//           filteredDestinationStops = stopsForSelectedRoute.sublist(index + 1);
//         });
//       } else {
//         setState(() {
//           filteredDestinationStops = [];
//         });
//       }
//     });
//   }
//
//   Future<void> fetchRoutesFromFirestore() async {
//     final querySnapshot = await FirebaseFirestore.instance.collection('routes').get();
//     final routeList = querySnapshot.docs.map((doc) => doc['name'].toString()).toList();
//     setState(() {
//       allRoutes = routeList;
//     });
//   }
//
//   Future<void> fetchStopsForRoute(String routeName) async {
//     final docSnapshot = await FirebaseFirestore.instance.collection('routes').doc(routeName).get();
//     if (docSnapshot.exists) {
//       final stops = List<String>.from(docSnapshot['stops']);
//       setState(() {
//         stopsForSelectedRoute = stops;
//         startStopController.clear();
//         endStopController.clear();
//         filteredDestinationStops = [];
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final tr = AppLocalization.of(context)!;
//     String formattedDateTime = DateFormat("d MMM, yyyy | hh:mm a").format(DateTime.now());
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: Text(tr.translate("Ticket Details")),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Column(
//           children: [
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
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     RawAutocomplete<String>(
//                       textEditingController: routeController,
//                       focusNode: routeFocusNode,
//                       optionsBuilder: (TextEditingValue textEditingValue) {
//                         return allRoutes.where((String option) {
//                           return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
//                         });
//                       },
//                       fieldViewBuilder: (context, controller, focusNode, _) {
//                         return TextFormField(
//                           controller: controller,
//                           focusNode: focusNode,
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(Icons.directions_bus, color: Colors.green),
//                             hintText: tr.translate("Select or enter route"),
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                           ),
//                           validator: (value) => value == null || value.isEmpty ? tr.translate("Please enter a route.") : null,
//                           onChanged: (value) {
//                             if (value.isNotEmpty) {
//                               fetchStopsForRoute(value.trim());
//                             }
//                           },
//                         );
//                       },
//                       optionsViewBuilder: (context, onSelected, options) {
//                         return _buildOptionsDropdown(onSelected, options);
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     _buildTextField(
//                       controller: startStopController,
//                       icon: Icons.radio_button_off,
//                       hint: tr.translate("Enter starting stop"),
//                       errorMsg: tr.translate("Please enter starting stop."),
//                     ),
//                     const SizedBox(height: 20),
//                     RawAutocomplete<String>(
//                       textEditingController: endStopController,
//                       focusNode: FocusNode(),
//                       optionsBuilder: (TextEditingValue textEditingValue) {
//                         return filteredDestinationStops.where((String option) {
//                           return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
//                         });
//                       },
//                       fieldViewBuilder: (context, controller, focusNode, _) {
//                         return TextFormField(
//                           controller: controller,
//                           focusNode: focusNode,
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(Icons.radio_button_checked, color: Colors.green),
//                             hintText: tr.translate("Enter destination stop"),
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                           ),
//                           validator: (value) => value == null || value.isEmpty ? tr.translate("Please enter destination stop.") : null,
//                         );
//                       },
//                       optionsViewBuilder: (context, onSelected, options) {
//                         return _buildOptionsDropdown(onSelected, options);
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       children: [
//                         _buildModeButton(tr.translate("By Fare"), "By Fare"),
//                         const SizedBox(width: 10),
//                         _buildModeButton(tr.translate("By Ending stop"), "By Ending stop"),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Text(tr.translate("Select Tickets"), style: const TextStyle(fontWeight: FontWeight.bold)),
//                     _buildTicketCounter(tr.translate("Full"), fullTickets, (val) => setState(() => fullTickets = val)),
//                     _buildTicketCounter(tr.translate("Half"), halfTickets, (val) => setState(() => halfTickets = val)),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 border: Border(top: BorderSide(color: Colors.grey.shade300)),
//               ),
//               child: ElevatedButton(
//                 onPressed: _handleSubmit,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 child: Text(
//                   tr.translate("Pay"),
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOptionsDropdown(onSelected, Iterable<String> options) {
//     return Align(
//       alignment: Alignment.topLeft,
//       child: Material(
//         elevation: 4.0,
//         child: ListView.builder(
//           padding: EdgeInsets.zero,
//           itemCount: options.length,
//           itemBuilder: (context, index) {
//             final option = options.elementAt(index);
//             return ListTile(
//               title: Text(option),
//               onTap: () => onSelected(option),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required IconData icon,
//     required String hint,
//     required String errorMsg,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.green),
//         hintText: hint,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//       validator: (value) => value == null || value.isEmpty ? errorMsg : null,
//     );
//   }
//
//   Widget _buildModeButton(String label, String value) {
//     return Expanded(
//       child: ElevatedButton(
//         onPressed: () => setState(() => selectedMode = value),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: selectedMode == value ? Colors.green : Colors.white,
//           foregroundColor: selectedMode == value ? Colors.white : Colors.black,
//           side: const BorderSide(color: Colors.green),
//         ),
//         child: Text(label),
//       ),
//     );
//   }
//
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
//                 child: Text("$count", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
//   Widget _counterButton(String text, VoidCallback onPressed) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black),
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//       ),
//     );
//   }
//
//   Future<void> _handleSubmit() async {
//     if (_formKey.currentState!.validate()) {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         final passData = {
//           "userId": user.uid,
//           "route": routeController.text.trim(),
//           "boardingStop": startStopController.text.trim(),
//           "destinationStop": endStopController.text.trim(),
//           "passType": routeController.text.trim(),
//           "fullTickets": fullTickets,
//           "halfTickets": halfTickets,
//           "paymentMethod": selectedPaymentMethod,
//           "timestamp": FieldValue.serverTimestamp(),
//         };
//
//         await FirebaseFirestore.instance.collection('passHistory').add(passData);
//
//         double totalAmount = (fullTickets * 15) + (halfTickets * 10);
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PaymentScreen(
//               amount: totalAmount.toString(),
//               from: startStopController.text.trim(),
//               to: endStopController.text.trim(),
//               passType: routeController.text.trim(),
//               ticketCount: fullTickets + halfTickets,
//             ),
//           ),
//         );
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     routeController.dispose();
//     routeFocusNode.dispose();
//     startStopController.dispose();
//     endStopController.dispose();
//     super.dispose();
//   }
// }
//

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:digital_bus_pass_system/Payment/payment_screen.dart';
// import 'package:digital_bus_pass_system/localizations/app_localizations.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class BusPassFormScreen extends StatefulWidget {
//   @override
//   _BusPassFormScreenState createState() => _BusPassFormScreenState();
// }
//
// class _BusPassFormScreenState extends State<BusPassFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final routeController = TextEditingController();
//   final routeFocusNode = FocusNode();
//   final startStopController = TextEditingController();
//   final endStopController = TextEditingController();
//
//   String selectedPaymentMethod = "Others";
//   int fullTickets = 1;
//   int halfTickets = 0;
//   String selectedMode = "By Ending stop";
//
//   List<String> allRoutes = [];
//   List<String> stopsForSelectedRoute = [];
//   List<String> filteredDestinationStops = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRoutesFromFirestore();
//
//     // Listen for changes in starting stop
//     startStopController.addListener(() {
//       final index = stopsForSelectedRoute.indexOf(startStopController.text.trim());
//       if (index != -1) {
//         setState(() {
//           filteredDestinationStops = stopsForSelectedRoute.sublist(index + 1);
//         });
//       } else {
//         setState(() {
//           filteredDestinationStops = [];
//         });
//       }
//     });
//   }
//
//   Future<void> fetchRoutesFromFirestore() async {
//     final querySnapshot = await FirebaseFirestore.instance.collection('routes').get();
//     final routeList = querySnapshot.docs.map((doc) => doc['name'].toString()).toList();
//     setState(() {
//       allRoutes = routeList;
//     });
//   }
//
//   Future<void> fetchStopsForRoute(String routeName) async {
//     final docSnapshot = await FirebaseFirestore.instance.collection('routes').doc(routeName).get();
//     if (docSnapshot.exists) {
//       final stops = List<String>.from(docSnapshot['stops']);
//       setState(() {
//         stopsForSelectedRoute = stops;
//         startStopController.clear();
//         endStopController.clear();
//         filteredDestinationStops = [];
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final tr = AppLocalization.of(context)!;
//     String formattedDateTime = DateFormat("d MMM, yyyy | hh:mm a").format(DateTime.now());
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: Text(tr.translate("ticket_details")),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Column(
//           children: [
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
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     RawAutocomplete<String>(
//                       textEditingController: routeController,
//                       focusNode: routeFocusNode,
//                       optionsBuilder: (TextEditingValue textEditingValue) {
//                         return allRoutes.where((String option) {
//                           return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
//                         });
//                       },
//                       fieldViewBuilder: (context, controller, focusNode, _) {
//                         return TextFormField(
//                           controller: controller,
//                           focusNode: focusNode,
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(Icons.directions_bus, color: Colors.green),
//                             hintText: tr.translate("select_or_enter_route"),
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                           ),
//                           validator: (value) => value == null || value.isEmpty ? tr.translate("enter_route_error") : null,
//                           onChanged: (value) {
//                             if (value.isNotEmpty) {
//                               fetchStopsForRoute(value.trim());
//                             }
//                           },
//                         );
//                       },
//                       optionsViewBuilder: (context, onSelected, options) {
//                         return _buildOptionsDropdown(onSelected, options);
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     _buildTextField(
//                       controller: startStopController,
//                       icon: Icons.radio_button_off,
//                       hint: tr.translate("enter_starting_stop"),
//                       errorMsg: tr.translate("enter_starting_stop_error"),
//                     ),
//                     const SizedBox(height: 20),
//                     RawAutocomplete<String>(
//                       textEditingController: endStopController,
//                       focusNode: FocusNode(),
//                       optionsBuilder: (TextEditingValue textEditingValue) {
//                         return filteredDestinationStops.where((String option) {
//                           return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
//                         });
//                       },
//                       fieldViewBuilder: (context, controller, focusNode, _) {
//                         return TextFormField(
//                           controller: controller,
//                           focusNode: focusNode,
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(Icons.radio_button_checked, color: Colors.green),
//                             hintText: tr.translate("enter_destination_stop"),
//                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                           ),
//                           validator: (value) => value == null || value.isEmpty ? tr.translate("enter_destination_stop_error") : null,
//                         );
//                       },
//                       optionsViewBuilder: (context, onSelected, options) {
//                         return _buildOptionsDropdown(onSelected, options);
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       children: [
//                         _buildModeButton(tr.translate("by_fare"), "By Fare"),
//                         const SizedBox(width: 10),
//                         _buildModeButton(tr.translate("by_ending_stop"), "By Ending stop"),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     Text(tr.translate("select_tickets"), style: const TextStyle(fontWeight: FontWeight.bold)),
//                     _buildTicketCounter(tr.translate("full"), fullTickets, (val) => setState(() => fullTickets = val)),
//                     _buildTicketCounter(tr.translate("half"), halfTickets, (val) => setState(() => halfTickets = val)),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 border: Border(top: BorderSide(color: Colors.grey.shade300)),
//               ),
//               child: ElevatedButton(
//                 onPressed: _handleSubmit,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 child: Text(
//                   tr.translate("pay"),
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOptionsDropdown(onSelected, Iterable<String> options) {
//     return Align(
//       alignment: Alignment.topLeft,
//       child: Material(
//         elevation: 4.0,
//         child: ListView.builder(
//           padding: EdgeInsets.zero,
//           itemCount: options.length,
//           itemBuilder: (context, index) {
//             final option = options.elementAt(index);
//             return ListTile(
//               title: Text(option),
//               onTap: () => onSelected(option),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required IconData icon,
//     required String hint,
//     required String errorMsg,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.green),
//         hintText: hint,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//       validator: (value) => value == null || value.isEmpty ? errorMsg : null,
//     );
//   }
//
//   Widget _buildModeButton(String label, String value) {
//     return Expanded(
//       child: ElevatedButton(
//         onPressed: () => setState(() => selectedMode = value),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: selectedMode == value ? Colors.green : Colors.white,
//           foregroundColor: selectedMode == value ? Colors.white : Colors.black,
//           side: const BorderSide(color: Colors.green),
//         ),
//         child: Text(label),
//       ),
//     );
//   }
//
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
//                 child: Text("$count", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
//   Widget _counterButton(String text, VoidCallback onPressed) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black),
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//       ),
//     );
//   }
//
//   Future<void> _handleSubmit() async {
//     print("submitted");
//     if (_formKey.currentState!.validate()) {
//       final user = FirebaseAuth.instance.currentUser;
//       print(user);
//       if (user != null) {
//         final passData = {
//           "userId": user.uid,
//           "route": routeController.text.trim(),
//           "boardingStop": startStopController.text.trim(),
//           "destinationStop": endStopController.text.trim(),
//           "passType": routeController.text.trim(),
//           "fullTickets": fullTickets,
//           "halfTickets": halfTickets,
//           "paymentMethod": selectedPaymentMethod,
//           "timestamp": FieldValue.serverTimestamp(),
//         };
//
//         // await FirebaseFirestore.instance.collection('passHistory').add(passData);
//
//         double totalAmount = (fullTickets * 15) + (halfTickets * 10);
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PaymentScreen(
//               amount: totalAmount.toString(),
//               from: startStopController.text.trim(),
//               to: endStopController.text.trim(),
//               passType: routeController.text.trim(),
//               ticketCount: fullTickets + halfTickets,
//               isbuspass: false,
//
//             ),
//           ),
//         );
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     routeController.dispose();
//     routeFocusNode.dispose();
//     startStopController.dispose();
//     endStopController.dispose();
//     super.dispose();
//   }
// }

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
  final routeFocusNode = FocusNode();
  final startStopController = TextEditingController();
  final endStopController = TextEditingController();

  String selectedPaymentMethod = "Others";
  int fullTickets = 1;
  int halfTickets = 0;
  String selectedMode = "By Ending stop";

  List<String> allRoutes = [];
  List<String> stopsForSelectedRoute = [];
  List<String> filteredDestinationStops = [];

  @override
  void initState() {
    super.initState();
    fetchRoutesFromFirestore();

    // Show all routes when field is focused
    routeFocusNode.addListener(() {
      if (routeFocusNode.hasFocus && routeController.text.isEmpty) {
        setState(() {}); // Trigger rebuild so options appear
      }
    });

    // Listen for changes in starting stop
    startStopController.addListener(() {
      final index = stopsForSelectedRoute.indexOf(startStopController.text.trim());
      if (index != -1) {
        setState(() {
          filteredDestinationStops = stopsForSelectedRoute.sublist(index + 1);
        });
      } else {
        setState(() {
          filteredDestinationStops = [];
        });
      }
    });
  }

  Future<void> fetchRoutesFromFirestore() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('routes').get();
    final routeList = querySnapshot.docs.map((doc) => doc['name'].toString()).toList();
    setState(() {
      allRoutes = routeList;
    });
  }

  Future<void> fetchStopsForRoute(String routeName) async {
    final docSnapshot = await FirebaseFirestore.instance.collection('routes').doc(routeName).get();
    if (docSnapshot.exists) {
      final stops = List<String>.from(docSnapshot['stops']);
      setState(() {
        stopsForSelectedRoute = stops;
        startStopController.clear();
        endStopController.clear();
        filteredDestinationStops = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalization.of(context)!;
    String formattedDateTime = DateFormat("d MMM, yyyy | hh:mm a").format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(tr.translate("ticket_details")),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
                    RawAutocomplete<String>(
                      textEditingController: routeController,
                      focusNode: routeFocusNode,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        final input = textEditingValue.text.toLowerCase();
                        return input.isEmpty
                            ? allRoutes
                            : allRoutes.where((route) => route.toLowerCase().contains(input));
                      },
                      fieldViewBuilder: (context, controller, focusNode, _) {
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.directions_bus, color: Colors.green),
                            hintText: tr.translate("select_or_enter_route"),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? tr.translate("enter_route_error") : null,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              fetchStopsForRoute(value.trim());
                            }
                          },
                        );
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return _buildOptionsDropdown(onSelected, options);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: startStopController,
                      icon: Icons.radio_button_off,
                      hint: tr.translate("enter_starting_stop"),
                      errorMsg: tr.translate("enter_starting_stop_error"),
                    ),
                    const SizedBox(height: 20),
                    RawAutocomplete<String>(
                      textEditingController: endStopController,
                      focusNode: FocusNode(),
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return filteredDestinationStops.where((String option) {
                          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      fieldViewBuilder: (context, controller, focusNode, _) {
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.radio_button_checked, color: Colors.green),
                            hintText: tr.translate("enter_destination_stop"),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? tr.translate("enter_destination_stop_error") : null,
                        );
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return _buildOptionsDropdown(onSelected, options);
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildModeButton(tr.translate("by_fare"), "By Fare"),
                        const SizedBox(width: 10),
                        _buildModeButton(tr.translate("by_ending_stop"), "By Ending stop"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(tr.translate("select_tickets"),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    _buildTicketCounter(tr.translate("full"), fullTickets,
                            (val) => setState(() => fullTickets = val)),
                    _buildTicketCounter(tr.translate("half"), halfTickets,
                            (val) => setState(() => halfTickets = val)),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  tr.translate("pay"),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsDropdown(onSelected, Iterable<String> options) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: options.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final option = options.elementAt(index);
            return ListTile(
              title: Text(option),
              onTap: () => onSelected(option),
            );
          },
        ),
      ),
    );
  }

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
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) => value == null || value.isEmpty ? errorMsg : null,
    );
  }

  Widget _buildModeButton(String label, String value) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => setState(() => selectedMode = value),
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedMode == value ? Colors.green : Colors.white,
          foregroundColor: selectedMode == value ? Colors.white : Colors.black,
          side: const BorderSide(color: Colors.green),
        ),
        child: Text(label),
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
                child: Text("$count",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
        child: Text(text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final passData = {
          "userId": user.uid,
          "route": routeController.text.trim(),
          "boardingStop": startStopController.text.trim(),
          "destinationStop": endStopController.text.trim(),
          "passType": routeController.text.trim(),
          "fullTickets": fullTickets,
          "halfTickets": halfTickets,
          "paymentMethod": selectedPaymentMethod,
          "timestamp": FieldValue.serverTimestamp(),
        };

        double totalAmount = (fullTickets * 15) + (halfTickets * 10);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              amount: totalAmount.toString(),
              from: startStopController.text.trim(),
              to: endStopController.text.trim(),
              passType: routeController.text.trim(),
              ticketCount: fullTickets + halfTickets,
              isbuspass: false,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    routeController.dispose();
    routeFocusNode.dispose();
    startStopController.dispose();
    endStopController.dispose();
    super.dispose();
  }
}
