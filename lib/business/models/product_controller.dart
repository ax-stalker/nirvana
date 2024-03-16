import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductController extends GetxController{

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  final nameController  = TextEditingController();
  final priceController  = TextEditingController();
  String? categoryController;
  final descriptionController = TextEditingController();
  bool uploading = true;


  List<String> imageUrls = [];
  List<String> Labels =["name","price","Description","Category"];
  String imageUrl = '';
  List<XFile> selectedImages = [];



  void uploadprd(String businessId) async {
   if(selectedImages.isNotEmpty)  {
    // imageFileList.add(selectedImages as XFile);
 

    try{
          for (int i = 0; i < selectedImages.length; i++) {
            String imageName = DateTime.now().microsecondsSinceEpoch.toString();
            Reference ref = _storage.ref().child("products").child(imageName);
            File image = File(selectedImages[i].path);
            await ref.putFile(image);
            imageUrl = await ref.getDownloadURL();
            imageUrls.add(imageUrl);
                   
          }

            await _firestore.collection("products").add(
                  {
                    "businessref": businessId,
                    "name" : nameController.text,
                    "description" :descriptionController.text,
                    "category" : categoryController,
                    "price":priceController.text,
                    "Imageurls":imageUrls,
                  }
                );
            uploading= false;
            clearinputs();
  } catch(err){
    print(err.toString());
    clearinputs();
  }
}
 }
 void clearinputs(){
     nameController.clear();
   priceController.clear();
   descriptionController.clear();
   imageUrls = [];
 }



}