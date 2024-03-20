import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/admin/admin_home_page.dart';
import 'package:nirvana/pages/promotions_page.dart';
import 'package:nirvana/services/auth/auth_service.dart';
import 'package:nirvana/components/my_button.dart';
import 'package:nirvana/components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore =FirebaseFirestore.instance;
  // email and password text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // login method
  void login(BuildContext context) async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // auth service
    final authService = AuthService();

    try {
      // Try login
      print("tried logging in with email");
      await authService.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        
      );
       Navigator.pop(context);
    } catch (e) {
      // Catch errors
      Navigator.pop(context); // Close loading dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(Icons.light,
                size: 60, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 50),

            // welcome back message
            Text(
              'Welcome back',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 16),
            ),
            const SizedBox(height: 25),

            // email textfield
            MyTextField(
              hintText: 'Email',
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 10),
            // password textfield
            MyTextField(
              hintText: 'Password',
              obscureText: true,
              controller: _passwordController,
            ),

            const SizedBox(height: 25),
            // login button'
            MyButton(
              text: 'L o g i n',
              onTap: () => login(context),
            ),
            const SizedBox(height: 25),
            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                    onTap: widget.onTap,
                    child: Text('Register now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




//  catch (e){
//       // pop loading circle
//       Navigator.pop(context);

//       // wrong email
//       if(e=='user-not-found'){
//         // show error to user
//         wrongEmailMessage();
//       }
//       // wrong password
//       else if(e =='wong-password'){
//         // show error
//         wrongPasswordMessage();
//       }
//     }
    
//   }
//   void wrongEmailMessage(){
//       showDialog(
//         context: context, 
//         builder:(context){
//          return const AlertDialog(title: Text('Incorrect Email'),);
//         }
//         );
//       }
    
//     void wrongPasswordMessage(){
//       showDialog(
//         context: context, 
//         builder:(context){
//         return const  AlertDialog(title: Text('Incorrect Password'),);
//         }
//         );
//       }
    