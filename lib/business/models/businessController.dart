
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BusinessController extends GetxController{
  final  nameController  = TextEditingController();
  final  categoryController  = TextEditingController();
  final  descriptionController  = TextEditingController();
  final  addressController  = TextEditingController();
  final  phoneController  = TextEditingController();
  final currentUser =FirebaseAuth.instance.currentUser!;
  late String docId;
  late List<String> businessId; 

  String imageUrl = '';
  XFile? file;



  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  

void  displayBusiness(){
  businessId.map((e) => accessDocumentById(e));
}

Future<Object?> accessDocumentById(String documentId) async {
  try {
    // Get a reference to the document
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('business').doc(documentId);

    // Retrieve the document snapshot
    DocumentSnapshot documentSnapshot = await documentReference.get();

    if (documentSnapshot.exists) {
      // Document exists, you can access its data
      Object data = documentSnapshot.data()!;
      return data;

    } else {
      print('Document with ID $documentId does not exist.');
    }
  } catch (e) {
    return e.toString();
  }
  return null;
}


  getId()async{
    

      CollectionReference usercol = _firestore.collection('Users');

          // Make a query for documents where 'emai' field equals 'userEmail'
      QuerySnapshot querySnapshot = await usercol.where('uid', isEqualTo: currentUser.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Iterate over each document in the query result
        for(var doc in querySnapshot.docs){
        // querySnapshot.docs.forEach((doc) {
          docId = doc.id;
          var user = doc.data().toString();
          //       Map<String, dynamic> data = doc.data()!;

          // List<dynamic> array = data['businessReference'];
        }
      }
  
  

  }
  void clearInputs(){
    nameController.clear();
    categoryController.clear();
    descriptionController.clear();
    addressController.clear();
    phoneController.clear();
  }

  // void getLocation() async {
  //   await Geolocator.checkPermission();
  //   await Geolocator.requestPermission();
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.bestForNavigation);
  //   print(position);
  //   print(_auth.currentUser?.uid);
  //   _userId = _auth.currentUser!.uid;
  //   _businessLocationController.text =
  //       position.latitude.toString() + ',' + position.longitude.toString();
  // }
}
