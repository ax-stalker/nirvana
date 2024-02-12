import 'package:flutter/material.dart';

class MyTextArea extends StatelessWidget {
  TextEditingController controller;
   MyTextArea({super.key ,required this.controller});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        minLines: 1,
        maxLines: 2,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Business Description'
        ),

      ),
      );
    
  }
}