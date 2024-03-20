import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nirvana/business/widgets/curved_edge_widget.dart';

class image_slider extends StatefulWidget {
   image_slider({
    super.key,
    required this.urli,
    required this.docid,
    required this.collectionName,
    required this.imagefolder,
    required this.varimage,
  });

  final String urli;
  String varimage;
  String docid;
  String collectionName;
  String imagefolder;

  @override
  State<image_slider> createState() => _image_sliderState();
}

class _image_sliderState extends State<image_slider> {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   final FirebaseStorage _storage = FirebaseStorage.instance;
   File? img;
  @override
  Widget build(BuildContext context) {
    return curvedEdgeWidget(
      child: 
    Container(
      color: Colors.blueGrey,
      child: Stack(
        children: [
          SizedBox(
            height: 300,
            // padding: EdgeInsets.all(32)
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Image.network(widget.urli,
              fit: BoxFit.cover,
              ),
            ),
            
          ),
          AppBar(leading: IconButton(onPressed:() {Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios)),
           backgroundColor: Colors.transparent,),
           Positioned(
              bottom: 10,
              right: -5,
              child: RawMaterialButton(
                onPressed:getImageFromGallery,
                elevation: 2.0,
                fillColor: const Color(0xFFF5F6F9),
                padding: const EdgeInsets.all(15.0),
                shape: const CircleBorder(),
                child: const Icon(Icons.camera_alt_outlined, color: Colors.blue,)),),
               
        ],
      ),
    )
      );
  }

final picker = ImagePicker();

//Image Picker function to get image from gallery
Future getImageFromGallery() async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
      img = File(pickedFile.path);
        
      });

     // save image to firestore
                          String imageName = DateTime.now().microsecondsSinceEpoch.toString();
                    // add image to firebase storage
                  Reference ref = _storage.ref().child(widget.imagefolder).child(imageName);
                  await ref.putFile(img!);
                    String image = await ref.getDownloadURL();
                    final data = {widget.varimage :image};
                    await _firestore.collection(widget.collectionName).doc(widget.docid).set(data, SetOptions(merge: true));
                    print("image saved");

      // img = pickedFile as File?;
      
    }
}
}