import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nirvana/services/locate/locate_service.dart';

class Business {
  final String businessLocation;
  final String name;
  final String business_id;

  Business({
    required this.businessLocation,
    required this.name,
    required this.business_id,
  });
}

class Promotion {

  final String message;
  final String? imageUrl;
  final String businessId;

  Promotion({
    required this.message,
    this.imageUrl,
    required this.businessId,
  });
}

// fetch promotions
Future<List<Business>> fetchBusinesses() async {
  final businessesCollection =
      FirebaseFirestore.instance.collection('businesses');
  final snapshot = await businessesCollection.get();

  final businesses = snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Business(
      business_id: doc.id,
      name: data['business_name'] ?? '',
      businessLocation: data['business_location'] ?? '',
    );
  }).toList();

  return businesses;
}

// get all promotions
Future<List<Promotion>> fetchPromotions() async {
  final promotionsCollection =
      FirebaseFirestore.instance.collection('promotions');
  final snapshot = await promotionsCollection.get();

  final promotions = snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Promotion(
      businessId: data['business_id'],
      message: data['message'],
      imageUrl: data['imageUrl']?? '', 
    );
  }).toList();

  return promotions;
}




class BusinessFilter {
  
  static Future<List<Business>> getNearbyBusinesses(
      List<Business> allBusinesses, double selectedDistance) async {
    final userLocation = await LocationService.getCurrentLocation();
    if (userLocation == null) {
      // Handle case where user location is unavailable
      return [];
    }

    final filteredBusinesses = <Business>[];
    for (var business in allBusinesses) {
      // Parse business location (replace with your parsing logic)
      final locationParts = business.businessLocation.split(',');
      if (locationParts.length != 2) {
        // Invalid location format, skip this business
        continue;
      }

      final double? latitude = double.tryParse(locationParts[0]);
      final double? longitude = double.tryParse(locationParts[1]);

      if (latitude == null || longitude == null) {
        // Invalid latitude or longitude, skip this business
        continue;
      }

      // Calculate distance using a suitable library
      final distance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        latitude,
        longitude,
      );

      if (distance <= selectedDistance) {
        filteredBusinesses.add(business);
      }
    }
    return filteredBusinesses;
  }
}
