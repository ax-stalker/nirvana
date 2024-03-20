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
                    print("product name is ${product['name']} and its description is ${product['description']}");
                    return ExpansionTile(title: Text(product['name']),
                    // leading: CircleAvatar(
                    //     radius: 30.0,
                    //     backgroundImage:
                    //         NetworkImage(product['image']),
                    //     backgroundColor: Colors.transparent,
                    //   ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                          
                        radius: 30.0,
                        backgroundImage:
                            NetworkImage(product['image']),
                        backgroundColor: Colors.transparent,
                      ),
                      Column(
                        children: [const Text("description", style: TextStyle(fontWeight: FontWeight.bold),), const SizedBox(height: 8,),
                          Text("${product['description']}",   overflow: TextOverflow.ellipsis,),
                         const SizedBox(height: 10,),
                         const Text("Category", style: TextStyle(fontWeight: FontWeight.bold),), const SizedBox(height: 8,),
                         Text("${product['category']}",overflow: TextOverflow.ellipsis,)
                         ],
                      )
                        ],
                      ),
                      
                      ListTile(title: Text(product['price']),),
                    ],
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





// class ProductsByBusiness extends StatelessWidget {
//   final String businessId;

//   ProductsByBusiness({required this.businessId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Products by Business')),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('products').where('business_id', isEqualTo: businessId).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           List<DocumentSnapshot> products = snapshot.data!.docs;

//           if (products.isEmpty) {
//             return Center(child: Text('No products available for this business'));
//           }

//           return ListView.builder(
//             itemCount: products.length,
//             itemBuilder: (context, index) {
//               var product = products[index].data() as Map<String, dynamic>;
//               return ExpansionTile(
//                 title: Text(product['name']),
//                 subtitle: Text(product['description']),
//                 children: [
//                   ListTile(
//                     title: Text('Price: \$${product['price']}'),
//                     // Add more details here if needed
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: ProductsByBusiness(
//       businessId: 'your_business_id', // Provide the business_id here
//     ),
//   ));
// }
