import 'package:digital_bus_pass_system/Bus%20Ticket/view_pass_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digital_bus_pass_system/Bus%20Ticket/view_ticket_screen.dart';
import 'package:digital_bus_pass_system/home_screen.dart';
import 'package:digital_bus_pass_system/login_screen.dart';
import 'package:digital_bus_pass_system/multilang_screen.dart';
import 'userprofile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String ticketDetails;

  const ProfileScreen({Key? key, required this.ticketDetails}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultilangScreen(
          onLanguageSelected: (locale) {},
        ),
      ),
    );
  }

  void _navigateToUserProfile(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileScreen(uid: currentUser.uid), // ✅ PASS UID
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No user logged in")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'User Profile',
            onPressed: () => _navigateToUserProfile(context),
          ),
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
          const Divider(),
          menuItem(context, Icons.confirmation_number, "My Tickets", () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ViewTicketScreen(ticketDetails: widget.ticketDetails),
              ),
            );
          }),
          menuItem(context, Icons.card_membership, "My Pass", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewPassScreen()),
            );
          }),
          menuItem(context, Icons.settings, "Settings", () => _navigateToSettings(context)),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Help section coming soon")),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.directions_bus), label: "Buses"),
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
