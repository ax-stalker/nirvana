import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nirvana/business/pages/account_details.dart';
import 'package:nirvana/business/pages/business_home_page.dart';
import 'package:nirvana/business/pages/business_section.dart';
import 'package:nirvana/business/widgets/helper_function.dart';
import 'package:nirvana/components/my_button.dart';
import 'package:nirvana/services/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {

   const ProfilePage({super.key} );

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
    String profileImageUrl = '';
   String username = '';
  static Map<String, dynamic> userDetails = {};

  final currentUser =FirebaseAuth.instance.currentUser!;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {
    // FirebaseUser user = await FirebaseAuth.instance.currentUser();
     CollectionReference usercol = _firestore.collection('Users');
    return await usercol.where('uid', isEqualTo: currentUser.uid).get()
    .then((value) =>{
      
      // doc =value.docs
      // var user = doc.data();

      // userDetails.addAll();
    if (value.docs.isNotEmpty) {
        for(var doc in value.docs){
          setState(() {
            
          username = doc['email'];
          })
        }
    }
    } );

    // return await _firestore
    //     .collection('Users')
    //     .document(currentUser.uid)
    //     .get()
    //     .then((val) {
    //   userDetails.addAll(val.data);
    // }).whenComplete(() {
    //   print('${userDetails['environment']}');
    //   setState(() {});
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               const SizedBox(height: 20),
               Padding(
                 padding: const EdgeInsets.fromLTRB(8, 16, 8, 32),
                 child: profiler(imageUrl: profileImageUrl),
               ),
             
              const SizedBox(height: 20),
        
              myGestureDetector(name: username, screen:  userProfile(),),
             
              myGestureDetector(name: "Businesses", screen: business_accounts(),),
              GestureDetector(
                onTap: (){
                  final auth= AuthService();
                    auth.signOut();
                },
                child:  SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: const Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('LOG OUT', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Icon(Icons.logout)
                        ],
                      ),
                    ),
                  ),
                ),
              )
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              // ElevatedButton(
              //   onPressed: () {
        
              //   },
              //   child: const Text('Edit'),
              // ),
              // const SizedBox(height: 20),
              // ExpansionTile(title: const Text("Business"),
              // childrenPadding: const EdgeInsets.all(8),
              // children: [
              // ElevatedButton(
              //   onPressed: () {
              //     ShowModalBottomSheet(context);
              //   },
              //   child: const Text('owned business'),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pushNamed(context, '/MyBusinessRegistration');
              //   },
              //   child: const Text('create new business'),
              // ),
        
              // ],),
        
              //   ],
              // ),
            
            ],
          ),
        ),
      ),
    );


    
  }







  Future<dynamic> ShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(

      
                context: context,
                isScrollControlled:  true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical( top: Radius.circular(30))
                ),
                
                builder: (BuildContext context) {
                  return SizedBox(
                    
                    height: 400,
                    child: StreamBuilder<QuerySnapshot>(stream: _firestore.collection('businesses').where('uid', isEqualTo: currentUser.uid).snapshots(), 
                    builder:(context, snapshot){
                       if (snapshot.connectionState == ConnectionState.waiting){
                        return const CircularProgressIndicator();
                       }
                       if (snapshot.hasError){
                        return Text('Error: ${snapshot.error}');
                       }

                      final List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
                      
                      return ListView.separated(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {

                          var document = docs[index]; 
                           return MyButton(text: document["business_name"], onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder:(context)=>BusinessHomePage(id: document.id, name: document['business_name'], category:document['business_category'], description:document['business_description'], contacts:document['business_phone_number'] ,location:document['business_location'], logo_path:document['logo'])));
                          });  
                        }, separatorBuilder: (context, index){return const Divider();},
                      );
                
                    } 
                    ),
                 
                  );
               
                },
                

                
              );
  }
}

class myGestureDetector extends StatelessWidget {
  const myGestureDetector({
    super.key,
    required this.name,
     required this.screen
  });

  final String name;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Helper.navigateToScreen(context, screen);
      },
      child:SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: Card(
          
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text( name,            
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                
             const Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class profiler extends StatefulWidget {
  String imageUrl = '';

   profiler({super.key, required this.imageUrl});

  @override
  State<profiler> createState() => _profilerState();
}

class _profilerState extends State<profiler> {
  File? img;

   Helper assist = Helper();
   bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:115,
      width: 115,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          CircleAvatar(
           backgroundImage: widget.imageUrl.isNotEmpty? NetworkImage(widget.imageUrl) : null,
           child: img == null ?const Text('MP'):Image.file(img!,
        fit: BoxFit.cover,
           ),
          ),
          Positioned(
              bottom: 0,
              right: -25,
              child: RawMaterialButton(
                onPressed: () { displayBottomSheet(context);
                if(img!.path.isNotEmpty){
                  return;
                }
                },
                elevation: 2.0,
                fillColor: const Color(0xFFF5F6F9),
                padding: const EdgeInsets.all(15.0),
                shape: const CircleBorder(),
                child: const Icon(Icons.camera_alt_outlined, color: Colors.blue,)),),
                Visibility(
                  visible: isVisible,

                  child: Positioned( 
                    top: 0,
                    right: -50,
                    
                    child:GestureDetector(
                    onTap: (){
                      // save image to firestore
                      print('saving to firestore $img');

                    },
                    child: const Text("save"),)),
                )
        ],
      ),
    );
  }

 final picker = ImagePicker();

//Image Picker function to get image from gallery
Future getImageFromGallery() async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
      img = File(pickedFile.path);
      isVisible = true;
        
      });
      // img = pickedFile as File?;
      
    }
}

//Image Picker function to get image from camera
Future getImageFromCamera() async {
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

   if (pickedFile != null) {
      // img = File(pickedFile.path);
       setState(() {
      img = File(pickedFile.path);
      isVisible = true;
        
      });
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