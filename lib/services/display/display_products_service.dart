import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayProductService {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Product>> getProducts() async {
    final snapshot = await _firestore
        .collection(
            'product') // Replace 'products' with your actual collection name
        .get();

    return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
  }
}

class Product {
  final String businessId;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.businessId,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromMap(Map<String, dynamic> data) => Product(
        businessId: data['business_id'] as String,
        name: data['name'] as String,
        price: data['price'] as double,
        imageUrl: data['image']
            as String, // Replace 'image' with your actual image field name
      );
}
