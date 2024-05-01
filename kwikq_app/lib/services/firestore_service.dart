import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kwikq_app/services/firebase_const.dart';

class FireStoreService {
  static Future<Future<DocumentReference<Map<String, dynamic>>>> saveOrder(
      Map<String, dynamic> orderData) async {
    // Add order to Firestore
    return FirebaseFirestore.instance.collection('orders').add(orderData);
  }

  static Future<Map<String, dynamic>?> getOrderById(String orderId) async {
    // Fetch a single order by ID
    var doc = await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .get();
    return doc.data() as Map<String, dynamic>?;
  }
}
