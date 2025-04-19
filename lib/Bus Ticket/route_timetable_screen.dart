import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class RouteTimetableScreen extends StatefulWidget {
  const RouteTimetableScreen({super.key});

  @override
  State<RouteTimetableScreen> createState() => _RouteTimetableScreenState();
}

class _RouteTimetableScreenState extends State<RouteTimetableScreen> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final bytes = await rootBundle.load('assets/timetable.pdf');
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/timetable.pdf');

    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);

    setState(() {
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Timetable"),
        backgroundColor: Colors.teal,
      ),
      body:
      // localPath == null
      //     ?
      const Center(child: CircularProgressIndicator())
      //     // : PDFView(
      //   filePath: localPath!,
      //   enableSwipe: true,
      //   swipeHorizontal: false,
      //   autoSpacing: true,
      //   pageFling: true,
      // ),
    );
  }
}
