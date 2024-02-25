import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nirvana/components/appbar.dart';
import 'package:nirvana/components/circle.dart';
import 'package:nirvana/components/my_drawer.dart';
import 'package:nirvana/components/square.dart';
import 'package:nirvana/models/category_model.dart';

class MyHome extends StatefulWidget {
  MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const MyAppBar('H O M E P A G E'),
      body: Column(
        children: [
          
      
          Container(
            height:300,
            
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                 MyCircle(price: "500",productName: "Nike", sizes:" 40-45", imageUrl: "android/assets/images/alex-starnes-PK_t0Lrh7MM-unsplash.jpg",),
                 MyCircle(price: "500",productName: "Nike", sizes:" 40-45", imageUrl: "android/assets/images/alex-starnes-PK_t0Lrh7MM-unsplash.jpg",),
                 MyCircle(price: "500",productName: "Nike", sizes:" 40-45", imageUrl: "android/assets/images/alex-starnes-PK_t0Lrh7MM-unsplash.jpg",),
                 MyCircle(price: "500",productName: "Nike", sizes:" 40-45", imageUrl: "android/assets/images/alex-starnes-PK_t0Lrh7MM-unsplash.jpg",),
                 MyCircle(price: "500",productName: "Nike", sizes:" 40-45", imageUrl: "android/assets/images/alex-starnes-PK_t0Lrh7MM-unsplash.jpg",),
                 MyCircle(price: "500",productName: "Nike", sizes:" 40-45", imageUrl: "android/assets/images/alex-starnes-PK_t0Lrh7MM-unsplash.jpg",),
                 MyCircle(price: "500",productName: "Nike", sizes:" 40-45", imageUrl: "android/assets/images/alex-starnes-PK_t0Lrh7MM-unsplash.jpg",),
                 MyCircle(price: "500",productName: "Nike", sizes:" 40-45", imageUrl: "android/assets/images/alex-starnes-PK_t0Lrh7MM-unsplash.jpg",),
              ],
            ),
          ),
      
          Expanded(
            child: ListView(
              children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Container( 
                        //  height: 200,
                        // width: 200,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(9), 
                          
                          
                          ),
                          child:Column(
                          children: [
                            
                              Image.asset(
                                  "android/assets/images/irene-kredenets-dwKiHoqqxk8-unsplash.jpg", 
                                  fit: BoxFit.fitWidth,
                                       
                            ),
                            Text(
                              "@business_name",
                              textAlign: TextAlign.left,
                            ),
                            Text("1 hr ago"), 
                            Text('join us for our upcoming opening day for all the cheapest and most affordable clothing and esentials'),
                            
                          
                          
                          ],
                                                )
                      ),
                    ),
                  ),
            
              ],
            ),
          ),
          
      
      
      
      
      
      
      
      
      
      
        
      
      
        ],
      ),
      drawer: MyDrawer(),
    );
  }
}















// Expanded(
    
//     child: StreamBuilder(
//       stream: _firestore.collection('categories').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         } else {
//           return ListView.builder(
//             scrollDirection: Axis.vertical,
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               final doc = snapshot.data!.docs[index];
//               return Card(
//                 child: ListTile(
//                   title: Text(doc.data()['title'], style: TextStyle(fontSize: 20)),
//                 ),
//               );
//             },
//           );
//         }
//       },
//     ),
//   ),





      // clickable buttons
//           SingleChildScrollView(
//   scrollDirection: Axis.horizontal, // Use horizontal scrolling
//   child: Container(
//     child: StreamBuilder(
//       stream: _firestore.collection('categories').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         } else {
//           return Row( // Use Row for horizontal arrangement
//             children: snapshot.data!.docs.map((doc) {
//               return Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: ElevatedButton(
                  
//                   onPressed: () {
//                     // Handle button click here (e.g., navigate to a new screen)
//                     print('Clicked ${doc.data()['title']}');
//                   },
//                   child: Text(doc.data()['title'], style: TextStyle(fontSize: 20)),
//                   style: ElevatedButton.styleFrom(
                   
//                     backgroundColor: Colors.white, // White fill
//                     foregroundColor: Colors.black, // Black text
//                     side: BorderSide(
//                       color: Colors.black, // Black border
//                       width: 2.0,),),
//                 ),
//               );
//             }).toList(),
//           );
//         }
//       },
//     ),
//   ),
// ),