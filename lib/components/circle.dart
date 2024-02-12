import 'package:flutter/material.dart';
  class MyCircle extends StatelessWidget {
  final String productName;
  final String price;
  final String sizes;
  final String imageUrl; 

  MyCircle({
    super.key,
    required this.price,
    required this.productName,
    required this.sizes,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
  children: [
    // Image container
    Container(
      height: 200,
      width:200, // Adjust height as needed
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageUrl), // Replace with your image URL
          fit: BoxFit.cover, // Or use BoxFit.contain for aspect ratio
        ),
      ),
    ),

    // Product details
    Container(
      width:200,
      child: Row(
       
        children: [
          
          Expanded(child: Text(productName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          Text(price, style: TextStyle(fontSize: 14, color: Colors.grey)),
      
        ],
      ),
    )
    ,
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sizes, style: TextStyle(fontSize: 12,),textAlign: TextAlign.start,),
      ],
    ),
  ],
),

      ),
    );
  }
}
