import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/business/models/business.dart';
import 'package:nirvana/business/models/product.dart';
import 'package:nirvana/business/pages/add_product_page.dart';
import 'package:nirvana/components/my_drawer.dart';

class BusinessHomePage extends StatelessWidget {
   BusinessHomePage({super.key,required this.name, required this.id,
    required this.category, required this.description, required this.contacts, required this.logo_path, required this.location});
   String id, name, location, category, description, contacts, logo_path;
  
  //  Bbusiness bbusiness;
  
  


  final currentUser =FirebaseAuth.instance.currentUser!;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text(name),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
        // start
      //  body: StreamBuilder<QuerySnapshot>(
      //       stream: FirebaseFirestore.instance.collection('products').where('businessref', isEqualTo: businessId).snapshots(),
      //       builder: (context, snapshot) {
      //               if (snapshot.connectionState == ConnectionState.waiting) {
      //                         return const CircularProgressIndicator(); // Or any loading indicator
      //               }
      //               if (snapshot.hasError) {
      //                         return Text('Error: ${snapshot.error}');

      //               }
      //               if(snapshot.data!.docs.isEmpty) return Center(child: Text("No products "),);
      //               //  final List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
      //               //  String documentid = docs[0].id;
      //                final documents = snapshot.data!.docs;
                    
         
                              
      //               return ListView.separated(
      //                         itemCount: documents.length,
      //                         itemBuilder: (context, index) {
      //                            final document = documents[index];
      //                             MyProduct prduct = MyProduct.fromSnapshot(document);
      //                             print(prduct.name!);
      //                             print(prduct.imageUrls![0]);
      //                             return const Text("ndsfgbfdjgnfjkdng");

      //                           //  return ProductCard(productName: prduct.name!, productDescription: prduct.description!, imagePaths: prduct.imageUrls![0],price: prduct.price!);   
                              
                               
      //                         },
      //                         separatorBuilder: (context, index){return const Divider();},
      //               );
      //                               },
      //                             ),
        // end
        body: ListView(
          
          children: [
            Text("Business name :$id"),
            Text("Business category is : $category"),
            Text("Business description :$description"),
            Text("Business phonenumber :$contacts"),
            Text("Business is located at latitude $location"),
            Image.network(logo_path)
          ],
        ),
      
    floatingActionButton : FloatingActionButton(onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => createProduct(docid: id,)));
          },child: const Icon(Icons.add),),

    );
      
    
  }
}