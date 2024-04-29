import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kwikq_app/services/firebase_const.dart';

class FireStoreServices{
  //delete document
  static deleteDocument(docId) {
    return firestore.collection(cartcollection).doc(docId).delete();
  }
}