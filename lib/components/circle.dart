import 'package:flutter/material.dart';

class MyCircle extends StatelessWidget {
  final String child;
  const MyCircle({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                     shape: BoxShape.rectangle,
                     borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text(child, style: const TextStyle(fontSize: 20),)),
                  
                  ),
    );
  }
}