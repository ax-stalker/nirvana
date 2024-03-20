import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  
   AdminHomePage({super.key, });
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("logged in as : ${currentUser!.email}")),
    );
  }
}
