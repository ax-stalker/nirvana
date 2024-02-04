import 'package:flutter/material.dart';
import 'package:nirvana/services/auth/auth_service.dart';
import 'package:nirvana/components/my_button.dart';
import 'package:nirvana/components/my_textfield.dart';

class RegisterPage extends StatelessWidget {
   // email and password text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController=TextEditingController();
  final TextEditingController _usernameController =TextEditingController();
  final TextEditingController _phonenumberController =TextEditingController();
  // tap to go to the login page
  void Function()? onTap;

   RegisterPage({super.key,required this.onTap });
   void Register(BuildContext context){
    // get auth service
    final _auth= AuthService();

    // if passwords match then create user 
   if (_passwordController.text == _confirmPasswordController.text){
try{
       _auth.signUpWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        _usernameController.text,
        _phonenumberController.text,
        
        ); 
// if passwords dont match show error to user
} catch(e){
    showDialog(context: context, 
      builder: (context)=>AlertDialog(
        title: Text(e.toString()) ,

      ),);
}
  } else{
    showDialog(context: context, 
      builder: (context)=>AlertDialog(
        title: Text("Passwords dont match") ,

      ),);
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
            Icon (Icons.light, size:60 ,color: Theme.of(context).colorScheme.primary),
            const SizedBox(height:50),
            
            // welcome back message
            Text('Let\'s create an account for you',style:TextStyle( color: Theme.of(context).colorScheme.primary, fontSize:16),),
            const SizedBox(height:25),
            // username textfield
             MyTextField(
              hintText: 'Username', 
              obscureText: false,
              controller: _usernameController,
            ),

        const SizedBox(height:10),
        
            // email textfield
            MyTextField(
              hintText: 'Email', 
              obscureText: false,
              controller: _emailController,
            ),

        const SizedBox(height:10),
        // phone number controller
         MyTextField(
              hintText: 'phone number', 
              obscureText: false,
              controller: _phonenumberController,
            ),

        const SizedBox(height:10),

            // password textfield
            MyTextField(
              hintText: 'Password', 
              obscureText: true,
              controller: _passwordController,
            ),

            // confirm password textfield
            const SizedBox(height:10),
            // password textfield
            MyTextField(
              hintText: ' Confirm Password', 
              obscureText: true,
              controller: _confirmPasswordController,
            ),
        
          const SizedBox(height:25),
            // login button'
            MyButton(
              text: 'Register',
              onTap: ()=>Register(context),
            ),
        const SizedBox(height:25),
            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account? ', style: TextStyle(color:Theme.of(context).colorScheme.primary,),),
                GestureDetector(
                  onTap:onTap,
                  child: Text('Login now',style: TextStyle(fontWeight: FontWeight.bold,))),
              ],
            ),
          ],
        ),
      ),
      
    );
  }
}