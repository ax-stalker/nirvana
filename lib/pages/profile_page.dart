import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/business/pages/business_home_page.dart';
import 'package:nirvana/components/my_button.dart';

class ProfilePage extends StatefulWidget {

   const ProfilePage({super.key} );

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String profileImageUrl ="https://i.pinimg.com/736x/a2/7a/3f/a27a3fb05e975385380921e54f859f4f.jpg";

  final String username = "User name";

  final currentUser =FirebaseAuth.instance.currentUser!;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            const SizedBox(height: 20),
            Text(
              username,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            ElevatedButton(
              onPressed: () {

              },
              child: const Text('Edit'),
            ),
            const SizedBox(height: 20),
            ExpansionTile(title: const Text("Business"),
            childrenPadding: const EdgeInsets.all(8),
            children: [
            ElevatedButton(
              onPressed: () {
                ShowModalBottomSheet(context);
              },
              child: const Text('owned business'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/MyBusinessRegistration');
              },
              child: const Text('create new business'),
            ),

            ],),

              ],
            ),
          ],
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
                    
                    height: 200,
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

