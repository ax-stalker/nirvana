import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottomNavBar({super.key, required this.onTabChange,});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GNav(
          backgroundColor: Colors.black,
          tabBackgroundColor: Colors.grey.shade800,
          gap:8,
          onTabChange:(value)=>onTabChange!(value) ,
          color: Colors.white,
          activeColor: Colors.white,
          padding:const EdgeInsets.all(16),
          tabs: const [
          GButton(icon: Icons.feed, text: "feed"),
          GButton(icon: Icons.shopping_cart,text: 'products'),
          GButton(icon: Icons.business_center_rounded, text: 'businesses'),
          GButton(icon: Icons.person_2,text: "profile",)
          // GButton(icon: Icons.email,),
          // GButton(icon: Icons.person,)
        ]),
      ),
    );
  }
}