// import 'package:flutter/material.dart';
// import 'package:digital_bus_pass_system/home_screen.dart';
//
// class  NotificationScreen extends StatelessWidget {
//   final String ticketDetails; // You can pass ticket details if needed
//
//   const NotificationScreen ({Key? key, required this.ticketDetails}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.teal,
//           title: Text('Notifications')),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'No Notification available right now',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 ticketDetails,
//                 style: TextStyle(fontSize: 18),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//         backgroundColor: Colors.teal,
//       ),
//       body:  StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('notifications')
//             .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return CircularProgressIndicator();
//           final notifications = snapshot.data!.docs;
//
//           if (notifications.isEmpty) {
//             return Center(child: Text('No Notifications'));
//           }
//
//           return ListView.builder(
//             itemCount: notifications.length,
//             itemBuilder: (context, index) {
//               final notification = notifications[index].data();
//               return ListTile(
//                 title: Text(notification['title']),
//                 subtitle: Text(notification['message']),
//               );
//             },
//           );
//         },
//       )
    //StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance
      //       .collection('notifications') // your Firestore collection name
      //       .orderBy('timestamp', descending: true) // optional: for latest first
      //       .snapshots(), // this makes it real-time
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //
      //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      //       return const Center(child: Text('No Notifications Available'));
      //     }
      //
      //     final docs = snapshot.data!.docs;
      //
      //     return ListView.builder(
      //       itemCount: docs.length,
      //       itemBuilder: (context, index) {
      //         final data = docs[index].data() as Map<String, dynamic>;
      //         return ListTile(
      //           leading: const Icon(Icons.notifications),
      //           title: Text(data['title'] ?? 'No Title'),
      //           subtitle: Text(data['message'] ?? ''),
      //           trailing: Text(
      //             (data['timestamp'] as Timestamp?)?.toDate().toString().split('.')[0] ?? '',
      //             style: const TextStyle(fontSize: 12),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),


//     );
//   }
// }
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class NotificationScreen extends StatelessWidget {
//   NotificationScreen({Key? key}) : super(key: key);
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     final user = _auth.currentUser;
//
//     if (user == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Notifications'),
//           backgroundColor: Colors.teal,
//         ),
//         body: const Center(child: Text('User not logged in')),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//         backgroundColor: Colors.teal,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('passHistory')
//             .doc(user.uid)
//             .collection('Notifications')
//             .orderBy('purchaseDateTime', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           final notifications = snapshot.data!.docs;
//
//           if (notifications.isEmpty) {
//             return const Center(child: Text('No Notifications'));
//           }
//
//           return ListView.builder(
//             itemCount: notifications.length,
//             itemBuilder: (context, index) {
//               final notification = notifications[index].data() as Map<String, dynamic>;
//
//               final title = notification['title'] ?? 'Expiry ';
//               final message = notification['message'] ?? 'Your monthly bus pass will expire in 2 days. Please renew it soon!';
//
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
//                 child: ListTile(
//                   tileColor: Colors.grey[200],
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Text(message),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          backgroundColor: Colors.teal,
        ),
        body: const Center(
          child: Text(
            'User not logged in',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('passHistory') // corrected collection name
            .doc(user.uid)
            .collection('Notifications') // corrected subcollection name
            .orderBy('timestamp', descending: true) // order by correct field
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong: ${snapshot.error}'),
            );
          }

          final notifications = snapshot.data?.docs ?? [];

          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                'No Notifications',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final data =
              notifications[index].data() as Map<String, dynamic>?;

              if (data == null) return const SizedBox();

              final title = data['title'] ?? 'Notification';
              final message = data['message'] ?? '';
              final timestamp = data['timestamp'] as Timestamp?;
              final dateTime = timestamp?.toDate();

              return Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                child: Card(
                  color: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    title: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          message,
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (dateTime != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              'Date: ${dateTime.toLocal()}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
