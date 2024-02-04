import 'package:flutter/material.dart';

class MyMessage extends StatelessWidget {
  const MyMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(5)),
              child:Row(
                children: [
                  // display picture container
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      width:100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      color:Colors.white,
                      image: DecorationImage(
          image: AssetImage('../lib/images/charlie-green.jpg'),
          fit: BoxFit.cover, 
          
              ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 25),
      
      
                  // name text field
                  Text('Pipe Industries', style: TextStyle(color: Colors.black,),),
                    const SizedBox(width: 25),
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