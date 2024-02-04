import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:nirvana/models/message.dart';

class ChatService{

// get instance of firestore and auth
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth =FirebaseAuth.instance;


// get user stream
Stream <List<Map<String, dynamic>>> getUsersStream(){
  return _firestore.collection('Users').snapshots().map((snapshot){
    return snapshot.docs.map((doc){
      // go through each individuaal user

      final user =doc.data();


      // return user
      return user;
    }).toList();
  });
}


// send message
Future <void> sendMessage(String receiverId, message)async{
  // get current user info
  final String currentUserID= _auth.currentUser!.uid;
  final String currentUserEmail= _auth.currentUser!.email!;
  final Timestamp timestamp =Timestamp.now();


  // create new message
  Message newMessage=Message(
    senderID: currentUserID, 
    senderEmail:currentUserEmail , 
    receiverID: receiverId, 
    message: message, 
    timestamp: timestamp
    );


  // construct chat room id for the two(sorted to ensure  uniqueness)

  List<String> ids=[currentUserID,receiverId];
  ids.sort(); //sorting to ensure any two people have the same chatroom
  String chatRoomID = ids.join('_');

  // add message to database
  await _firestore
  .collection("chat_rooms")
  .doc(chatRoomID)
  .collection('messages')
  .add(newMessage.toMap());

}



// get message
Stream<QuerySnapshot> getMessages(String userID, otherUserID){
  // construct a chatroom id for the two users
  List<String> ids =[userID, otherUserID];
  ids.sort();
  String chatRoomID =ids.join('_');

  return _firestore
  .collection('chat_rooms')
  .doc(chatRoomID)
  .collection('messages')
  .orderBy('timestamp', 
  descending: false)
  .snapshots();


}







}