import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RouteTimetableScreen extends StatelessWidget {
  final String routeId;

  const RouteTimetableScreen({Key? key, required this.routeId}) : super(key: key);

  Future<Map<String, dynamic>> fetchRouteData(String routeId) async {
    if (routeId.isEmpty) {
      throw Exception("Route ID cannot be empty");
    }

    final doc = await FirebaseFirestore.instance.collection('routes').doc(routeId).get();
    if (doc.exists) {
      return doc.data()!;
    } else {
      throw Exception("Route not found for ID: $routeId");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if routeId is empty right away and show error UI
    if (routeId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Route Timetable")),
        body: const Center(child: Text("Error: Route ID cannot be empty")),
      );
    }

    // Base time (change as needed)
    final DateTime baseTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      9,
      0,
    ); // 9:00 AM today

    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Timetable"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchRouteData(routeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No data found"));
          }

          final routeData = snapshot.data!;
          final stops = List<Map<String, dynamic>>.from(routeData['stops']);

          return ListView.separated(
            itemCount: stops.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final stop = stops[index];
              final arrivalOffsetMin = stop['arrival_offset_min'] as int;
              final arrivalTime = baseTime.add(Duration(minutes: arrivalOffsetMin));
              final formattedTime = DateFormat('hh:mm a').format(arrivalTime);

              return ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(stop['name']),
                subtitle: Text("Arrival Time: $formattedTime"),
              );
            },
          );
        },
      ),
    );
  }
}
