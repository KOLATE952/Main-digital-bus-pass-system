import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationManager {
  /// Checks if the monthly pass is about to expire or already expired,
  /// then adds a notification for the user.
  Future<String?> checkForExpiredPassesAndNotify() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final uid = user.uid;

      // Fetch monthly pass document for the current user
      final doc = await FirebaseFirestore.instance
          .collection('passes')
          .doc(uid)
          .get();

      if (!doc.exists) return null;

      final purchaseTimestamp = doc.data()?['purchase_date'] as Timestamp?;
      if (purchaseTimestamp == null) return null;

      final purchaseDate = purchaseTimestamp.toDate();
      final expiryDate = purchaseDate.add(const Duration(days: 30));
      final now = DateTime.now();

      final daysLeft = expiryDate.difference(now).inDays;

      String? message;

      if (daysLeft == 2) {
        message = "Your bus pass will expire in 2 days.";
        await addNotificationWithTitle(uid, 'Pass Expiry Warning', message);
      } else if (daysLeft <= 0) {
        message = "Your bus pass has expired. Please renew to continue using the service.";
        await addNotificationWithTitle(uid, 'Pass Expired', message);
      }

      return message;
    } catch (e) {
      print('Error in checkForExpiredPassesAndNotify: $e');
      return null;
    }
  }

  /// Adds a notification document under:
  /// passHistory/{userId}/Notifications collection
  Future<void> addNotificationWithTitle(
      String uid, String title, String message) async {
    try {
      final notificationsRef = FirebaseFirestore.instance
          .collection('passHistory')
          .doc(uid)
          .collection('Notifications');

      await notificationsRef.add({
        'title': title,
        'message': message,
        'timestamp': Timestamp.now(),
        'read': false, // Mark as unread
      });
    } catch (e) {
      print('Error adding notification: $e');
    }
  }

  /// Gets count of unread notifications for current user
  Future<int> getUnreadNotificationCount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return 0;

      final uid = user.uid;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('passHistory')
          .doc(uid)
          .collection('Notifications')
          .where('read', isEqualTo: false)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print('Error getting unread notification count: $e');
      return 0;
    }
  }

  /// Marks all notifications as read for current user
  Future<void> markAllNotificationsAsRead() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final uid = user.uid;

      final notificationsRef = FirebaseFirestore.instance
          .collection('passHistory')
          .doc(uid)
          .collection('Notifications');

      final unreadQuery =
      await notificationsRef.where('read', isEqualTo: false).get();

      final batch = FirebaseFirestore.instance.batch();

      for (final doc in unreadQuery.docs) {
        batch.update(doc.reference, {'read': true});
      }

      await batch.commit();
    } catch (e) {
      print('Error marking notifications as read: $e');
    }
  }
}
