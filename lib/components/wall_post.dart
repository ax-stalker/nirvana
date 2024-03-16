import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/components/like_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked =widget.likes.contains(currentUser.email);
  }
  // /toggle likes
  void toggleLike(){
    setState(() {
      isLiked =!isLiked;
      
    });
  

  // access document in firebase
DocumentReference postRef = FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

if (isLiked){
  // if the post is now liked add the users email to the likes list
  postRef.update({
    'Likes': FieldValue.arrayUnion([currentUser.email]),
  });
}else{
  // if the post is not liked remove the users email from the likes list
  postRef.update({
    'Likes': FieldValue.arrayRemove([currentUser.email]),
  });
}

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          Column(children: [
            LikeButton(isLiked: isLiked, onTap: toggleLike),
            const SizedBox(height:10),
            // likes
            Text(widget.likes.length.toString()),
          ]),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
