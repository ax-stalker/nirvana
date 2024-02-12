import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;

  const MyAppBar(this.name, {super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Or adjust height as needed

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(name ,
      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
      ),
      // leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
      actions: [
        IconButton(onPressed: () {
          // go to profile page

          Navigator.pushNamed(context, '/settingsPage');
        }, icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary,)),
      ],
    );
  }
}
