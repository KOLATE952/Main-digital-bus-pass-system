// import 'package:flutter/material.dart';
// import 'package:digital_bus_pass_system/home_screen.dart';
//
// class ViewPassScreen extends StatelessWidget {
//   final String passDetails; // You can pass ticket details if needed
//
//   const ViewPassScreen({Key? key, required this.passDetails}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.teal,
//           title: const Text('Your pass')),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Pass Details:',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 passDetails,
//                 style: TextStyle(fontSize: 18),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:digital_bus_pass_system/home_screen.dart';
import 'package:digital_bus_pass_system/passDB/pass_history_screen.dart'; // import the history screen

class ViewPassScreen extends StatelessWidget {
  final String passDetails;

  const ViewPassScreen({Key? key, required this.passDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Your Pass'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pass Details:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                passDetails,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PassHistoryScreen()),
                  );
                },
                child: Text("View Pass History"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

