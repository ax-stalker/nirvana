import 'package:flutter/material.dart';
import 'package:nirvana/business/pages/business_home_page.dart';
import 'package:nirvana/business/services/business_service.dart';
import 'package:nirvana/components/appbar.dart';
import 'package:nirvana/components/my_button.dart';
import 'package:nirvana/components/my_drawer.dart';
import 'package:nirvana/components/user_tile.dart';
import 'package:nirvana/services/auth/auth_service.dart';
import 'package:nirvana/components/profilecard.dart';

class ProfilePage extends StatefulWidget {

  ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// business and auth service
final BusinessService _businessService= BusinessService();
final AuthService _authService= AuthService();



class _ProfilePageState extends State<ProfilePage> {
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: MyAppBar('P R O F I L E'),
         drawer: MyDrawer(),
        body: Column(
          
          children: [
            const SizedBox(height: 10),
            // Container(
            //   height: 200,
            //   width: 200,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //         image: DecorationImage(
            //     image: NetworkImage('https://i.pinimg.com/736x/a2/7a/3f/a27a3fb05e975385380921e54f859f4f.jpg'),
            //     fit: BoxFit.cover,
            //   ),
            //   )
            // ),
            Text('profile name'),
            SizedBox(height: 10),
            MyButton(text: "edit profile", onTap: onTap),
            SizedBox(height: 25),
            MyButton(
                text: 'create business profile',
                onTap: () {
                  // go to profile page
                    
                  Navigator.pushNamed(context, '/MyBusinessRegistration');
                }),
                SizedBox(height:20),
            // build a list of businesss accounts for the currently logged in user
        Expanded(
          
          child: _buildAccountsList()),
        
        
        
        
          ],
        ),
      ),
    );
  }

  // build a list of businesss accounts for the currently logged in user
  Widget _buildAccountsList(){
    return StreamBuilder(stream: _businessService.getBusinessAccounts(), 
    builder: (context, snapshot){
       // error
      if(snapshot.hasError){
        return const Text('Error');
      }

      // loading..
      if (snapshot.connectionState == ConnectionState.waiting){
        return const CircularProgressIndicator();
      }
      // return list view
      return ListView(
        children: snapshot.data!.map<Widget>((userData)=>_buildUserListItem(userData,context)).toList(),
      );


    });
  }
}

Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
  // display all accounts with same user id
  if (userData['uid']==_authService.getCurrentUser()!.uid){
    return UserTile(
      text: userData['business_name'],
      onTap: (){
        // tapped on a profile go to that profile page
        Navigator.push(context, MaterialPageRoute(builder:(context)=>BusinessHomePage() ));

      },
    );
  }else{
      return Container();
    }

  
}
