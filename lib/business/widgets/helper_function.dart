import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Helper{
// File? image;

// final picker = ImagePicker();

// //Image Picker function to get image from gallery
// Future getImageFromGallery() async {
//   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       image = File(pickedFile.path);
//     }
// }

// //Image Picker function to get image from camera
// Future getImageFromCamera() async {
//   final pickedFile = await picker.pickImage(source: ImageSource.camera);

//    if (pickedFile != null) {
//       image = File(pickedFile.path);
//     }
//     return image;
// }
static Size screenSize() => MediaQuery.of(Get.context!).size;

static void navigateToScreen(BuildContext context,Widget screen){
  Navigator.push(context, MaterialPageRoute(builder: (_)=> screen));
}

static void showSnackBar(String message){
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(content: Text(message))
  );
}


}