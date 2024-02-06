import 'package:flutter/material.dart';
import 'package:nirvana/components/my_button.dart';
import 'package:nirvana/services/auth/auth_service.dart';
import 'package:nirvana/components/profilecard.dart';

class ProfilePage extends StatelessWidget {
   void Function()? onTap;
   ProfilePage({super.key,});

  // void logOut() {
  //   // get auth service

  //   final _auth= AuthService();
  //   _auth.signOut();

  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        
        
        appBar: AppBar(
          title: Text('P R O F I L E'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions:[
            // logout button
            // IconButton(onPressed: logOut, icon: Icon(Icons.logout))
          ]
      
        ),
        body:
        Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children:[
              const SizedBox(height:10),
      
               Container(
          height: 200,
          width: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
          //     image: DecorationImage(
          // image: AssetImage('../lib/images/charlie-green.jpg'),
          // fit: BoxFit.cover, 
          
              ),
              child:Icon(Icons.person_4, size: 100,),
            ),
          Text('profile name'),

          SizedBox(height: 10),
          MyButton(text: "edit profile", onTap: onTap),

          Container(
            decoration: BoxDecoration(
              color: Colors.blue,

             
            ),
             child:
               MyButton(text: 'create business profile', onTap: (){
                 // go to profile page

              Navigator.pushNamed(context, '/MyBusinessRegistration');

               }),
                
              

          ),



         
          
          
          
          
      
          ],),
        ),
      
      ),
    );
  }
}