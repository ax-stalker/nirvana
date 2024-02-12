import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BusinessService{

  // instance of firestore and auth
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth =FirebaseAuth.instance;


// get business accounts

Stream <List<Map<String,dynamic>>> getBusinessAccounts(){
  return _firestore.collection('businesses').snapshots().map((snapshot){
    return snapshot.docs.map((doc){
      // go through each individual business
      final user =doc.data();
      return user;

    }).toList();
  });
}




}