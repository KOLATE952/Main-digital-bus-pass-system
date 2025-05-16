import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ViewPassScreen extends StatefulWidget {
  @override
  _ViewPassScreenState createState() => _ViewPassScreenState();
}

class _ViewPassScreenState extends State<ViewPassScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  DateTime parseTimestamp(dynamic timestamp) {
    // Handle Timestamp or String or null safely
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

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      // User not logged in
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
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No passes found.'));
            }

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
                          'From: ${passData['from'] ?? 'N/A'} - To: ${passData['to'] ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('Pass Type: ${passData['passType'] ?? 'N/A'}'),
                        Text('Ticket Count: ${passData['ticketCount'] ?? 'N/A'}'),
                        Text('Payment Amount: ₹${passData['paymentAmount'] ?? 'N/A'}'),
                        Text('Purchased on: ${dateFormat.format(purchaseDateTime)}'),
                        Text('Valid Till: ${dateFormat.format(validityDateTime)}'),
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
