import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


class Bbusiness {
   String? name,  category,description,location, phonenumber;
    
  File? logo;

  Bbusiness({this.name, this.category, this.description, this.location, this.phonenumber, this.logo});
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser =FirebaseAuth.instance.currentUser!;
  String imageUrl = "";

Future<void> uploadBusinessData() async {
 



    try{

     String imageName = DateTime.now().microsecondsSinceEpoch.toString();
      // add image to firebase storage
    Reference ref = _storage.ref().child("businessLogo").child(imageName);
     await ref.putFile(logo!);
      imageUrl = await ref.getDownloadURL();
       await _firestore.collection("businesses").add(
      {
      "uid":currentUser.uid,
      "business_name" : name,
      "business_category" :category,
      "business_description" :description,
      "business_location" : location,
      "business_phone_number" : phonenumber,
      "logo":imageUrl,
           }
     );
   

    }catch(err){
      err.toString();
    }
  }


}