// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/components/appbar.dart';
import 'package:nirvana/components/like_button.dart';
import 'package:nirvana/components/my_drawer.dart';
import 'package:nirvana/helper/helper_methods.dart';

class PromotionsPage extends StatefulWidget {
  PromotionsPage({Key? key}) : super(key: key);

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void toggleLike(String promotionId) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userEmail = user.email;
      final promotionRef = _firestore.collection("promotions").doc(promotionId);

      final promotionSnapshot = await promotionRef.get();
      final likes = promotionSnapshot['likes'] as List<dynamic>;

      if (likes.contains(userEmail)) {
        // User has liked the promotion, remove their email from likes array
        likes.remove(userEmail);
      } else {
        // User hasn't liked the promotion yet, add their email to likes array
        likes.add(userEmail);
      }
       // Update the likes array in Firestore
      await promotionRef.update({'likes': likes});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar("P R O M O T I O N S"),
      drawer: MyDrawer(),
      body: StreamBuilder(
        stream: _firestore.collection("promotions").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          switch (snapshot.connectionState) {
            case (ConnectionState.waiting):
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final promotion = snapshot.data!.docs[index];
                  final message = promotion['message'];
                  final image = promotion['image'];
                  final timestamp = formatDate(promotion['timestamp']);
                  final business_id = promotion['business_id'];
                  final promotion_id = promotion.id;

                  return FutureBuilder<DocumentSnapshot>(
                    future: _firestore
                        .collection("businesses")
                        .doc(business_id)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final businessName = snapshot.data!['business_name'];
                       // Get the likes array and its length
                      final likez = promotion['likes'] ?? [];
                      final likesCount = likez.length;

                      // Check if user has liked this promotion
                      final user = _auth.currentUser;
                      final userEmail = user != null ? user.email : null;
                      final likes = promotion['likes'] as List<dynamic>;
                      final isLiked =
                          userEmail != null && likes.contains(userEmail);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      businessName,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      timestamp,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  message,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          color: isLiked ? Colors.green : null,
                                        ),
                                        onPressed: () {
                                          print("Like button pressed");
                                          // toggleLike(promotion_id);
                                          setState(() {
                                            toggleLike(promotion_id);
                                          });
                                        },
                                      ),
                                      Text(
                                        "$likesCount Likes",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                  // IconButton(
                                  //     onPressed: () {
                                  //       showCommentsSheet(
                                  //           context, promotion_id);
                                  //     },
                                  //     icon: Icon(Icons.mail_outline)),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
          }
        },
      ),
    );
  }
}


