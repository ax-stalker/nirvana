import 'package:flutter/material.dart';

class MySquare extends StatelessWidget {
  final String child;
   MySquare({super.key, required this.child});
  

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.all(8.0),
          // padding: const EdgeInsets.symmetric(vertical:8.0),
          child: Container(
            height: 100,
            
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey[700],),
            child: Center(child: Text(child, style: TextStyle(fontSize: 20),)),
          ),
        );
  }
}