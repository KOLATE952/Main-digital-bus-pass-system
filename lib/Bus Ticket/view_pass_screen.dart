import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // rootBundle
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

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

  // Get Downloads directory based on platform
  Future<Directory?> getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      final Directory downloadsDir = Directory('/storage/emulated/0/Download');
      if (await downloadsDir.exists()) {
        return downloadsDir;
      } else {
        // fallback to app documents if Downloads doesn't exist
        return await getApplicationDocumentsDirectory();
      }
    } else if (Platform.isIOS) {
      // iOS does not allow external storage access
      return await getApplicationDocumentsDirectory();
    }
    return null;
  }

  Future<void> downloadPassAsPDF(Map<String, dynamic> passData) async {
    final pdf = pw.Document();
    final validityDateTime = parseTimestamp(passData['validityDateTime']);
    final purchaseDateTime = parseTimestamp(passData['purchaseDateTime']);

    // Load image asset for bus logo
    final ByteData imageData = await rootBundle.load('assets/bus logo.png');
    final Uint8List imageBytes = imageData.buffer.asUint8List();
    final pw.ImageProvider busLogoImage = pw.MemoryImage(imageBytes);

    // Build the PDF page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(350, 200, marginAll: 0),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Container(
              width: 320,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#FFF8E1'),
                borderRadius: pw.BorderRadius.circular(15),
                border: pw.Border.all(color: PdfColor.fromHex('#008080'), width: 2),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Image(busLogoImage, width: 50, height: 50),
                      pw.Text(
                        validityDateTime.isAfter(DateTime.now()) ? 'Valid' : 'Invalid',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 20,
                          color: validityDateTime.isAfter(DateTime.now())
                              ? PdfColors.green
                              : PdfColors.red,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 12),
                  pw.Text('Pass Type: ${passData['passType']}', style: const pw.TextStyle(fontSize: 14)),
                  pw.Text('Ticket Count: ${passData['ticketCount']}', style: const pw.TextStyle(fontSize: 14)),
                  pw.Text('Payment Amount: ₹${passData['paymentAmount']}', style: const pw.TextStyle(fontSize: 14)),
                  pw.SizedBox(height: 8),
                  pw.Text('Purchased on: ${dateFormat.format(purchaseDateTime)}', style: const pw.TextStyle(fontSize: 12)),
                  pw.Text('Valid Till: ${dateFormat.format(validityDateTime)}', style: const pw.TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );

    // Request Manage External Storage permission on Android 11+
    if (Platform.isAndroid) {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Manage External Storage permission is required to download the pass.')),
          );
          return;
        }
      }
    }

    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not find the downloads directory.')),
      );
      return;
    }

    final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final filePath = '${downloadsDir.path}/BusPass_${passData['passType']}_$formattedDate.pdf';
    final file = File(filePath);

    try {
      await file.writeAsBytes(await pdf.save());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pass downloaded successfully at:\n$filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save pass: $e')),
      );
    }
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

