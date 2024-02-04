import 'package:flutter/material.dart';

class MySearch extends StatelessWidget {
  const MySearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(color:Colors.grey[700],
                    borderRadius: BorderRadius.circular(10)),
                    // row for card contents
                    child: Row(children: [ 
                      // profile image
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Container(
                          height:100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white, 
                            shape:BoxShape.circle,
                            image: DecorationImage(
          image: AssetImage('../lib/images/charlie-green.jpg'),
          fit: BoxFit.cover, 
          
              ),
                           ),
                         ),
                       ),
                       const SizedBox(width: 25),
                      


                      //column for business name and distance
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [ 
                          
                          Text("Pipe industries", style: TextStyle(fontSize: 20, ),),
                          Text('5 Km away'),
                           // rating
                        Row(
                        children: [ 
                          Icon(Icons.star),
                          Icon(Icons.star),
                          Icon(Icons.star),
                          Icon(Icons.star_border),
                          Icon(Icons.star_border),
                          
                        ],
                      ),
                        ],
                      ),

                     

                      // view profile button
                      // const SizedBox(width:20),
                      //  Icon(
                      // Icons.arrow_forward, size: 40,),


                    ],),
                    
                  ),
                );
  }
}