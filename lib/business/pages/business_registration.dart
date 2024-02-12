import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nirvana/components/my_textfield.dart';
import 'package:nirvana/components/textarea.dart';
import 'package:nirvana/services/auth/auth_service.dart';

class MyBusinessRegistration extends StatefulWidget {
  final void Function()? onPressed;

  MyBusinessRegistration({
    super.key,
    required this.onPressed,
  });

  @override
  State<MyBusinessRegistration> createState() => _MyBusinessRegistrationState();
}

class _MyBusinessRegistrationState extends State<MyBusinessRegistration> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _businessNameController = TextEditingController();
  // final TextEditingController _businessCategoryController = TextEditingController();
  final TextEditingController _businessPhoneNumberController =
      TextEditingController();
  final TextEditingController _businessLocationController =
      TextEditingController();
  final TextEditingController _businessDescriptionController =TextEditingController();
  PlatformFile? pickedFile;

  late final String _userId;
  String _category = '0';

  // deal with images
  Future SelectFile ()async {
    final result =await FilePicker.platform.pickFiles();
    if (result==null) return;
    setState(() {
      pickedFile = result.files.first;
    });
    
  }
  Future uploadImage() async{
    final path ='files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
  }

  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    print(position);
    print(_auth.currentUser?.uid);
    _userId = _auth.currentUser!.uid;
    _businessLocationController.text =
        position.latitude.toString() + ',' + position.longitude.toString();
  }

  Stream<QuerySnapshot>? _categoriesStream;

  @override
  void initState() {
    super.initState();
    _categoriesStream = _firestore.collection('categories').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Registration'),
      ),
      body: ListView(
        children: [
          //  logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:25.0, vertical:10),
            child: Container(
              decoration: BoxDecoration(
                 color: Theme.of(context).colorScheme.background,
                 
              ),
              child: Row(children: [
                 Icon(Icons.cameraswitch,color: Theme.of(context).colorScheme.primary,), 
                Text('    Upload Logo',style: TextStyle(color:Theme.of(context).colorScheme.primary),),
                
              ],),
            ),
          ),
          

          SizedBox(height: 15),
          // business name textfield
          MyTextField(
            controller: _businessNameController,
            hintText: 'Business name',
            obscureText: false,
          ),
          SizedBox(height: 15),
    
          // Business category
          // StreamBuilder for categories
          StreamBuilder(
              stream: _firestore.collection('categories').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('Some errors occurred ${snapshot.error}'),
                  );
                }
                List<DropdownMenuItem> categoryItems = [];
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                } else {
                  final categories = snapshot.data?.docs.reversed.toList();
    
                  categoryItems.add(
                    DropdownMenuItem(
                      value: '0',
                      child: const Text('Select Category'),
                    ),
                  );
                  for (var category in categories!) {
                    categoryItems.add(
                      DropdownMenuItem(
                        value: category['title'],
                        child: Text(
                          category['title'],
                        ),
                      ),
                    );
                  }
                }
    
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    padding: EdgeInsets.only(right: 15, left: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: DropdownButton(
                      //
    
                      items: categoryItems,
                      onChanged: (value) {
                        setState(() {
                          _category = value!;
                        });
                        print(value);
                      },
                      value: _category,
                      isExpanded: true,
                      underline: const SizedBox(),
                    ),
                  ),
                );
              }),
    
          SizedBox(height: 15),
          // business phone number textfield
          MyTextField(
            controller: _businessPhoneNumberController,
            hintText: 'Business phone number',
            obscureText: false,
          ),
          SizedBox(height: 15),
          // bio
         MyTextArea(controller: _businessDescriptionController),

          SizedBox(height: 15),
    
          // location button
          ElevatedButton(
              onPressed: getLocation, child: const Text('Get location')),
          SizedBox(height: 15),
          // finish button
          ElevatedButton(
            onPressed: () async {
              if (FirebaseAuth.instance.currentUser != null) {
                // Proceed with data creation and Firestore add if all checks pass
                if (_userId.isNotEmpty &&
                    _businessNameController.text.isNotEmpty &&
                    _businessLocationController.text.isNotEmpty &&
                    _category.isNotEmpty &&
                    _businessPhoneNumberController.text.isNotEmpty &&
                    _businessDescriptionController.text.isNotEmpty
                    ) {
                  Map<String, dynamic> data = {
                    'uid': _userId,
                    'business_name': _businessNameController.text,
                    'business_category': _category,
                    'business_phone_number': _businessPhoneNumberController.text,
                    'business_location': _businessLocationController.text,
                    'business_description': _businessDescriptionController.text,
                  };
    
                  _firestore.collection('businesses').add(data);
                  print('added to database');
                  _businessNameController.clear();
                  _businessLocationController.clear();
                  _businessPhoneNumberController.clear();
                  _businessLocationController.clear();
                  _businessDescriptionController.clear();
                } else {
                  // Handle cases where some fields are invalid
                  print("Missing or invalid data");
                }
              } else {
                // Handle user not logged in case (e.g., show error message or redirect to login)
                print("User not logged in");
              }
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }
}
