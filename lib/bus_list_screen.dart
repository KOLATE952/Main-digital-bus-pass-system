import 'package:flutter/material.dart';

class BusListScreen extends StatelessWidget {
  final List<String> busRoutes = [
    '68: Upper Depot - Sutardara',
    '118: Swargate - Charwad Wasti (Sinhgad College)',
    '183: Hadapsar Gadital - Kesnand Phata Wagholi',
    '158: Lohgaon - Manapa Dengle Pul',
    '109: Manapa Bhavan To Manapa Bhavan (Ring Route)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bus Routes')),
      body: ListView.builder(
        itemCount: busRoutes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.directions_bus),
            title: Text(busRoutes[index]),
          );
        },
      ),
    );
  }
}
