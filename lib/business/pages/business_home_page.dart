import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/business/pages/account_details.dart';
import 'package:nirvana/business/pages/add_product_page.dart';
import 'package:nirvana/business/pages/business_section.dart';
import 'package:nirvana/business/pages/product_preview.dart';
import 'package:nirvana/business/widgets/helper_function.dart';
import 'package:nirvana/components/my_drawer.dart';
import 'package:nirvana/components/product_card.dart';

class BusinessHomePage extends StatelessWidget {
   BusinessHomePage({super.key,required this.name, required this.id,
    required this.category, required this.description, required this.contacts, required this.logo_path, required this.location});
   String id, name, location, category, description, contacts, logo_path;
   List<String> label =['business_name,business_category, business_description, business_id, business_location,business_phone_number, business_logo'];
  
  //  Bbusiness bbusiness;
  
  


  final currentUser =FirebaseAuth.instance.currentUser!;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text(name),
        centerTitle: true,
        actions: [IconButton.outlined(onPressed: () => Helper.navigateToScreen(context,userProfile(id: id,
        name: name,
        location: location,
        category: category,
        contacts: contacts,
        logo_path: logo_path,
        description: description,
        )), icon: const Icon(Icons.person))],
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
                   
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context,index){
                    products[index].id;
                      var product = products[index].data() as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: (){Helper.navigateToScreen(context, productPreview(name: product['name'], id: products[index].id, price: product['price'], category: product['category'], description: product['description'], logo_path: product['image']));},
                        child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.network(
                                    product['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'],
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'ksh ${product['price']}',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      );
                      // return  SizedBox(
                      //   height: 200,
                      //   width: 200,
                      //   // width: MediaQuery.of(context).size.width*0.2, // Half the screen width
                      //   child: Card(
                      //     child: Column(
                      //       children: [
                      //         Image.network(product['image']), // Display the image
                      //         Text(product['name'], style: const TextStyle(fontSize: 16.0)),
                      //         Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text(
                      //               '\ksh ${product['price']}',
                      //               style: const TextStyle(fontWeight: FontWeight.bold),
                      //             ),
                      //             // Add any additional buttons or actions here (optional)
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // );
                    // return Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: ExpansionTile(title: Text(product['name']),
                    //   leading: CircleAvatar(
                    //       radius: 30.0,
                    //       backgroundImage:
                    //           NetworkImage(product['image']),
                    //       backgroundColor: Colors.transparent,
                    //     ),
                    //     expandedCrossAxisAlignment: CrossAxisAlignment.center,
                        
                    //   children: [
                    //    const Text("Category", style: TextStyle(fontWeight: FontWeight.bold),), const SizedBox(height: 8,),
                    //        Text("${product['category']}",overflow: TextOverflow.ellipsis,),
                    //        const SizedBox(height: 8,),
                    //        IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  previewPoduct(image: product['image'],))) , icon:const Icon(Icons.edit)),
                          
                        
                    //     ListTile(title: Text(product['price']),),
                    //   ],
                    //   ),
                    

                        
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





