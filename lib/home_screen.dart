// import 'package:digital_bus_pass_system/Bus%20Ticket/route_timetable_screen.dart';
// import 'package:digital_bus_pass_system/Bus%20Ticket/view_pass_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:digital_bus_pass_system/localizations/app_localizations.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'Bus Ticket/daily_pass_screen.dart';
// import 'Bus Ticket/monthly_pass.dart';
// import 'Bus Ticket/view_ticket_screen.dart';
// import 'gmap_screen.dart';
// import 'notification_screen.dart';
// import 'profile_screen.dart';
// import 'Bus Ticket/bus_pass_form.dart';
// import 'voice_assistant/voice_assistant.dart';
//
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//   VoiceAssistant voiceAssistant = VoiceAssistant();
//
//   @override
//   void initState() {
//     super.initState();
//     voiceAssistant.init();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final tr = AppLocalizations.of(context)!;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(tr.translate('home')),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => NotificationScreen()),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.account_circle),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ProfileScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//
//             // Feature Cards Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildFeatureCard(
//                   context,
//                   Icons.directions_bus,
//                   tr.translate('bus_pass'),
//                   () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => BusPassForm()),
//                     );
//                   },
//                 ),
//                 _buildFeatureCard(
//                   context,
//                   Icons.calendar_today,
//                   tr.translate('daily_pass'),
//                   () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => DailyPassScreen()),
//                     );
//                   },
//                 ),
//                 _buildFeatureCard(
//                   context,
//                   Icons.calendar_view_month,
//                   tr.translate('monthly_pass'),
//                   () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => MonthlyPassScreen()),
//                     );
//                   },
//                 ),
//                 _buildFeatureCard(
//                   context,
//                   Icons.card_membership,
//                   tr.translate('view_pass'),
//                   () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ViewPassScreen()),
//                     );
//                   },
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//
//             // Near Me Box
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     tr.translate('near_me'),
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   ListTile(
//                     leading: const Icon(Icons.directions_bus),
//                     title: Text(tr.translate('bus_stop')),
//                     subtitle: Text(tr.translate('nearest_stop_name')),
//                     trailing: Text('200 m'),
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.directions_subway),
//                     title: Text(tr.translate('metro_station')),
//                     subtitle: Text(tr.translate('nearest_station_name')),
//                     trailing: Text('500 m'),
//                   ),
//                   ListTile(
//                     leading: const Icon(Icons.directions_bike),
//                     title: Text(tr.translate('bike_stand')),
//                     subtitle: Text(tr.translate('nearest_bike_stand')),
//                     trailing: Text('350 m'),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Google Map Tile
//             ListTile(
//               leading: const Icon(Icons.map, color: Colors.blue),
//               title: Text(tr.translate('google_map')), // ✅
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => GMapPage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           const BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: IconButton(
//               icon: const Icon(Icons.directions_bus),
//               onPressed: () {
//                 // Navigate to BusListScreen when bus icon is tapped
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BusListScreen()),
//                 );
//               },
//             ),
//             label: 'Buses',
//           ),
//           BottomNavigationBarItem(
//             icon: IconButton(
//               icon: const Icon(Icons.mic),
//               onPressed: () {
//                 voiceAssistant.startListening(context);
//               },
//             ),
//             label: 'Help',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFeatureCard(
//       BuildContext context, IconData icon, String title, VoidCallback onTap) {
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

// -----------------------------------------------------------------------
// The uncommented portion starts here:
import 'package:digital_bus_pass_system/Bus Ticket/route_timetable_screen.dart';
import 'package:digital_bus_pass_system/Bus Ticket/view_pass_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digital_bus_pass_system/localizations/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:digital_bus_pass_system/Bus Ticket/daily_pass_screen.dart';
import 'Bus Ticket/monthly_pass.dart';
import 'Bus Ticket/view_ticket_screen.dart';
import 'gmap_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'Bus Ticket/bus_pass_form.dart';
import 'voice_assistant/voice_assistant.dart';
import 'bus_list_screen.dart'; // ← Newly added import

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationManager _notificationManager = NotificationManager();
  final FirebaseInAppMessaging _fiam = FirebaseInAppMessaging.instance;

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
    final tr = AppLocalization.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('home')),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Feature Cards Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFeatureCard(
                  context,
                  Icons.directions_bus,
                  tr.translate('bus_pass'),
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BusPassFormScreen()),
                    );
                  },
                ),
                _buildFeatureCard(
                  context,
                  Icons.calendar_today,
                  tr.translate('daily_pass'),
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DailyPassScreen()),
                    );
                  },
                ),
                _buildFeatureCard(
                  context,
                  Icons.calendar_view_month,
                  tr.translate('monthly_pass'),
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MonthlyPassScreen()),
                    );
                  },
                ),
                _buildFeatureCard(
                  context,
                  Icons.card_membership,
                  tr.translate('view_pass'),
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewPassScreen()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Near Me Box
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr.translate('near_me'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.directions_bus),
                    title: Text(tr.translate('bus_stop')),
                    subtitle: Text(tr.translate('nearest_stop_name')),
                    trailing: const Text('200 m'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.directions_subway),
                    title: Text(tr.translate('metro_station')),
                    subtitle: Text(tr.translate('nearest_station_name')),
                    trailing: const Text('500 m'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.directions_bike),
                    title: Text(tr.translate('bike_stand')),
                    subtitle: Text(tr.translate('nearest_bike_stand')),
                    trailing: const Text('350 m'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Google Map Tile
            ListTile(
              leading: const Icon(Icons.map, color: Colors.blue),
              title: Text(tr.translate('google_map')),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GMapPage()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.directions_bus),
              onPressed: () {
                // Navigate to BusListScreen when the Bus tab is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BusListScreen()),
                );
              },
            ),
            label: 'Buses',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.mic),
              onPressed: () {
                voiceAssistant.startListening(context);
              },
            ),
            label: 'Help',
          ),
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
