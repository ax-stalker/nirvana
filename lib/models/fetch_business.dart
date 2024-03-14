import 'package:cloud_firestore/cloud_firestore.dart';


Future<List<Business>> fetchBusinesses() async {
  final businessesCollection =
      FirebaseFirestore.instance.collection('businesses');
  final snapshot = await businessesCollection.get();

  final businesses = snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Business(
      id: doc.id,
      name: data['name'] ?? '', // Handle potential missing values
      businessLocation:
          data['businessLocation'] ?? '',  // Handle potential missing values
    );
  }).toList();

  return businesses; 
}

class Business {
  final String businessLocation;
  final String name;
  final String id;

  Business({
    required this.businessLocation,
    required this.name,
    required this.id,
  });
}
