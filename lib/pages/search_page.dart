import 'package:flutter/material.dart';
import 'package:nirvana/components/appbar.dart';
import 'package:nirvana/components/my_drawer.dart';
import 'package:nirvana/components/search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _textController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: const MyAppBar( 'S E A R C H'),
      body:Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
         
         


          // search textfield
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration:  InputDecoration(
                // prefixIcon: const Icon(Icons.search),
                hintText: 'carpenter, plumber, courier ....',
                border:  const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: (){
                  // clear what's been typed in textfield
                  _textController.clear();
                }, icon:const Icon(Icons.clear), ),
                
                ),
            
            ),
          ),

          


          // results
          

          // results listview
          Expanded(
            child: ListView(
              children: [ 
                MySearch(),
                MySearch(),
                MySearch(),
                MySearch(),
                MySearch(),
                MySearch(),
                MySearch(),
                
              ],
            ),
          )


        ],
      ),
 drawer: MyDrawer(),
    );
  }
}