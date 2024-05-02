import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kwikq_app/services/firebase_const.dart';

class FireStoreService {
  static Future<Future<DocumentReference<Map<String, dynamic>>>> saveOrder(
      Map<String, dynamic> orderData) async {
    // Add order to Firestore
    return FirebaseFirestore.instance.collection('orders').add(orderData);
  }

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<DocumentSnapshot<Map<String, dynamic>>> getOrderById(
      String orderId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> orderSnapshot =
          await _firestore.collection('orders').doc(orderId).get();
      return orderSnapshot;
    } catch (e) {
      throw Exception('Error getting order by ID: $e');
    }
  }
}
