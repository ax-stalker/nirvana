import 'package:flutter/material.dart';
import 'package:nirvana/components/bottom_nav_bar.dart';
import 'package:nirvana/const.dart';
import 'package:nirvana/pages/favorites_page.dart';
import 'package:nirvana/pages/home.dart';
import 'package:nirvana/pages/messages_page.dart';
import 'package:nirvana/pages/profile_page.dart';
import 'package:nirvana/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
  
class _HomePageState extends State<HomePage> {

  // navigate bottom bar
  int _selectedIndex = 0;
  void navigateBottomBar(int index){
    setState((){
      _selectedIndex = index;
    });
  }

// pages
final List<Widget>_pages=[
// home
MyHome(),


// searchpage 
SearchPage(),

// favorites
FavoritesPage(),
// messages
MessagesPage(),

// profile page
ProfilePage(),
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:backgroundColor,
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index)=> navigateBottomBar(index),
      ),

      

      body: _pages[_selectedIndex],
    );
  }
}