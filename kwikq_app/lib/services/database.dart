// ignore_for_file: dead_code

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInFoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInFoMap);
  }

  Future addFoodItem(Map<String, dynamic> userInFoMap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userInFoMap);
  }

  Future<Stream<QuerySnapshot>> getFoodCart(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Cart")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getFoodItem(String name) async {
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future addFoodToCart(Map<String, dynamic> userInFoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection("Cart")
        .add(userInFoMap);
  }

  Future ConfirmOrder(Map<String, dynamic> userInFoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection("Orders")
        .add(userInFoMap);
  }

  Future<void> deleteFoodCart(String id) async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(id)
      .collection("Cart")
      .get();

  querySnapshot.docs.forEach((doc) async {
    await doc.reference.delete();
  });
}

 
}

