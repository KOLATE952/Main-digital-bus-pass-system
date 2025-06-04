// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';
//
// class RouteTimetableScreen extends StatefulWidget {
//   const RouteTimetableScreen({super.key});
//
//   @override
//   State<RouteTimetableScreen> createState() => _RouteTimetableScreenState();
// }
//
// class _RouteTimetableScreenState extends State<RouteTimetableScreen> {
//   String? localPath;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadPdf();
//   }
//
//   Future<void> _loadPdf() async {
//     final bytes = await rootBundle.load('assets/timetable.pdf');
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File('${dir.path}/timetable.pdf');
//
//     await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
//
//     setState(() {
//       localPath = file.path;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Bus Timetable"),
//         backgroundColor: Colors.teal,
//       ),
//       body:
//       // localPath == null
//       //     ?
//       const Center(child: CircularProgressIndicator())
//       //     // : PDFView(
//       //   filePath: localPath!,
//       //   enableSwipe: true,
//       //   swipeHorizontal: false,
//       //   autoSpacing: true,
//       //   pageFling: true,
//       // ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class RouteTimetableScreen extends StatelessWidget {
//   final String routeId;
//
//   const RouteTimetableScreen({Key? key, required this.routeId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     CollectionReference routes = FirebaseFirestore.instance.collection('routes');
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Route Timetable'),
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: routes.doc(routeId).get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return Center(child: Text("Route not found."));
//           }
//
//           Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
//
//           // Filter all stop keys like stop1, stop2,...
//           List<Map<String, dynamic>> stops = data.entries
//               .where((entry) => entry.key.startsWith('stop'))
//               .map((entry) => entry.value as Map<String, dynamic>)
//               .toList();
//
//           // Sort by arrival offset
//           stops.sort((a, b) => (a['arrival offset min'] as int).compareTo(b['arrival offset min'] as int));
//
//           return ListView.builder(
//             itemCount: stops.length,
//             itemBuilder: (context, index) {
//               final stop = stops[index];
//               return ListTile(
//                 leading: CircleAvatar(child: Text((index + 1).toString())),
//                 title: Text(stop['name'] ?? 'Unnamed Stop'),
//                 subtitle: Text('Stop ID: ${stop['stop id']} | Offset: ${stop['arrival offset min']} mins'),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RouteTimetableScreen extends StatelessWidget {
  final String routeId;

  const RouteTimetableScreen({Key? key, required this.routeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference routes = FirebaseFirestore.instance.collection('routes');

    return Scaffold(
      appBar: AppBar(
        title: Text('Route Timetable'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: routes.doc(routeId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong!"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Route not found."));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          // Extract and filter stop entries: stop1, stop2, ...
          final stops = data.entries
              .where((entry) => entry.key.startsWith('stop'))
              .map((entry) => entry.value as Map<String, dynamic>)
              .toList();

          // Sort stops by 'arrival offset min'
          stops.sort((a, b) => (a['arrival offset min'] as int).compareTo(b['arrival offset min'] as int));

          if (stops.isEmpty) {
            return const Center(child: Text("No stops found for this route."));
          }

          return ListView.builder(
            itemCount: stops.length,
            itemBuilder: (context, index) {
              final stop = stops[index];
              final stopName = stop['name'] ?? 'Unnamed Stop';
              final stopId = stop['stop id'] ?? 'N/A';
              final offset = stop['arrival offset min'] ?? 0;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  title: Text(stopName),
                  subtitle: Text('Stop ID: $stopId | Offset: $offset mins'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
