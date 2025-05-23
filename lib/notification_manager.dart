// import 'package:flutter/material.dart';
//
// class NotificationManager extends ChangeNotifier {
//   static final NotificationManager _instance = NotificationManager._internal();
//
//   factory NotificationManager() => _instance;
//
//   NotificationManager._internal();
//
//   final List<String> _notifications = [];
//
//   List<String> get notifications => List.unmodifiable(_notifications);
//
//   void addNotification(String notification) {
//     _notifications.insert(0, notification); // newest first
//     notifyListeners();
//   }
//
//   void clearNotifications() {
//     _notifications.clear();
//     notifyListeners();
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class NotificationManager {
//   Future<void> addNotification(String message) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         throw Exception("User not logged in");
//       }
//
//       final notificationData = {
//         'userId': user.uid,
//         'title': 'Expiry',
//         'message': 'Your monthly bus pass will expire in 2 days. Please renew it soon!',
//         'timestamp': Timestamp.now(),
//       };
//
//       await FirebaseFirestore.instance.collection('notifications').add(notificationData);
//       print("Notification added successfully");
//     } catch (e) {
//       print("Error adding notification: $e");
//     }
//   }
//
//   Future<void> addNotificationWithTitle(String title, String message) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         throw Exception("User not logged in");
//       }
//
//       final notificationData = {
//         'userId': user.uid,
//         'title': 'Expiry',
//         'message': 'Your monthly bus pass will expire in 2 days. Please renew it soon!',
//         'timestamp': Timestamp.now(),
//       };
//
//       await FirebaseFirestore.instance.collection('notifications').add(notificationData);
//       print("Notification added successfully");
//     } catch (e) {
//       print("Error adding notification: $e");
//     }
//   }
//
//   // ✅ Method to check for expired passes and add notifications
//   Future<void> checkForExpiredPassesAndNotify() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       print('User not logged in');
//       return;
//     }
//
//     final uid = user.uid;
//     final now = Timestamp.now();
//
//     final passHistoryRef = FirebaseFirestore.instance
//         .collection('passHistory')
//         .doc(uid)
//         .collection('passes'); // collection of passes under passHistory/<uid>/
//
//     final snapshot = await passHistoryRef.get();
//
//     for (final doc in snapshot.docs) {
//       final data = doc.data();
//
//       final validUntil = data['validUntil'] as Timestamp?;
//       final hasExpired = validUntil != null && validUntil.compareTo(now) < 0;
//       final notified = data['notified'] ?? false;
//
//       if (hasExpired && !notified) {
//         await FirebaseFirestore.instance
//             .collection('passHistory')
//             .doc(user.uid)
//             .collection('Notifications')
//             .add({
//           'title': 'Bus Pass Expired',
//           'message': 'Your bus pass expired on ${validUntil.toDate()}',
//           'purchaseDateTime': now,
//         });
//
//         await doc.reference.update({'notified': true});
//
//         print("Notification added for expired pass.");
//       }
//     }
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Send a generic notification (e.g., 2-day expiry warning)
  Future<void> addNotification(String message) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      final notificationData = {
        'title': 'Expiry',
        'message': message,
        'purchaseDateTime': Timestamp.now(),
      };

      await _firestore
          .collection('passHistory')
          .doc(user.uid)
          .collection('Notifications')
          .add(notificationData);

      print("Notification added successfully");
    } catch (e) {
      print("Error adding notification: $e");
    }
  }

  /// Add notification with a custom title and message
  Future<void> addNotificationWithTitle(String title, String message) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      final notificationData = {
        'title': title,
        'message': message,
        'purchaseDateTime': Timestamp.now(),
      };

      await _firestore
          .collection('passHistory')
          .doc(user.uid)
          .collection('Notifications')
          .add(notificationData);

      print("Notification with title added successfully");
    } catch (e) {
      print("Error adding notification: $e");
    }
  }

  /// Check for expired passes and notify if not already notified
  Future<void> checkForExpiredPassesAndNotify() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('User not logged in');
        return;
      }

      final uid = user.uid;
      final now = Timestamp.now();

      final passHistoryRef = _firestore
          .collection('passHistory')
          .doc(uid)
          .collection('passes');

      final snapshot = await passHistoryRef.get();

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final validUntil = data['validUntil'] as Timestamp?;
        final notified = data['notified'] ?? false;
        final hasExpired = validUntil != null && validUntil.compareTo(now) < 0;

        if (hasExpired && !notified) {
          await _firestore
              .collection('passHistory')
              .doc(uid)
              .collection('Notifications')
              .add({
            'title': 'Bus Pass Expired',
            'message': 'Your bus pass expired on ${validUntil.toDate()}',
            'purchaseDateTime': now,
          });

          await doc.reference.update({'notified': true});
          print("Notification added for expired pass.");
        }
      }
    } catch (e) {
      print("Error in checkForExpiredPassesAndNotify: $e");
    }
  }
}
