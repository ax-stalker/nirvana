import 'package:cloud_firestore/cloud_firestore.dart';

class SearchBusinessService {
  final _categoriesRef = FirebaseFirestore.instance.collection('category');
  final _businessesRef = FirebaseFirestore.instance.collection('businesses');

  // Function to get suggestions from category collection
  Future<List<String>> getSuggestions(String query) async {
    if (query.isEmpty) {
      return [];
    }
    final suggestions = await _categoriesRef
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + 'zzz')
        .get()
        .then((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
    return suggestions;
  }

  // Function to get businesses based on selected suggestion
  Future<List<Business>> getSearchResults(String category) async {
    final results = await _businessesRef
        .where('category', isEqualTo: category)
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => Business(
                  businessName: doc['business_name'],
                  businessId: doc.id,
                  businessLocation: doc['business_location'],
                ))
            .toList());
    return results;
  }
}

class Business {
  final String businessName;
  final String businessId;
  final String businessLocation;

  Business({
    required this.businessName,
    required this.businessId,
    required this.businessLocation,
  });
}
