import 'package:flutter/material.dart';
import 'package:digital_bus_pass_system/home_screen.dart';

class  NotificationScreen extends StatelessWidget {
  final String ticketDetails; // You can pass ticket details if needed

  const NotificationScreen ({Key? key, required this.ticketDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Notifications')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No Notification available right now',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 10),
              Text(
                ticketDetails,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
