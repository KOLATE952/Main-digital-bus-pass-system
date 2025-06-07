import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RouteTimetableScreen extends StatefulWidget {
  const RouteTimetableScreen({Key? key}) : super(key: key);

  @override
  _RouteTimetableScreenState createState() => _RouteTimetableScreenState();
}

class _RouteTimetableScreenState extends State<RouteTimetableScreen> {
  String? selectedRouteId;
  Map<String, dynamic>? selectedRouteData;
  bool isLoading = false;
  String? error;

  final DateTime baseTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    9,
    0,
  );

  // Fetch all route documents
  Future<List<QueryDocumentSnapshot>> fetchRoutes() async {
    final snapshot = await FirebaseFirestore.instance.collection('routes').get();
    return snapshot.docs;
  }

  Future<void> fetchSelectedRouteData(String routeId) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final doc = await FirebaseFirestore.instance.collection('routes').doc(routeId).get();
      if (doc.exists && doc.data() != null) {
        setState(() {
          selectedRouteData = doc.data();
          selectedRouteId = routeId;
        });
      } else {
        setState(() {
          error = "Route not found for ID: $routeId";
          selectedRouteData = null;
        });
      }
    } catch (e) {
      setState(() {
        error = "Failed to fetch route data: $e";
        selectedRouteData = null;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildRouteListTile(QueryDocumentSnapshot routeDoc) {
    final data = routeDoc.data() as Map<String, dynamic>;
    final routeName = data['name'] ?? routeDoc.id;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.directions_bus),
        title: Text(routeName),
        onTap: () => fetchSelectedRouteData(routeDoc.id),
        selected: selectedRouteId == routeDoc.id,
        selectedTileColor: Colors.teal.shade50,
      ),
    );
  }

  Widget buildTimetableView() {
    if (isLoading) return const CircularProgressIndicator();
    if (error != null) {
      return Text(error!, style: const TextStyle(color: Colors.red));
    }

    if (selectedRouteData == null) return const SizedBox.shrink();

    final stopsRaw = selectedRouteData!['stops'];
    if (stopsRaw == null || stopsRaw is! List) {
      return const Text("Invalid stop data.");
    }

    final stops = List<Map<String, dynamic>>.from(stopsRaw);
    if (stops.isEmpty) {
      return const Text("No stops found for this route.");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          "Timetable",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          itemCount: stops.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final stop = stops[index];
            final int offset = stop['arrival_offset_min'] ?? 0;
            final DateTime arrivalTime = baseTime.add(Duration(minutes: offset));
            final String formattedTime = DateFormat('hh:mm a').format(arrivalTime);

            return ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(stop['name'] ?? "Unknown Stop"),
              subtitle: Text("Arrival Time: $formattedTime"),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Timetable"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<QueryDocumentSnapshot>>(
          future: fetchRoutes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text("Error loading routes: ${snapshot.error}");
            }

            final routeDocs = snapshot.data ?? [];
            if (routeDocs.isEmpty) {
              return const Text("No routes available.");
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Available Routes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...routeDocs.map(buildRouteListTile).toList(),
                  buildTimetableView(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

