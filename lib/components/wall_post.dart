import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/components/comment_button.dart';
import 'package:nirvana/components/comments.dart';
import 'package:nirvana/components/delete_button.dart';
import 'package:nirvana/components/like_button.dart';
import 'package:nirvana/helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  WallPost({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  }) : super(key: key);

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  bool showComments = false;
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email]),
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email]),
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now(),
    });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(hintText: "Write a comment..."),
        ),
        actions: [
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.of(context).pop();
              _commentTextController.clear();
            },
            child: Text("Post"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _commentTextController.clear();
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // delete post
  void deletePost(){
    // show a dialog to confirm the deletion
    showDialog(context: context, builder: (context)=> AlertDialog(
      title: const Text("Delete Post"),
      content: const Text("Are you sure you want to delete this post?"),
      actions: [
        // cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        // delete button
        TextButton(
          onPressed: () async{

            final commentsDocs =await FirebaseFirestore.instance.collection('User Posts').doc(widget.postId).collection("Comments").get();
            for (var doc in commentsDocs.docs){
              await FirebaseFirestore.instance.collection('User Posts').doc(widget.postId).collection("Comments").doc(doc.id).delete();
            }
            FirebaseFirestore.instance.collection("User Posts").doc(widget.postId).delete().then((value) => print("post deleted")).catchError((error)=>print("failed to  delete post: +$error"));
            Navigator.of(context).pop();
          },
          child: const Text("Delete"),
        ),
      ],
    ),
    );
  }

      


    
    


  

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user,
                  style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        LikeButton(isLiked: isLiked, onTap: toggleLike),
                        const SizedBox(height: 10),
                        Text(widget.likes.length.toString()),
                      ],
                    ),
                    const SizedBox(width: 80),
                    Column(
                      children: [
                        CommentButton(onTap: showCommentDialog),
                        const SizedBox(height: 5),
                        // Text('0'),
                      ],
                    ),
                    const SizedBox(width: 80),
                    
                  ],
                ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showComments = !showComments;
                            });
                          },
                          child: Text(
                              showComments ? 'Hide Comments' : 'Show Comments'),
                        ),
                      ],
                    ),
                Visibility(
                  visible: showComments,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("User Posts")
                        .doc(widget.postId)
                        .collection("Comments")
                        .orderBy("CommentTime", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: snapshot.data!.docs.map((doc) {
                          final commentData = doc.data() as Map<String, dynamic>;
                          return Comment(
                            text: commentData['CommentText'],
                            user: commentData['CommentedBy'],
                            time: formatDate(commentData['CommentTime']),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
