import 'package:flutter/material.dart';
import 'package:nirvana/components/bottom_nav_bar.dart';
import 'package:nirvana/const.dart';

import 'package:nirvana/pages/business_list.dart';

import 'package:nirvana/pages/home_page.dart';
import 'package:nirvana/pages/messages_page.dart';
import 'package:nirvana/pages/product_category_list.dart';
import 'package:nirvana/pages/profile_page.dart';



class PageNavigator extends StatefulWidget {
  const PageNavigator({super.key});

  @override
  State<PageNavigator> createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  // navigate bottom bar
  int _selectedIndex = 0;
  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

// pages
  final List<Widget> _pages = [
// home
    MyHome(),


// products page
    ProductList(),

// businesspage
    BusinessList(),
// messages
    MessagesPage(),

// profile page
    // ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
