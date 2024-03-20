// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:nirvana/helper/helper_methods.dart';

// class CommentsSheet extends StatefulWidget {
//   final String promotionId;

//   const CommentsSheet({Key? key, required this.promotionId}) : super(key: key);

//   @override
//   State<CommentsSheet> createState() => _CommentsSheetState();
// }

// class _CommentsSheetState extends State<CommentsSheet> {
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _commentController = TextEditingController();

//   void addComment(String content) async {
//     final user = _auth.currentUser;
//     if (user!= null && content.isNotEmpty) {
//       final promotionId = widget.promotionId;
//       final username = user.displayName?? user.email?.split('@').first;
//       final timestamp = DateTime.now();

//       await _firestore
//          .collection("promotions")
//          .doc(promotionId)
//          .collection("comments")
//          .add({
//         'username': username,
//         'content': content,
//         'timestamp': timestamp,
//       });

//       _commentController.clear(); // Clear comment field after adding
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.75, // Set initial height of the sheet
//       minChildSize: 0.5, // Minimum allowed height
//       maxChildSize: 1.0, // Maximum allowed height

//       builder: (context, controller) => Container(
//         padding: EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.background,
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Column(
//           children: [
//             // Title for comments section
//             Text(
//               "Comments",
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10.0),

//             // StreamBuilder to get comments for the promotion
//             StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                  .collection("promotions")
//                  .doc(widget.promotionId)
//                  .collection("comments")
//                  .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Text("Error: ${snapshot.error}");
//                 }

//                 switch (snapshot.connectionState) {
//                   case ConnectionState.waiting:
//                     return Center(child: CircularProgressIndicator());
//                   default:
//                     final comments = snapshot.data!.docs;
//                     return ListView.builder(
//                       shrinkWrap: true, // Prevent list from expanding
//                       itemCount: comments.length,
//                       itemBuilder: (context, index) {
//                         final commentData = comments[index].data();
//                         final username = commentData!['username'];
//                         final content = commentData['content'];
//                         final timestamp = formatDate(commentData['timestamp']);

//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               CircleAvatar(
//                                 // Display user avatar (if available)
//                                 child: Text(username[0].toUpperCase()),
//                               ),
//                               SizedBox(width: 10.0),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       username,
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       content,
//                                       maxLines: 3,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     Text(
//                                       timestamp,
//                                       style: TextStyle(color: Colors.grey),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                 }
//               },
//             ),

//             const SizedBox(height: 10.0),

//             // Text field to add a new comment
//             TextField(
//               controller: _commentController,
//               decoration: InputDecoration(
//                 hintText: "Add a comment...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () => addComment(_commentController.text.trim()),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }