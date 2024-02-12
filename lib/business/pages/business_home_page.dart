import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BusinessHomePage extends StatelessWidget {
   BusinessHomePage({super.key});

  final currentUser =FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children:[

          // the wall

          // post message

          // logged in as

          Text('Logged in as ${currentUser.email!}')

        ]
      )
    );
      
    
  }
}