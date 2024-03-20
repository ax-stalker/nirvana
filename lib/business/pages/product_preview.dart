import 'package:flutter/material.dart';
import 'package:nirvana/business/widgets/display_inputs.dart';
import 'package:nirvana/business/widgets/image_slider_widget.dart';




class productPreview extends StatefulWidget {
   productPreview({super.key,required this.name, required this.id, required this.price,
    required this.category, required this.description, required this.logo_path,});

   String id, name, category, description, price, logo_path; 
   

  @override
  State<productPreview> createState() => _productPreviewState();
}

class _productPreviewState extends State<productPreview> {
  String collection_name = 'product';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: SingleChildScrollView(
        child: Column(
          children: [
            image_slider(urli: widget.logo_path, docid: widget.id,collectionName: collection_name,imagefolder: 'product_images',),
                SingleChildScrollView(
              child: Column(
                children: [
                  
                
                  const Padding(
                    padding: EdgeInsets.all(8.0,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Product Information", style: TextStyle(fontSize:20, fontWeight: FontWeight.bold),),
                       
                      ],
                    ),
                  ),
      



                  displayInfor(label: 'name', value: widget.name, docid: widget.id, collectionName: collection_name,),
                  displayInfor(label:'category', value: widget.category, docid: widget.id, collectionName: collection_name),
                  // displayInfor(label: 'usiness_location', value: widget.location, docid: widget.id,collectionName: collection_name),
                  displayInfor(label: 'description', value: widget.description, docid: widget.id,collectionName: collection_name),
                  displayInfor(label:'Price' , value: 'ksh ${widget.price}', docid: widget.id, collectionName: collection_name),
                
               
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






