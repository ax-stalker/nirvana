import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  void Function()? onTap;
   MyButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color:Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
          
          ),
          padding: const EdgeInsets.all(25),
          margin:const EdgeInsets.symmetric(horizontal: 25),
      
        child: Center(child:
         Text(text, style: TextStyle(fontWeight: FontWeight.bold,
         color:Theme.of(context).colorScheme.background, ),)),
      
      ),
    );
  }
}