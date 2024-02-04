import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  // instance of auth
  final FirebaseAuth _auth =FirebaseAuth.instance;
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;
  
  

  // get current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }

// sign in
Future <UserCredential> signInWithEmailAndPassword(String email, password) async{
try{
  UserCredential userCredential=  await _auth.signInWithEmailAndPassword(email: email, password: password);
  // save user info in seperate doc if it doesn't already exist
    _firestore.collection('Users').doc(userCredential.user!.uid).set({
      'uid' : userCredential.user!.uid, 'email' : email,
    });

  return userCredential;
} on FirebaseAuthException catch (e){
  throw Exception(e.code);
}
}


// sign up
Future <UserCredential> signUpWithEmailAndPassword(String email, String password, String username, String phone)async {
  try{
    UserCredential userCredential= await _auth.createUserWithEmailAndPassword(email: email, password: password);
    // save user info in seperate doc
   
    _firestore.collection('Users').doc(userCredential.user!.uid).set({
      'uid' : userCredential.user!.uid, 
      'username': username,
      'email' : email, 
      'phone':phone,
    });

    return userCredential;
  } on FirebaseAuthException catch (e){
    throw Exception(e.code);
  }
}









// sign out
Future <void> signOut() async {
return await _auth.signOut();
}



// errors











}