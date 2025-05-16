import 'package:digital_bus_pass_system/Bus%20Ticket/route_timetable_screen.dart';
import 'package:digital_bus_pass_system/Bus%20Ticket/view_pass_screen.dart';
import 'package:flutter/material.dart';
import 'package:digital_bus_pass_system/localizations/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:digital_bus_pass_system/Bus%20Ticket/daily_pass_screen.dart';
import 'Bus Ticket/monthly_pass.dart';
import 'Bus Ticket/view_ticket_screen.dart';
import 'gmap_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';
import 'Bus Ticket/bus_pass_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final tr = AppLocalization.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(tr.translate('home')),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(ticketDetails: ''),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(ticketDetails: ''),
                ),
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
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BusPassFormScreen()),
                    );
                  },
                ),
                _buildFeatureCard(
                  context,
                  Icons.account_box,
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
                  Icons.account_box,
                  tr.translate('Monthly_pass'),
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MonthlyPassScreen()),
                    );
                  },
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
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewTicketScreen(ticketDetails: 'no details yet')),
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
                _buildFeatureCard(
                  context,
                  Icons.route,
                  tr.translate('route_timetable'),
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RouteTimetableScreen()),
                    );
                  },
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
