// TODO Implement this library.
import 'package:flutter/material.dart';

class PassHistoryScreen extends StatelessWidget {
  // Sample list of past passes (this would ideally come from your Firebase or database)
  final List<Map<String, String>> pastPasses = [
    {
      'date': '2025-04-30',
      'route': 'Katraj To KJEI Campus',
      'time': '9:30 AM',
      'type': 'Daily Pass',
    },
    {
      'date': '2025-04-29',
      'route': 'KJEI Campus To Katraj',
      'time': '6:45 PM',
      'type': 'Monthly Pass',
    },
    {
      'date': '2025-04-28',
      'route': 'KJEI Campus To Iskon Temple',
      'time': '4:00 PM',
      'type': 'Daily Pass',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pass History'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: pastPasses.length,
        itemBuilder: (context, index) {
          final pass = pastPasses[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pass['type'] ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("Date: ${pass['date']}"),
                  Text("Time: ${pass['time']}"),
                  Text("Route: ${pass['route']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
