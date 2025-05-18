import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:digital_bus_pass_system/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
class ViewTicketScreen extends StatefulWidget {
  final String ticketDetails;

  const ViewTicketScreen({Key? key, required this.ticketDetails}) : super(key: key);

  @override
  _ViewTicketScreenState createState() => _ViewTicketScreenState();
}

class _ViewTicketScreenState extends State<ViewTicketScreen> {
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
    final user = _auth.currentUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Your Ticket'),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('passHistory')
              .doc(user.uid)
              .collection('tickets')
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

                        Text('Route: ${passData['route']}'),
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
