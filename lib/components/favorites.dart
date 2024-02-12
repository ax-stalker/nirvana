import 'package:flutter/material.dart';

class MyFavorites extends StatelessWidget {
  const MyFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(5)),
              child:Row(
                children: [
                  // display picture container
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      width:100,
                      decoration:const  BoxDecoration(
                        shape: BoxShape.circle,
                      color:Colors.white,
                      image: DecorationImage(
          image: AssetImage('android/assets/images/charlie-green.jpg'),
          fit: BoxFit.cover, 
          
              ),
                      ),
                    ),
                  ),
                  
      
                  
                  // name text field
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Pipe Industries',  style: TextStyle(color: Colors.black, fontSize: 20),),
                  ),
                  
      
                  // number of unread messages
                  Text('4', 
                  style: TextStyle(
                    color: Colors.red,
                    ),
                     ),
      
                ],
              )
            ),
    );
  }
}