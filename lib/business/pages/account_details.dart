import 'package:flutter/material.dart';
import 'package:nirvana/business/widgets/image_slider_widget.dart';




class userProfile extends StatefulWidget {
  const userProfile({super.key});

  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  String urli = 'https://images.pexels.com/photos/90946/pexels-photo-90946.jpeg?auto=compress&cs=tinysrgb&w=600';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(onPressed: (){Navigator.pop(context);}, icon:const Icon(Icons.arrow_back_ios) ),),
        
      body: SingleChildScrollView(
        child: Column(
          children: [
            image_slider(urli: urli),
               SingleChildScrollView(
              child: Column(
                children: [
                  // const Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children:[
                  //     Row(
                  //      children: [Icon(Icons.star_border_outlined),
                  //       SizedBox(
                  //         width: 20,
              
                  //       ),
                  //       Text.rich(TextSpan(
                  //         children: [
                  //           TextSpan(text: '5.0',)
                  //         ]
                  //       ))
                  //       ],
                  //     ),
                  //     // IconButton(onPressed:(){}, icon: Icon(Icons.share))
                  //    Icon(Icons.share)
                  //   ]
                  // ),
                  Padding(
                    padding: EdgeInsets.all(8.0,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Products Information", style: TextStyle(fontSize:20, fontWeight: FontWeight.bold),),
                       
                      ],
                    ),
                  ),
                  displayInfor(label: "product Name", value: "Camon 520",),
                  displayInfor(label: "product description", value: "camera"),
                  displayInfor(label: "product category", value: "Lifestyle"),
                  displayInfor(label: "product price", value: "Ksh :300")
                
               
                ]

              ),
            ),
           
         
          ],
        ),
      ),
    
    );
  }

}

class displayInfor extends StatefulWidget {
   displayInfor({
    super.key,
    required this.label,
    required this.value
  });
  String label;
  String value;

  @override
  State<displayInfor> createState() => _displayInforState();
}

class _displayInforState extends State<displayInfor> {
  final TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Column(
    children: [
      SizedBox(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [

            Text(widget.label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
            Text(widget.value),
              ],
            ),
            IconButton(onPressed: (){_displayTextInputDialog(context);}, icon:const Icon(Icons.edit))

          ],
        ),
      )),
       
     
      
      
                  
    ],
                      );
  }

Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.label),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: widget.value),
          ),
          actions: [
             TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                print(_textFieldController.text);
                setState(() {
                widget.value = _textFieldController.text;
                  
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class editDetails extends StatelessWidget {
  String label;
  String hint;
   editDetails({
    super.key,
    required this.label,
    required this.hint
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }
}

class editProduct extends StatelessWidget {
  const editProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
                    children: [
                      SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            editDetails(label: "name", hint: "Watch"),

                          ],
                        ),
                      )),
                       SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              editDetails(label: "decritption", hint: "some of the features"),
                            ],
                          ),
                        )),
                       SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              editDetails(label: "category", hint: "Hospitality"),
                            ],
                          ),
                        )),
                       SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row( 
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              editDetails(label: "price", hint: "500"),
                               
                            ],
                          ),
                        )),
                      
              
                    ],
                  );
  }
}






