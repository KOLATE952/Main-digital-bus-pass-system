import 'package:flutter/material.dart';
import 'package:digital_bus_pass_system/home_screen.dart';

class  ProfileScreen extends StatelessWidget {
  final String ticketDetails; // You can pass ticket details if needed

  const ProfileScreen ({Key? key, required this.ticketDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('My profile')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Update Section
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 40, color: Colors.black54),
                ),
                SizedBox(width: 10),
                Text(
                  "Click here to update your profile",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Divider(),

          // Menu Items
          menuItem(context, Icons.confirmation_number, "My Tickets", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TicketsScreen()),
            );
          }),
          menuItem(context, Icons.report_problem, "Complaints", () {
            // Navigate to Complaints screen
          }),
          menuItem(context, Icons.share, "Share app", () {
            // Code to share app
          }),
          menuItem(context, Icons.star, "Rate Us", () {
            // Code to open app rating page
          }),

          Spacer(),

          // Bottom Text
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Text(
          //     style: TextStyle(color: Colors.grey),
          //   ),
          // ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.black54,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Buses"),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help"),
        ],
      ),
    );
  }

  // Custom ListTile for Menu Items
  Widget menuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(title, style: TextStyle(fontSize: 18)),
      onTap: onTap,
    );
  }
}

// Sample My Tickets Screen
class TicketsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Tickets")),
      body: Center(
        child: Text("Your ticket details will appear here."),
      ),
    );
  }
}