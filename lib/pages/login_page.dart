import 'package:flutter/material.dart';
import 'package:nirvana/services/auth/auth_service.dart';
import 'package:nirvana/components/my_button.dart';
import 'package:nirvana/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  // email and password text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void Function()? onTap;

   LoginPage({super.key, required this.onTap });

  //  login method
  void login(BuildContext context) async {
    // auth service
    final authService =AuthService();
    // try login
    try {
      await authService.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
    }


    // catch errors
    catch(e){
      showDialog(context: context, 
      builder: (context)=>AlertDialog(
        title: Text(e.toString()) ,

      ),);
    }

;   
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
            Text('Welcome back',style:TextStyle( color: Theme.of(context).colorScheme.primary, fontSize:16),),
            const SizedBox(height:25),
        
            // email textfield
            MyTextField(
              hintText: 'Email', 
              obscureText: false,
              controller: _emailController,
            ),

        const SizedBox(height:10),
            // password textfield
            MyTextField(
              hintText: 'Password', 
              obscureText: true,
              controller: _passwordController,
            ),
        
          const SizedBox(height:25),
            // login button'
            MyButton(
              text: 'Login',
              onTap: ()=>login(context),
            ),
        const SizedBox(height:25),
            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member? ', style: TextStyle(color:Theme.of(context).colorScheme.primary,),),
                GestureDetector(
                  onTap: onTap,
                  child: Text('Register now',style: TextStyle(fontWeight: FontWeight.bold,))),
              ],
            ),
          ],
        ),
      ),
      
    );
  }
}