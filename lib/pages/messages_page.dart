import 'package:flutter/material.dart';
import 'package:nirvana/components/appbar.dart';
import 'package:nirvana/components/message.dart';
import 'package:nirvana/components/user_tile.dart';
import 'package:nirvana/pages/chat_page.dart';
import 'package:nirvana/services/auth/auth_service.dart';
import 'package:nirvana/services/chat/chat_service.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

// chat and auth service
final ChatService _chatService= ChatService();
final AuthService _authService= AuthService();

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: const MyAppBar( 'M E S S A G E S'),
      body: _buildUserList(),
    );

  }


  // build a list of users except for the currently logged in user

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(), 
      builder: (context,snapshot){

      // error
      if(snapshot.hasError){
        return const Text('Error');
      }

      // loading..
      if (snapshot.connectionState == ConnectionState.waiting){
        return const Text('Loading.....');
      }

      // return list view
      return  ListView(
        children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData,context)).toList(),
        );
      });
  }

  // build individual list tile for users

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    // display all users except current user
    if( userData['email']!=_authService.getCurrentUser()!.email){
      return UserTile(
      text: userData['email'], 
      onTap: () {
        // tapped on a user go to chat page
        Navigator.push(context,MaterialPageRoute(builder:(context) => ChatPage(
          receiverEmail: userData['email'],
          receiverID: userData['uid'],),
          
        ),);
        },
      
    );
    }else{
      return Container();
    }


  }
}