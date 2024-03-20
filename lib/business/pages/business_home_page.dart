import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      drawer:  MyDrawer(),
        // start
       body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('product').where('business_id', isEqualTo: id).snapshots(),
            builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator(); // Or any loading indicator
                    }
                    if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');

                    }
                  
                     List<DocumentSnapshot> products = snapshot.data!.docs;
                    if(products.isEmpty) {
                      return  SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(child: Text("No products ", style: TextStyle(fontSize: 20, color: Colors.grey),)),);
                    }
                    print('number of products ${products.length}');
                    // var product = products[0].data() as Map<String, dynamic>;
                    // print("product name is ${product['name']} and its description is ${product['description']}");
                    // return Text("${product}");
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context,index){
                      var product = products[index].data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpansionTile(title: Text(product['name']),
                      leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                              NetworkImage(product['image']),
                          backgroundColor: Colors.transparent,
                        ),
                        expandedCrossAxisAlignment: CrossAxisAlignment.center,
                        
                      children: [
                       const Text("Category", style: TextStyle(fontWeight: FontWeight.bold),), const SizedBox(height: 8,),
                           Text("${product['category']}",overflow: TextOverflow.ellipsis,),
                           const SizedBox(height: 8,),
                           IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  previewPoduct(image: product['image'],))) , icon:const Icon(Icons.edit)),
                          
                        
                        ListTile(title: Text(product['price']),),
                      ],
                      ),
                    );

                        
                      }
                      );


           
         
                
                                    },
                                  ),
        
      
    floatingActionButton : FloatingActionButton(onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => createProduct(docid: id,)));
          },child: const Icon(Icons.add),),

    );
      
    
  }
}

class previewPoduct extends StatelessWidget {
   previewPoduct({super.key, required this.image});
String image;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(title: const Text("Product details"), centerTitle: true,),
      body: ListView(
        children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: AspectRatio(
                  aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      )

    );
  }
}





