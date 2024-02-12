import 'package:flutter/material.dart';
import 'package:nirvana/components/appbar.dart';
import 'package:nirvana/components/favorites.dart';
import 'package:nirvana/components/my_drawer.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const MyAppBar( 'F a v o r i t e s'),
       drawer: MyDrawer(),
      body: Column(
        children: [
          
          Expanded(
            child: ListView(children: [
              MyFavorites(),
              MyFavorites(),
              MyFavorites(),
              MyFavorites(),
              MyFavorites(),
              MyFavorites(),
              MyFavorites(),
            ]),
          )
        ],
      ),
    );
  }
}
