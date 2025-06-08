//
//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:digital_bus_pass_system/localizations/app_localizations.dart';
//
// import 'package:digital_bus_pass_system/Bus Ticket/bus_pass_form.dart';
// import 'package:digital_bus_pass_system/Bus Ticket/daily_pass_screen.dart';
// import 'package:digital_bus_pass_system/Bus Ticket/monthly_pass.dart';
// import 'package:digital_bus_pass_system/Bus Ticket/view_ticket_screen.dart';
// import 'package:digital_bus_pass_system/Bus Ticket/view_pass_screen.dart';
// import 'package:digital_bus_pass_system/Bus Ticket/route_timetable_screen.dart';
//
// import 'package:digital_bus_pass_system/gmap_screen.dart';
// import 'package:digital_bus_pass_system/notification_screen.dart';
// import 'package:digital_bus_pass_system/notification_manager.dart';
// import 'package:digital_bus_pass_system/profile_screen.dart';
// import 'package:digital_bus_pass_system/bus_list_screen.dart'; // ✅ Add this import
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final NotificationManager _notificationManager = NotificationManager();
//   final FirebaseInAppMessaging _fiam = FirebaseInAppMessaging.instance;
//
//   int _selectedIndex = 0; // ✅ Track selected index
//
//   @override
//   void initState() {
//     super.initState();
//     _checkPassExpiryAndNotify();
//   }
//
//   Future<void> _checkPassExpiryAndNotify() async {
//     try {
//       final String? notificationMessage = await _notificationManager.checkForExpiredPassesAndNotify();
//
//       if (notificationMessage != null && notificationMessage.isNotEmpty) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(notificationMessage),
//               duration: const Duration(seconds: 4),
//               backgroundColor: Colors.redAccent,
//             ),
//           );
//         }
//         _fiam.triggerEvent('show_expiry_warning');
//       }
//     } catch (e) {
//       debugPrint('Error in pass expiry notification: $e');
//     }
//   }
//
//   Stream<int> getUnreadNotificationCountStream() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return Stream.value(0);
//
//     return FirebaseFirestore.instance
//         .collection('passHistory')
//         .doc(user.uid)
//         .collection('Notifications')
//         .where('read', isEqualTo: false)
//         .snapshots()
//         .map((snapshot) => snapshot.docs.length);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final tr = AppLocalization.of(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(tr.translate('home')),
//         actions: [
//           StreamBuilder<int>(
//             stream: getUnreadNotificationCountStream(),
//             builder: (context, snapshot) {
//               final count = snapshot.data ?? 0;
//               return Stack(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.notifications),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => NotificationScreen()),
//                       );
//                     },
//                   ),
//                   if (count > 0)
//                     Positioned(
//                       right: 11,
//                       top: 11,
//                       child: Container(
//                         padding: const EdgeInsets.all(2),
//                         decoration: BoxDecoration(
//                           color: Colors.redAccent,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         constraints: const BoxConstraints(
//                           minWidth: 16,
//                           minHeight: 16,
//                         ),
//                         child: Text(
//                           '$count',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),
//                 ],
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.account_circle),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ProfileScreen(ticketDetails: '')),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildFeatureCard(
//                   context,
//                   Icons.confirmation_number,
//                   tr.translate('bus_ticket'),
//                       () => Navigator.push(context, MaterialPageRoute(builder: (_) => BusPassFormScreen())),
//                 ),
//                 _buildFeatureCard(
//                   context,
//                   Icons.account_box,
//                   tr.translate('daily_pass'),
//                       () => Navigator.push(context, MaterialPageRoute(builder: (_) => DailyPassScreen())),
//                 ),
//                 _buildFeatureCard(
//                   context,
//                   Icons.account_box,
//                   tr.translate('Monthly_pass'),
//                       () => Navigator.push(context, MaterialPageRoute(builder: (_) => MonthlyPassScreen())),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildFeatureCard(
//                   context,
//                   Icons.receipt,
//                   tr.translate('view_ticket'),
//                       () => Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => ViewTicketScreen(ticketDetails: 'no details yet')),
//                   ),
//                 ),
//                 _buildFeatureCard(
//                   context,
//                   Icons.card_membership,
//                   tr.translate('view_pass'),
//                       () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewPassScreen())),
//                 ),
//                 _buildFeatureCard(
//                   context,
//                   Icons.route,
//                   tr.translate('route_timetable'),
//                       () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RouteTimetableScreen())),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     tr.translate('near_me'),
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const ListTile(
//                     leading: Icon(Icons.directions_bus),
//                     title: Text('K J College Bus Stop'),
//                     subtitle: Text('No upcoming buses at this stop.'),
//                     trailing: Text('105 m'),
//                   ),
//                   TextButton(
//                     onPressed: () {}, // Optional functionality
//                     child: const Text('See More Buses'),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             ListTile(
//               leading: const Icon(Icons.map, color: Colors.blue),
//               title: Text(tr.translate('google_map')),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (_) => GMapPage()));
//               },
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//
//           if (index == 1) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => BusListScreen()),
//             );
//           }
//         },
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.directions_bus), label: 'Buses'),
//           BottomNavigationBarItem(icon: Icon(Icons.question_mark_rounded), label: 'Help'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFeatureCard(BuildContext context, IconData icon, String title, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 80,
//         height: 80,
//         decoration: BoxDecoration(
//           color: Colors.blue[50],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 30, color: Colors.black),
//             const SizedBox(height: 5),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digital_bus_pass_system/localizations/app_localizations.dart';

import 'package:digital_bus_pass_system/Bus Ticket/bus_pass_form.dart';
import 'package:digital_bus_pass_system/Bus Ticket/daily_pass_screen.dart';
import 'package:digital_bus_pass_system/Bus Ticket/monthly_pass.dart';
import 'package:digital_bus_pass_system/Bus Ticket/view_ticket_screen.dart'; // ✅ Correct import for ViewTicketScreen
import 'package:digital_bus_pass_system/Bus Ticket/view_pass_screen.dart';
import 'package:digital_bus_pass_system/Bus Ticket/route_timetable_screen.dart';

import 'package:digital_bus_pass_system/gmap_screen.dart'; // ✅ Correct import for GMapPage
import 'package:digital_bus_pass_system/notification_screen.dart';
import 'package:digital_bus_pass_system/notification_manager.dart';
import 'package:digital_bus_pass_system/profile_screen.dart';
import 'package:digital_bus_pass_system/bus_list_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationManager _notificationManager = NotificationManager();
  final FirebaseInAppMessaging _fiam = FirebaseInAppMessaging.instance;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkPassExpiryAndNotify();
  }

  Future<void> _checkPassExpiryAndNotify() async {
    try {
      final String? notificationMessage = await _notificationManager.checkForExpiredPassesAndNotify();

      if (notificationMessage != null && notificationMessage.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(notificationMessage),
              duration: const Duration(seconds: 4),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        _fiam.triggerEvent('show_expiry_warning');
      }
    } catch (e) {
      debugPrint('Error in pass expiry notification: $e');
    }
  }

  Stream<int> getUnreadNotificationCountStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value(0);

    return FirebaseFirestore.instance
        .collection('passHistory')
        .doc(user.uid)
        .collection('Notifications')
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalization.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(tr.translate('home')),
        actions: [
          StreamBuilder<int>(
            stream: getUnreadNotificationCountStream(),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotificationScreen()),
                      );
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      right: 11,
                      top: 11,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen(ticketDetails: '')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureCard(
                  context,
                  Icons.confirmation_number,
                  tr.translate('bus_ticket'),
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => BusPassFormScreen())),
                ),
                _buildFeatureCard(
                  context,
                  Icons.account_box,
                  tr.translate('daily_pass'),
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => DailyPassScreen())),
                ),
                _buildFeatureCard(
                  context,
                  Icons.account_box,
                  tr.translate('Monthly_pass'),
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => MonthlyPassScreen())),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureCard(
                  context,
                  Icons.receipt,
                  tr.translate('view_ticket'),
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ViewTicketScreen(ticketDetails: 'no details yet')),
                  ),
                ),
                _buildFeatureCard(
                  context,
                  Icons.card_membership,
                  tr.translate('view_pass'),
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewPassScreen())),
                ),
                _buildFeatureCard(
                  context,
                  Icons.route,
                  tr.translate('route_timetable'),
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RouteTimetableScreen())),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr.translate('near_me'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const ListTile(
                    leading: Icon(Icons.directions_bus),
                    title: Text('K J College Bus Stop'),
                    subtitle: Text('No upcoming buses at this stop.'),
                    trailing: Text('105 m'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See More Buses'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.blue),
              title: Text(tr.translate('google_map')),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => GMapPage()));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BusListScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_bus), label: 'Buses'),
          BottomNavigationBarItem(icon: Icon(Icons.question_mark_rounded), label: 'Help'),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.black),
            const SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
