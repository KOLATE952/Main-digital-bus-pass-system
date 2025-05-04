import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewPassScreen extends StatefulWidget {
  @override
  _ViewPassScreenState createState() => _ViewPassScreenState();
}

class _ViewPassScreenState extends State<ViewPassScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('View Passes'),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _fetchUserPasses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No passes found.'));
            }

            List<Map<String, dynamic>> passes = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 20), // Ensures space at the end
              itemCount: passes.length,
              itemBuilder: (context, index) {
                var pass = passes[index];
                DateTime validityDateTime = DateTime.parse(pass['validityDateTime']);
                bool isValid = validityDateTime.isAfter(DateTime.now());

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1), // Off-white background
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row with logo and validity
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
                        // Route information
                        Text(
                          'From: ${pass['from']} - To: ${pass['to']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Additional details
                        Text('Pass Type: ${pass['passType']}'),
                        Text('Ticket Count: ${pass['ticketCount']}'),
                        Text('Payment Amount: ₹${pass['paymentAmount']}'),
                        Text('Purchased on: ${pass['purchaseDateTime']}'),
                        Text('Valid Till: ${pass['validityDateTime']}'),
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

  Future<List<Map<String, dynamic>>> _fetchUserPasses() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    try {
      final snapshot = await _firestore
          .collection('passHistory')
          .doc(user.uid)
          .collection('passes')
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching passes: $e');
      return [];
    }
  }
}
