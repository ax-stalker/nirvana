import 'package:flutter/material.dart';
import 'package:nirvana/business/widgets/display_inputs.dart';
import 'package:nirvana/business/widgets/image_slider_widget.dart';




class userProfile extends StatefulWidget {
   userProfile({super.key,required this.name, required this.id,
    required this.category, required this.description, required this.contacts, required this.logo_path, required this.location});

   String id, name, location, category, description, contacts, logo_path; 
   

  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {


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
            image_slider(urli: widget.logo_path, docid: widget.id,collectionName: "business",varimage:'logo',imagefolder: "business_profile_image",),
                SingleChildScrollView(
              child: Column(
                children: [
                  
                
                  const Padding(
                    padding: EdgeInsets.all(8.0,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Business Information", style: TextStyle(fontSize:20, fontWeight: FontWeight.bold),),
                       
                      ],
                    ),
                  ),
                  displayInfor(label: 'business_name', value: widget.name, docid: widget.id, collectionName: 'businesses',),
                  displayInfor(label:'business_phone_number' , value: widget.contacts, docid: widget.id, collectionName: 'businesses'),
                  displayInfor(label:'business_category', value: widget.category, docid: widget.id, collectionName: 'businesses'),
                  displayInfor(label: 'business_location', value: widget.location, docid: widget.id,collectionName: 'businesses'),
                  displayInfor(label: 'business_description', value: widget.description, docid: widget.id,collectionName: 'businesses'),
                
               
                ]

              ),
            ),
           
         
          ],
        ),
      ),
    
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






