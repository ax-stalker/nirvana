import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/components/comment_button.dart';
import 'package:nirvana/components/comments.dart';
import 'package:nirvana/components/like_button.dart';
import 'package:nirvana/helper/helper_methods.dart';

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
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  // /toggle likes
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // access document in firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      // if the post is now liked add the users email to the likes list
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email]),
      });
    } else {
      // if the post is not liked remove the users email from the likes list
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email]),
      });
    }
  }

// add a comment
  void addComment(String commentText) {
    // write the comment to firestore under the comments collection
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now() // to be formatted later
    });
  }

// show a dialog box for adding comments
  void showCommentDialog() {
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
                title: Text("Add Comment"),
                content: TextField(
                  controller: _commentTextController,
                  decoration: InputDecoration(hintText: "write a comment .."),
                ),
                actions: [
                  // save the comment
                  TextButton(
                      onPressed: () { addComment(_commentTextController.text);
                      Navigator.of(context).pop();}
                    ,
                      child: Text("Post")),


                  // cancel button
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // CLEAR
                        _commentTextController.clear();
                      },
                      child: Text("Cancel"))
                ])));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
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
                  Column(children: [
                    LikeButton(isLiked: isLiked, onTap: toggleLike),
                    const SizedBox(height: 10),
                    // likes
                    Text(widget.likes.length.toString()),
                  ]),

                  const SizedBox(width: 80),

                  // comment
                  Column(children: [
                    CommentButton(onTap: showCommentDialog),
                    const SizedBox(height: 5),
                    // comment count
                    Text('0'),
                  ]),
                ],
              ),

              // display comments
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .orderBy("CommentTime", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  // show loading circle
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((doc) {
                      // get the comment
                      final commentData = doc.data() as Map<String, dynamic>;

                      // return the comment
                      return Comment(
                        text: commentData['CommentText'],
                        user: commentData['CommentedBy'],
                        time: formatDate(commentData['CommentTime']),
                      );
                    }).toList(),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
