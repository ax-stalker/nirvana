import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nirvana/business/models/product.dart';
import 'package:nirvana/business/models/product_controller.dart';

import '../widgets/my_text_form_field.dart';

class createProduct extends StatefulWidget {
   String docid;
    createProduct({super.key, required this.docid});


 

  @override
  State<createProduct> createState() => _createProductState();
}

class _createProductState extends State<createProduct> {

  final prd = Get.put(ProductController());
  MyProduct product = MyProduct();

    final _formKey = GlobalKey<FormState>();

    List<File> imageFileList = [];
    List<XFile> selectedImages = [];
    late String businessreference;


  @override
  void initState() {
    super.initState();
    businessreference = widget.docid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add product".toUpperCase(),
          style: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.w500),

        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child:  Form(
            key :_formKey,

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(

                children: [
                  myTextFormField(controller: prd.nameController, labelText: prd.Labels[0], hint: "Enter product name",),
                  const SizedBox(height: 8,),
                  myTextFormField(controller: prd.descriptionController, labelText: prd.Labels[2], hint: "A brief description about business", max: 2,),
                  const SizedBox(height: 8,),
                  CategoryDropdown(),
                  // myTextFormField(controller: prd.categoryController, labelText: prd.Labels[3], hint: "Category in which the products fall eg cosmetic",),
                  const SizedBox(height: 8,),
                  myTextFormField(controller: prd.priceController, labelText: prd.Labels[1], hint: "product price ", keyboardType: TextInputType.number,),
                  const SizedBox(height: 8,),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("product images"),
                      IconButton(onPressed: (){displayBottomSheet(context);}
                        //   select image from gallery or take one from camera and store in a variable
                      , icon:const  Icon(Icons.camera))
                    ],
                  ),

                  ElevatedButton(onPressed:(){
                    product.name = prd.nameController.text;
                    product.category = prd.categoryController;
                    product.description = prd.descriptionController.text;
                    product.id = businessreference;
                    product.price = prd.priceController.text;
                    product.uploadProductData();
                    
                    
                    Navigator.pop(context);
                    },         //   function to show the details entered by user and save them
                    child:const Text("Add product"),
                  ),
                ],
              ),
            ),

          )
      ),
    );
  }

// void selectImages()async {
//   ImagePicker  imagePicker = ImagePicker();
//    prd.selectedImages = await imagePicker.pickMultiImage();
  

// }

final picker = ImagePicker();

//Image Picker function to get image from gallery
Future getImageFromGallery() async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      product.image = File(pickedFile.path);
    }
}

//Image Picker function to get image from camera
Future getImageFromCamera() async {
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

   if (pickedFile != null) {
      product.image = File(pickedFile.path);
    }
}
Future displayBottomSheet(BuildContext context){
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.grey[300],
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (context) => SizedBox(
      height: 200,
      
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(onPressed: getImageFromGallery, child:const Text("Gallery"), ),
          const SizedBox(height: 20,),
          ElevatedButton(onPressed: getImageFromCamera, child:const Text("camera"),)


        ],
      ),
    )
    );
}

}



class CategoryDropdown extends StatelessWidget {
    final prd = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('product_categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); 
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final categories = snapshot.data!.docs.map((doc) => doc['title'] as String).toList();

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DropdownButton<String>(
            hint: const Text('Select Category'),
            
           value: null, 
           onChanged: (String? selectedCategory) {
              prd.categoryController = selectedCategory;
            
            },
            items: categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
