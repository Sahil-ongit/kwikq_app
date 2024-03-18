import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInFoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInFoMap);
  }

   Future addFoodItem(Map<String, dynamic> userInFoMap, String name) async {
    return await FirebaseFirestore.instance
        .collection(name)
        .add(userInFoMap);
  }

  Future <Stream<QuerySnapshot>> getFoodCart(String id) async{
    return await FirebaseFirestore.instance.collection("users").doc(id).collection("Cart").snapshots();
  }
}
