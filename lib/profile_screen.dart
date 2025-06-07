// import 'package:flutter/material.dart';
// import 'package:digital_bus_pass_system/home_screen.dart';
//
// class  ProfileScreen extends StatelessWidget {
//   final String ticketDetails; // You can pass ticket details if needed
//
//   const ProfileScreen ({Key? key, required this.ticketDetails}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.teal,
//           title: const Text('My profile')),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Profile Update Section
//           Container(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.grey[300],
//                   child: Icon(Icons.person, size: 40, color: Colors.black54),
//                 ),
//                 SizedBox(width: 10),
//                 Text(
//                   "Click here to update your profile",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//
//           Divider(),
//
//           // Menu Items
//           menuItem(context, Icons.confirmation_number, "My Tickets", () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => TicketsScreen()),
//             );
//           }),
//           menuItem(context, Icons.report_problem, "Complaints", () {
//             // Navigate to Complaints screen
//           }),
//           menuItem(context, Icons.share, "Share app", () {
//             // Code to share app
//           }),
//           menuItem(context, Icons.star, "Rate Us", () {
//             // Code to open app rating page
//           }),
//
//           Spacer(),
//
//           // Bottom Text
//           // Padding(
//           //   padding: const EdgeInsets.all(16.0),
//           //   child: Text(
//           //     style: TextStyle(color: Colors.grey),
//           //   ),
//           // ),
//         ],
//       ),
//
//       // Bottom Navigation Bar
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Colors.teal,
//         unselectedItemColor: Colors.black54,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Buses"),
//           BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help"),
//         ],
//       ),
//     );
//   }
//
//   // Custom ListTile for Menu Items
//   Widget menuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, size: 30),
//       title: Text(title, style: TextStyle(fontSize: 18)),
//       onTap: onTap,
//     );
//   }
// }
//
// // Sample My Tickets Screen
// class TicketsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("My Tickets")),
//       body: Center(
//         child: Text("Your ticket details will appear here."),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:digital_bus_pass_system/home_screen.dart';
// import 'package:digital_bus_pass_system/login_screen.dart';
//
// import 'Bus Ticket/view_ticket_screen.dart'; // <-- Make sure this import is correct
//
// class ProfileScreen extends StatelessWidget {
//   final String ticketDetails;
//
//   const ProfileScreen({Key? key, required this.ticketDetails}) : super(key: key);
//
//   // Show confirmation dialog before logout
//   void _confirmLogout(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Confirm Logout"),
//         content: const Text("Are you sure you want to exit the app?"),
//         actions: [
//           TextButton(
//             child: const Text("No"),
//             onPressed: () => Navigator.of(context).pop(), // Dismiss dialog
//           ),
//           TextButton(
//             child: const Text("Yes"),
//             onPressed: () async {
//               Navigator.of(context).pop(); // Close dialog
//               await FirebaseAuth.instance.signOut();
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => const LoginScreen()),
//                     (Route<dynamic> route) => false,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: const Text('My profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             tooltip: 'Logout',
//             onPressed: () => _confirmLogout(context),
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Profile Update Section
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.grey[300],
//                   child: const Icon(Icons.person, size: 40, color: Colors.black54),
//                 ),
//                 const SizedBox(width: 10),
//                 const Text(
//                   "Click here to update your profile",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//
//           const Divider(),
//
//           // Menu Items
//           menuItem(context, Icons.confirmation_number, "My Tickets", () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ViewTicketScreen()),
//             );
//           }),
//           menuItem(context, Icons.report_problem, "Complaints", () {
//             // Navigate to Complaints screen
//           }),
//           menuItem(context, Icons.share, "Share app", () {
//             // Code to share app
//           }),
//           menuItem(context, Icons.star, "Rate Us", () {
//             // Code to open app rating page
//           }),
//
//           const Spacer(),
//         ],
//       ),
//
//       // Bottom Navigation Bar
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Colors.teal,
//         unselectedItemColor: Colors.black54,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Buses"),
//           BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help"),
//         ],
//       ),
//     );
//   }
//
//   // Custom ListTile for Menu Items
//   Widget menuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, size: 30),
//       title: Text(title, style: const TextStyle(fontSize: 18)),
//       onTap: onTap,
//     );
//   }
// }
//
// // Sample My Tickets Screen
// class TicketsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("My Tickets")),
//       body: const Center(
//         child: Text("Your ticket details will appear here."),
//       ),
//     );
//   }
// }

// import 'package:digital_bus_pass_system/Bus%20Ticket/view_ticket_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:digital_bus_pass_system/home_screen.dart';
// import 'package:digital_bus_pass_system/login_screen.dart';
//
// class ProfileScreen extends StatelessWidget {
//   final String ticketDetails;
//
//   const ProfileScreen({Key? key, required this.ticketDetails}) : super(key: key);
//
//   // Show confirmation dialog before logout
//   void _confirmLogout(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Confirm Logout"),
//         content: const Text("Are you sure you want to exit the app?"),
//         actions: [
//           TextButton(
//             child: const Text("No"),
//             onPressed: () => Navigator.of(context).pop(), // Dismiss dialog
//           ),
//           TextButton(
//             child: const Text("Yes"),
//             onPressed: () async {
//               Navigator.of(context).pop(); // Close dialog
//               await FirebaseAuth.instance.signOut();
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => const LoginScreen()),
//                     (Route<dynamic> route) => false,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: const Text('My profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             tooltip: 'Logout',
//             onPressed: () => _confirmLogout(context),
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Profile Update Section
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.grey[300],
//                   child: const Icon(Icons.person, size: 40, color: Colors.black54),
//                 ),
//                 const SizedBox(width: 10),
//                 const Text(
//                   "Click here to update your profile",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//
//           const Divider(),
//
//           // Menu Items
//           menuItem(context, Icons.confirmation_number, "My Tickets", () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ViewTicketScreen(ticketDetails: ticketDetails)),
//             );
//           }),
//           menuItem(context, Icons.report_problem, "Complaints", () {
//             // Navigate to Complaints screen
//           }),
//           menuItem(context, Icons.share, "Share app", () {
//             // Code to share app
//           }),
//           menuItem(context, Icons.star, "Rate Us", () {
//             // Code to open app rating page
//           }),
//
//           const Spacer(),
//         ],
//       ),
//
//       // Bottom Navigation Bar
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Colors.teal,
//         unselectedItemColor: Colors.black54,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Buses"),
//           BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help"),
//         ],
//       ),
//     );
//   }
//
//   // Custom ListTile for Menu Items
//   Widget menuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, size: 30),
//       title: Text(title, style: const TextStyle(fontSize: 18)),
//       onTap: onTap,
//     );
//   }
// }
//
// // ✅ Ticket screen you want to show
// class TicketsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("My Tickets")),
//       body: const Center(
//         child: Text("Your ticket details will appear here."),
//       ),
//     );
//   }
// }

// import 'package:digital_bus_pass_system/Bus%20Ticket/view_ticket_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:digital_bus_pass_system/home_screen.dart';
// import 'package:digital_bus_pass_system/login_screen.dart';
//
// class ProfileScreen extends StatelessWidget {
//   final String ticketDetails;
//
//   const ProfileScreen({Key? key, required this.ticketDetails}) : super(key: key);
//
//   void _confirmLogout(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Confirm Logout"),
//         content: const Text("Are you sure you want to exit the app?"),
//         actions: [
//           TextButton(
//             child: const Text("No"),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           TextButton(
//             child: const Text("Yes"),
//             onPressed: () async {
//               Navigator.of(context).pop();
//               await FirebaseAuth.instance.signOut();
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => const LoginScreen()),
//                     (Route<dynamic> route) => false,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _navigateToUserProfile(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const UserProfileScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: const Text('My profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             tooltip: 'Logout',
//             onPressed: () => _confirmLogout(context),
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           InkWell(
//             onTap: () => _navigateToUserProfile(context),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.grey[300],
//                     child: const Icon(Icons.person, size: 40, color: Colors.black54),
//                   ),
//                   const SizedBox(width: 10),
//                   const Text(
//                     "Click here to update your profile",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const Divider(),
//           menuItem(context, Icons.confirmation_number, "My Tickets", () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ViewTicketScreen(ticketDetails: ticketDetails)),
//             );
//           }),
//           menuItem(context, Icons.report_problem, "Complaints", () {}),
//           menuItem(context, Icons.share, "Share app", () {}),
//           menuItem(context, Icons.star, "Rate Us", () {}),
//           const Spacer(),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Colors.teal,
//         unselectedItemColor: Colors.black54,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Buses"),
//           BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help"),
//         ],
//       ),
//     );
//   }
//
//   Widget menuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, size: 30),
//       title: Text(title, style: const TextStyle(fontSize: 18)),
//       onTap: onTap,
//     );
//   }
// }
//
// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({super.key});
//
//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends State<UserProfileScreen> {
//   String name = "";
//   String email = "";
//   String phone = "";
//   String selectedLanguage = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final doc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
//       if (doc.exists) {
//         setState(() {
//           name = doc['name'] ?? "";
//           email = doc['email'] ?? "";
//           phone = doc['phone'] ?? "";
//         });
//       }
//     }
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       selectedLanguage = prefs.getString('selectedLanguage') ?? "English";
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("User Profile")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Name: $name", style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 8),
//             Text("Email: $email", style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 8),
//             Text("Phone: $phone", style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 8),
//             Text("Selected Language: $selectedLanguage", style: const TextStyle(fontSize: 18)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:digital_bus_pass_system/Bus%20Ticket/view_ticket_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:digital_bus_pass_system/home_screen.dart';
// import 'package:digital_bus_pass_system/login_screen.dart';
//
// class ProfileScreen extends StatelessWidget {
//   final String ticketDetails;
//
//   const ProfileScreen({Key? key, required this.ticketDetails}) : super(key: key);
//
//   void _confirmLogout(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Confirm Logout"),
//         content: const Text("Are you sure you want to exit the app?"),
//         actions: [
//           TextButton(
//             child: const Text("No"),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           TextButton(
//             child: const Text("Yes"),
//             onPressed: () async {
//               Navigator.of(context).pop();
//               await FirebaseAuth.instance.signOut();
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => const LoginScreen()),
//                     (Route<dynamic> route) => false,
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _navigateToUserProfile(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const UserProfileScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: const Text('My Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             tooltip: 'Logout',
//             onPressed: () => _confirmLogout(context),
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           InkWell(
//             onTap: () => _navigateToUserProfile(context),
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.grey[300],
//                     child: const Icon(Icons.person, size: 40, color: Colors.black54),
//                   ),
//                   const SizedBox(width: 10),
//                   const Text(
//                     "Click here to view your profile",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const Divider(),
//           menuItem(context, Icons.confirmation_number, "My Tickets", () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ViewTicketScreen(ticketDetails: ticketDetails)),
//             );
//           }),
//           menuItem(context, Icons.report_problem, "Complaints", () {}),
//           menuItem(context, Icons.share, "Share app", () {}),
//           menuItem(context, Icons.star, "Rate Us", () {}),
//           const Spacer(),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         selectedItemColor: Colors.teal,
//         unselectedItemColor: Colors.black54,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Buses"),
//           BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help"),
//         ],
//       ),
//     );
//   }
//
//   Widget menuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
//     return ListTile(
//       leading: Icon(icon, size: 30),
//       title: Text(title, style: const TextStyle(fontSize: 18)),
//       onTap: onTap,
//     );
//   }
// }
//
// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends State<UserProfileScreen> {
//   String name = "";
//   String email = "";
//   String phone = "";
//   String selectedLanguage = "";
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         final doc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
//         if (doc.exists) {
//           final data = doc.data();
//           if (data != null) {
//             setState(() {
//               name = data['name'] ?? "N/A";
//               email = data['email'] ?? user.email ?? "N/A";
//               phone = data['phone'] ?? "N/A";
//             });
//           }
//         }
//       } catch (e) {
//         // Handle error
//         print("Error loading user data: $e");
//       }
//     }
//
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       selectedLanguage = prefs.getString('selectedLanguage') ?? "English";
//       isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("User Profile")),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             profileField("Name", name),
//             profileField("Email", email),
//             profileField("Phone", phone),
//             profileField("Selected Language", selectedLanguage),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget profileField(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Text(
//         "$title: $value",
//         style: const TextStyle(fontSize: 18),
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digital_bus_pass_system/Bus%20Ticket/view_ticket_screen.dart';
import 'package:digital_bus_pass_system/home_screen.dart';
import 'package:digital_bus_pass_system/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String ticketDetails;

  const ProfileScreen({Key? key, required this.ticketDetails}) : super(key: key);

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to exit the app?"),
        actions: [
          TextButton(
            child: const Text("No"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Yes"),
            onPressed: () async {
              Navigator.of(context).pop();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToUserProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _navigateToUserProfile(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, size: 40, color: Colors.black54),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Click here to view your profile",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          menuItem(context, Icons.confirmation_number, "My Tickets", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewTicketScreen(ticketDetails: ticketDetails)),
            );
          }),
          menuItem(context, Icons.report_problem, "Complaints", () {}),
          menuItem(context, Icons.share, "Share app", () {}),
          menuItem(context, Icons.star, "Rate Us", () {}),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Buses"),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help"),
        ],
      ),
    );
  }

  Widget menuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      onTap: onTap,
    );
  }
}

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String name = "";
  String email = "";
  String phone = "";
  String selectedLanguage = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data();
          if (data != null) {
            setState(() {
              name = data['name'] ?? "N/A";
              email = data['email'] ?? user.email ?? "N/A";
              phone = data['phone'] ?? "N/A";
            });
          } else {
            _showSnackBar("User data is missing.");
          }
        } else {
          _showSnackBar("User profile not found in Firestore.");
        }
      } catch (e) {
        print("Error loading user data: $e");
        _showSnackBar("Failed to load user data.");
      }
    }

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('selectedLanguage') ?? "English";
      isLoading = false;
    });
  }

  void _showSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profileField("Name", name),
            profileField("Email", email),
            profileField("Phone", phone),
            profileField("Selected Language", selectedLanguage),
          ],
        ),
      ),
    );
  }

  Widget profileField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        "$title: $value",
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}

