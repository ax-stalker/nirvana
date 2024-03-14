import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  ImageUpload({Key? key}) : super(key: key);

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  double _uploadProgress = 0.0;

  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadProfileImage() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final String imageName = DateTime.now().microsecondsSinceEpoch.toString();
      final Reference ref =
          _storage.ref().child("profileImages").child(imageName);

      UploadTask uploadTask = ref.putFile(File(image.path));
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      await uploadTask;
      final String imageUrl = await ref.getDownloadURL();
      print(imageUrl);
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          IconButton(
            onPressed: () async {
              await uploadProfileImage();
            },
            icon: Icon(Icons.camera_enhance_sharp),
          ),
          ElevatedButton(
            onPressed: () async {
              await uploadProfileImage();
            },
            child: Icon(Icons.camera_alt),
          ),
          SizedBox(height: 20.0),
          LinearProgressIndicator(value: _uploadProgress),
        ],
      ),
    );
  }
}
