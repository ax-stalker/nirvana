import 'package:flutter/material.dart';

class MyProfileCard extends StatelessWidget {
  final IconData iconData; 
  final String text;      

  const MyProfileCard({
    super.key,
    required this.iconData,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(iconData), // Use the iconData directly in Icon
              const SizedBox(width: 15),
              Text(text, // No need to call toString() on text
                style: TextStyle(
                  fontSize: 16, // Adjust font size as needed
                  color: Colors.white, // Ensure text visibility
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
