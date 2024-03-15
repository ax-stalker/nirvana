import 'package:cloud_firestore/cloud_firestore.dart';

class MyProduct {
  String? name, businessref, category,description,price;
  List<String>? imageUrls;
  
  // Add other fields as needed
  
  MyProduct({this.name, this.businessref, this.category, this.description, this.price, this.imageUrls, required String id});
  
  // Factory method to create MyProduct from QueryDocumentSnapshot
  factory MyProduct.fromSnapshot(QueryDocumentSnapshot<Object?> snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // Extract imageUrls
    List<String>? imageUrl = [];
    if (data['Imageurls'] != null) {
      for (var imgeUrl in data['Imageurls']) {
        imageUrl.add(imgeUrl.toString());
      }
    }


    return MyProduct(
      id : snapshot.id,
      name: data['name'] as String?,
      category: data['category'],
      description: data['description'],
      price: data['price'],
      imageUrls: imageUrl,
      // Map other fields here
    );
  }
}


// QueryDocumentSnapshot<Object?> snapshot = ...; // Your snapshot from Firestore
// MyObject myObject = MyObject.fromSnapshot(snapshot);





// // Usage:
// void main() {
//   // Assuming you have a reference to your Firestore collection
//   CollectionReference<Object?> yourCollection = FirebaseFirestore.instance.collection('yourCollection');

//   // Retrieve a document snapshot
//   yourCollection.doc('documentId').get().then((snapshot) {
//     if (snapshot.exists) {
//       YourObject yourObject = YourObject.fromFirestore(snapshot as QueryDocumentSnapshot<Object?>);
//       // Now you have your object ready to use
//     } else {
//       print('Document does not exist');
//     }
//   });
// }
