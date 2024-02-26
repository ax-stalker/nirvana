// import 'package:flutter/material.dart';
//   class MyCircle extends StatelessWidget {
//   final String name;
//   final String price;
//   final String description;
//   final String imageUrls;
//   final String category;


//   MyCircle({
//     super.key,
//     required this.price,
//     required this.name,
//     required this.description,
//     required this.imageUrls,
//     required this.category,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
        
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.tertiaryContainer,
//           shape: BoxShape.rectangle,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//   children: [
//     // Image container
//     Container(
//       height: 200,
//       width:200, // Adjust height as needed
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: NetworkImage(imageUrls), // Replace with your image URL
//           fit: BoxFit.cover, // Or use BoxFit.contain for aspect ratio
//         ),
//       ),
//     ),

//     // Product details
//    Container(
//   height: 300,
//   child: ProductListWidget(/* Pass any arguments here */),
// ),
    
//     Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(description, style: TextStyle(fontSize: 12,),textAlign: TextAlign.start,),
//       ],
//     ),
//   ],
// ),

//       ),
//     );
//   }
// }
