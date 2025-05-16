// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
//
// class ViewPassScreen extends StatefulWidget {
//   @override
//   _ViewPassScreenState createState() => _ViewPassScreenState();
// }
//
// class _ViewPassScreenState extends State<ViewPassScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
//
//   DateTime parseTimestamp(dynamic timestamp) {
//     // Handle Timestamp or String or null safely
//     if (timestamp == null) return DateTime.now();
//     if (timestamp is Timestamp) return timestamp.toDate();
//     if (timestamp is String) {
//       try {
//         return DateTime.parse(timestamp);
//       } catch (e) {
//         return DateTime.now();
//       }
//     }
//     return DateTime.now();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = _auth.currentUser;
//     if (user == null) {
//       // User not logged in
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.teal,
//           title: const Text('View Passes'),
//         ),
//         body: const Center(
//           child: Text('Please log in to view your passes.'),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: const Text('View Passes'),
//       ),
//       body: SafeArea(
//         child: StreamBuilder<QuerySnapshot>(
//           stream: _firestore
//               .collection('passHistory')
//               .doc(user.uid)
//               .collection('passes')
//               .orderBy('purchaseDateTime', descending: true)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }
//
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return const Center(child: Text('No passes found.'));
//             }
//
//             final passes = snapshot.data!.docs;
//
//             return ListView.builder(
//               padding: const EdgeInsets.only(bottom: 20),
//               itemCount: passes.length,
//               itemBuilder: (context, index) {
//                 final passData = passes[index].data() as Map<String, dynamic>;
//
//                 DateTime validityDateTime = parseTimestamp(passData['validityDateTime']);
//                 DateTime purchaseDateTime = parseTimestamp(passData['purchaseDateTime']);
//
//                 bool isValid = validityDateTime.isAfter(DateTime.now());
//
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                   elevation: 4,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFFFF8E1),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Image.asset(
//                               'assets/bus logo.png',
//                               width: 50,
//                               height: 50,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return const Icon(Icons.directions_bus, size: 50);
//                               },
//                             ),
//                             const SizedBox(width: 10),
//                             Text(
//                               isValid ? 'Valid' : 'Invalid',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 color: isValid ? Colors.green : Colors.red,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           'From: ${passData['from'] ?? 'N/A'} - To: ${passData['to'] ?? 'N/A'}',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text('Pass Type: ${passData['passType'] ?? 'N/A'}'),
//                         Text('Ticket Count: ${passData['ticketCount'] ?? 'N/A'}'),
//                         Text('Payment Amount: ₹${passData['paymentAmount'] ?? 'N/A'}'),
//                         Text('Purchased on: ${dateFormat.format(purchaseDateTime)}'),
//                         Text('Valid Till: ${dateFormat.format(validityDateTime)}'),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//
// class ViewPassScreen extends StatefulWidget {
//   @override
//   _ViewPassScreenState createState() => _ViewPassScreenState();
// }
//
// class _ViewPassScreenState extends State<ViewPassScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
//
//   DateTime parseTimestamp(dynamic timestamp) {
//     if (timestamp == null) return DateTime.now();
//     if (timestamp is Timestamp) return timestamp.toDate();
//     if (timestamp is String) {
//       try {
//         return DateTime.parse(timestamp);
//       } catch (e) {
//         return DateTime.now();
//       }
//     }
//     return DateTime.now();
//   }
//
//   Future<void> _generateAndDownloadPDF(Map<String, dynamic> passData) async {
//     final pdf = pw.Document();
//
//     final purchaseDate = parseTimestamp(passData['purchaseDateTime']);
//     final validityDate = parseTimestamp(passData['validityDateTime']);
//
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Container(
//             padding: const pw.EdgeInsets.all(20),
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Text("Bus Pass",
//                     style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
//                 pw.SizedBox(height: 20),
//                 pw.Text("From: ${passData['from'] ?? 'N/A'}"),
//                 pw.Text("To: ${passData['to'] ?? 'N/A'}"),
//                 pw.Text("Pass Type: ${passData['passType'] ?? 'N/A'}"),
//                 pw.Text("Ticket Count: ${passData['ticketCount'] ?? 'N/A'}"),
//                 pw.Text("Amount Paid: ₹${passData['paymentAmount'] ?? 'N/A'}"),
//                 pw.Text("Purchased on: ${dateFormat.format(purchaseDate)}"),
//                 pw.Text("Valid till: ${dateFormat.format(validityDate)}"),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//
//     await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final user = _auth.currentUser;
//     if (user == null) {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.teal,
//           title: const Text('View Passes'),
//         ),
//         body: const Center(
//           child: Text('Please log in to view your passes.'),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         title: const Text('View Passes'),
//       ),
//       body: SafeArea(
//         child: StreamBuilder<QuerySnapshot>(
//           stream: _firestore
//               .collection('passHistory')
//               .doc(user.uid)
//               .collection('passes')
//               .orderBy('purchaseDateTime', descending: true)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }
//
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return const Center(child: Text('No passes found.'));
//             }
//
//             final passes = snapshot.data!.docs;
//
//             return ListView.builder(
//               padding: const EdgeInsets.only(bottom: 20),
//               itemCount: passes.length,
//               itemBuilder: (context, index) {
//                 final passData = passes[index].data() as Map<String, dynamic>;
//
//                 DateTime validityDateTime = parseTimestamp(passData['validityDateTime']);
//                 DateTime purchaseDateTime = parseTimestamp(passData['purchaseDateTime']);
//
//                 bool isValid = validityDateTime.isAfter(DateTime.now());
//
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                   elevation: 4,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFFFF8E1),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Image.asset(
//                               'assets/bus logo.png',
//                               width: 50,
//                               height: 50,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return const Icon(Icons.directions_bus, size: 50);
//                               },
//                             ),
//                             const SizedBox(width: 10),
//                             Text(
//                               isValid ? 'Valid' : 'Invalid',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 color: isValid ? Colors.green : Colors.red,
//                               ),
//                             ),
//                             const Spacer(),
//                             IconButton(
//                               icon: const Icon(Icons.download, color: Colors.teal),
//                               tooltip: 'Download PDF',
//                               onPressed: () {
//                                 _generateAndDownloadPDF(passData);
//                               },
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           'From: ${passData['from'] ?? 'N/A'} - To: ${passData['to'] ?? 'N/A'}',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text('Pass Type: ${passData['passType'] ?? 'N/A'}'),
//                         Text('Ticket Count: ${passData['ticketCount'] ?? 'N/A'}'),
//                         Text('Payment Amount: ₹${passData['paymentAmount'] ?? 'N/A'}'),
//                         Text('Purchased on: ${dateFormat.format(purchaseDateTime)}'),
//                         Text('Valid Till: ${dateFormat.format(validityDateTime)}'),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class ViewPassScreen extends StatefulWidget {
  @override
  _ViewPassScreenState createState() => _ViewPassScreenState();
}

class _ViewPassScreenState extends State<ViewPassScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  DateTime parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is String) {
      try {
        return DateTime.parse(timestamp);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Future<void> downloadPassAsPDF(Map<String, dynamic> passData) async {
    final pdf = pw.Document();
    final validityDateTime = parseTimestamp(passData['validityDateTime']);
    final purchaseDateTime = parseTimestamp(passData['purchaseDateTime']);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFFFF8E1),
              border: pw.Border.all(color: PdfColors.black),
              borderRadius: pw.BorderRadius.circular(15),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Digital Bus Pass',
                  style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Text('From: ${passData['from']} - To: ${passData['to']}', style: pw.TextStyle(fontSize: 16)),
                pw.Text('Pass Type: ${passData['passType']}'),
                pw.Text('Ticket Count: ${passData['ticketCount']}'),
                pw.Text('Payment Amount: Rs. ${passData['paymentAmount']}'),
                pw.Text('Purchased on: ${dateFormat.format(purchaseDateTime)}'),
                pw.Text('Valid Till: ${dateFormat.format(validityDateTime)}'),
              ],
            ),
          );
        },
      ),
    );

    // Request storage permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission is required to download the pass.')),
      );
      return;
    }

    final outputDir = await getExternalStorageDirectory();
    final file = File('${outputDir!.path}/bus_pass_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pass downloaded successfully: ${file.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text('View Passes'),
        ),
        body: const Center(
          child: Text('Please log in to view your passes.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('View Passes'),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('passHistory')
              .doc(user.uid)
              .collection('passes')
              .orderBy('purchaseDateTime', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text('No passes found.'));

            final passes = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: passes.length,
              itemBuilder: (context, index) {
                final passData = passes[index].data() as Map<String, dynamic>;
                DateTime validityDateTime = parseTimestamp(passData['validityDateTime']);
                DateTime purchaseDateTime = parseTimestamp(passData['purchaseDateTime']);
                bool isValid = validityDateTime.isAfter(DateTime.now());

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/bus logo.png',
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.directions_bus, size: 50);
                              },
                            ),
                            const SizedBox(width: 10),
                            Text(
                              isValid ? 'Valid' : 'Invalid',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isValid ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'From: ${passData['from']} - To: ${passData['to']}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text('Pass Type: ${passData['passType']}'),
                        Text('Ticket Count: ${passData['ticketCount']}'),
                        Text('Payment Amount: ₹${passData['paymentAmount']}'),
                        Text('Purchased on: ${dateFormat.format(purchaseDateTime)}'),
                        Text('Valid Till: ${dateFormat.format(validityDateTime)}'),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () => downloadPassAsPDF(passData),
                          icon: const Icon(Icons.download),
                          label: const Text('Download as PDF'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
