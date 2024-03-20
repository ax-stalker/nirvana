import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:nirvana/business/models/bscontroller.dart';
import 'package:nirvana/business/models/business.dart';

import '../widgets/my_text_form_field.dart';




class createBusiness extends StatelessWidget {
   createBusiness({super.key});
   final businessController = Get.put(BsController());
   String lat = ''; 
   String long = '';



  List<String> labels =["name","Category","Phonenumber","Description","address/location"];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text("Add business".toUpperCase(),
        style: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.w500),

        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child:  Form(
            key :_formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SafeArea(
                child: ListView(    
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,           
                
                  children: [
                  
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                    
                      children: [
                        myTextFormField(controller: businessController.nameController, labelText: labels[0], hint: "Enter business name",),
                        const SizedBox(height: 8,),
                        CategoryDropdown(),
                        // myTextFormField(controller: businessController.categoryController, labelText: labels[1], hint: "The type of the business ",),
                        const SizedBox(height: 10,),
                        ExpansionTile(title: Text(labels[4]),
                        childrenPadding:const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        
                        
                          children: [
                           GestureDetector(
                            onTap: (){determinePosition().then((value){
                              lat = '${value.latitude}';
                              long ='${value.longitude}';
                              print("${lat},${long}");
                              print(value.toString());

                            });},
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Pin current location"),
                                Icon(Icons.location_on)
                              ],
                            ),
                           )
                          ],
                          ),
                        const SizedBox(height: 10,),
                        phoneNumberInput(controller: TextEditingController(),),
                        const SizedBox(height: 8,),
                        myTextFormField(controller: businessController.descriptionController, labelText: labels[3], hint: "A brief description about business", max: 2,),
                        const SizedBox(height: 8,),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            
                            const Text("Business logo"),
                            IconButton(onPressed:() {
                              displayBottomSheet(context);
                              
                            } ,
                                icon:const  Icon(Icons.camera))
                          ],
                        ),
                    
                      ],
                    ),
                
                        Column(
                          children: [
                            ElevatedButton(onPressed:(){
                                Bbusiness  bizz =Bbusiness(name: businessController.nameController.text, category:businessController.categoryController, phonenumber: businessController.phoneController, description: businessController.descriptionController.text,
                                 location: "$lat,$long",logo: businessController.image

                                 );
                                 print("printing phone number ${businessController.phoneController}.");
                                 print(businessController.categoryController);

                        
                                 bizz.uploadBusinessData();
                                 Navigator.pop(context);

                          
                              
                                      // Navigator.push(context, MaterialPageRoute(builder: ((context) => BusinessHomePage(bbusiness: bizz,))));
                            
                                                }, //businessController.UploadBusinessData,
                                child: const Text("create"),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ),

        )
        ),
    );
  }


final picker = ImagePicker();

//Image Picker function to get image from gallery
Future getImageFromGallery() async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      businessController.image = File(pickedFile.path);
    }
}

//Image Picker function to get image from camera
Future getImageFromCamera() async {
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

   if (pickedFile != null) {
      businessController.image = File(pickedFile.path);
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

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
   
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

 
  return await Geolocator.getCurrentPosition();
}


}
class CategoryDropdown extends StatelessWidget {
     final businessController = Get.put(BsController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
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
              // Handle category selection
              businessController.categoryController = selectedCategory!;
              
              print(selectedCategory);
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

class phoneNumberInput extends StatelessWidget {
  phoneNumberInput({super.key,
    required this.controller,
  });

  final TextEditingController controller;
  String initialCountry = 'KE';
  PhoneNumber number = PhoneNumber(isoCode: 'KE');
   final businessController = Get.put(BsController());

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(

      onInputChanged: (PhoneNumber number) {        // businessController.namba = number.phoneNumber;

        print(number.phoneNumber);
        businessController.phoneController = number.phoneNumber;
      },
      onInputValidated: (bool value) {
        if(value == true){

        }
    
        print(value);
      },
      selectorConfig:const  SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        useBottomSheetSafeArea: true,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      selectorTextStyle: const TextStyle(color: Colors.black),
      initialValue: number,
      textFieldController: controller,
      formatInput: true,
      keyboardType:
      const TextInputType.numberWithOptions(signed: true, decimal: true),
      inputBorder: const OutlineInputBorder(),
      onSaved: (PhoneNumber number) {
                // businessController.phoneController = number as String?;
                // print(businessController.phoneController);

        },
      
    );
  }
}


