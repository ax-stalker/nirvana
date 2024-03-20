import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/components/appbar.dart';
import 'package:nirvana/components/my_drawer.dart';

import 'package:nirvana/components/my_textfield.dart';
import 'package:nirvana/components/wall_post.dart';
import 'package:nirvana/helper/helper_methods.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  // get current user details
  final currentUser = FirebaseAuth.instance.currentUser;
  final textController = TextEditingController();

  void postMessage() {
    // only post when there is something in the textfield
    if (textController.text.isNotEmpty){

      // store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail':currentUser!.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],

      });
    }

    // clear the texfield:
    setState((){
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar("L I V E F E E D"),
       drawer: MyDrawer(),
        
        body: Column(children: [
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("User Posts")
                .orderBy(
                  "TimeStamp",
                  descending: true,
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount:snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    // get the message
                    final post = snapshot.data!.docs[index];
                    return WallPost(
                      message: post['Message'],
                      user: post['UserEmail'],
                      postId: post.id,
                      likes: List<String>.from(post['Likes']?? []),
                      
                      
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error' + snapshot.error.toString()));
              } return const Center(
                child: CircularProgressIndicator()
              );
            },
          )),

// sending a message
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                    child: MyTextField(
                  controller: textController,
                  hintText: "What's up friend ....",
                  obscureText: false,
                )),
                IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.send),
                    color: Theme.of(context).colorScheme.primary),
              ],
            ),
          )
        ]),
        
        );
  }
}
