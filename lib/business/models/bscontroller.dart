

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class BsController extends GetxController{
  final  nameController  = TextEditingController();
  String?  categoryController;
  final  descriptionController  = TextEditingController();
  final  addressController  = TextEditingController();
  String? phoneController;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser =FirebaseAuth.instance.currentUser!;
 late final Position position;

File? image;
String imageUrl = '';







Future<void> uploadBusinessData() async {
 

    if (image == null) return;


    try{

     String imageName = DateTime.now().microsecondsSinceEpoch.toString();
      // add image to firebase storage
    Reference ref = _storage.ref().child("businessLogo").child(imageName);
     await ref.putFile(image!);
      imageUrl = await ref.getDownloadURL();
       await _firestore.collection("business").add(
      {
      "userid":currentUser.uid,
      "name" : nameController.text,
      "category" :categoryController,
      "description" :descriptionController.text,
      "location" : addressController.text,
      "contact" : phoneController,
      "logo":imageUrl,
           }
     );
   

     clearInputs();
    }catch(err){
      clearInputs();
    }
  }
  void clearInputs(){
    nameController.dispose();
    descriptionController.clear();
    addressController.clear();
    super.dispose();
  }


}