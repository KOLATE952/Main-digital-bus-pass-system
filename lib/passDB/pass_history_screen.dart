import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PassHistoryScreen extends StatelessWidget {
  const PassHistoryScreen({Key? key}) : super(key: key);

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMM yyyy – hh:mm a').format(dateTime);
  }

  bool isPassExpired(Timestamp timestamp) {
    final now = DateTime.now();
    return timestamp.toDate().isBefore(now);
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pass History'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('passHistory').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return const Center(child: Text("No pass history available."));

          final passDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: passDocs.length,
            itemBuilder: (context, index) {
              final pass = passDocs[index].data() as Map<String, dynamic>;
              final timestamp = pass['timestamp'] as Timestamp?;
              final isExpired = timestamp == null ? false : isPassExpired(timestamp);
              final statusText = isExpired ? "INVALID" : "VALID";
              final statusColor = isExpired ? Colors.red : Colors.green;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.teal, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status
                    Row(
                      children: [
                        Image.asset(
                          'assets/bus logo.png',
                          height: 40,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (timestamp != null)
                      Text("Issued On: ${formatTimestamp(timestamp)}"),
                    Text("From: ${pass['boardingStop'] ?? ''}"),
                    Text("To: ${pass['destinationStop'] ?? ''}"),
                    Text("Route: ${pass['route'] ?? ''}"),
                    Text("Payment: ${pass['paymentMethod'] ?? ''}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

