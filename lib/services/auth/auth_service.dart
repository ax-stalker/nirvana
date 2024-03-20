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
 
  return userCredential;
} on FirebaseAuthException catch (e){
  throw Exception(e.code);
}
}


// sign up
Future <UserCredential> signUpWithEmailAndPassword(String email, String password, String username, String phone,)async {
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



// Get current user ID directly
  String get currentUserId {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // Handle the case where the user is not logged in
      throw Exception("User is not logged in");
    }
  }



// // get admin status
//   Future<bool> checkAdminRole() async {
//     // Get the current user
//     User? user = _auth.currentUser;

//     if (user != null) {
//       // Get the user document from the Users collection
//       DocumentSnapshot userDoc =
//           await _firestore.collection('Users').doc(user.uid).get();

//       // Check if the user has an admin role
//       return userDoc['role'] == 'admin';
//     } else {
//       // No user signed in
//       return false;
//     }
//   }

Future<bool> checkAdminRole(String userId) async {
    try {
      // Get the user document from the Users collection using the provided userId
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(userId).get();

      // Check if the user has an admin role
      if (userDoc.exists &&
          userDoc.data() != null &&
          userDoc['role'] == 'admin') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Error handling
      print('Error checking admin role: $e');
      return false;
    }
  }









}