import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/components/my_button.dart';
import 'package:nirvana/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Categories extends StatelessWidget {
   Categories({super.key});
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        elevation:0,
        backgroundColor: Colors.transparent,

      ),
      body: Column(
        children: [
          MyTextField(hintText: 'Enter Category', obscureText: false, controller: _controller),
          SizedBox(height: 25),
          MyButton(text: "Submit", onTap:(){
           if(_controller.text.isNotEmpty){
             // creating a map
            Map<String,dynamic> data= {'title':_controller.text};
            // step 2
        _firestore.collection('categories').add(data);

        _controller.clear();
           }


          })


        ],
      )
    );
  }
}