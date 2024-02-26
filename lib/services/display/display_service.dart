import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // for @required annotation

// Replace with your actual model or data structure
@immutable // Enforces immutability for data integrity
class PromotionCardData {
  final String businessName;
  final String message;
  final String ?imageUrl;
  final String timestamp; // unmodified timestamp string
  final String location;
  final double? distance; // unmodified location string

  const PromotionCardData({
    required this.businessName,
    required this.message,
    this.imageUrl,
    required this.timestamp,
    required this.location,
    this.distance,
  });
}

class DisplayServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<PromotionCardData>> getPromotions() async {
    // Get promotions with timestamp order
    final promotionsQuery = await _firestore
        .collection('promotions')
        .orderBy('timestamp', descending: true)
        .get();

    final List<PromotionCardData> promotions = [];
    for (var promotionDoc in promotionsQuery.docs) {
      final promotionData = promotionDoc.data();
      final businessId = promotionData['business_id'];

      // Get business details
      final businessDoc =
          await _firestore.collection('businesses').doc(businessId).get();
      if (businessDoc.exists) {
        final businessData = businessDoc.data();
        final businessName = businessData?['business_name'];
        final location = businessData?['business_location'];


        // Combine data
        final promotionCardData = PromotionCardData(
          businessName: businessName,
          message: promotionData['message'],
           imageUrl: promotionData.containsKey('image')
              ? promotionData['image']
              : null,
          timestamp: promotionData['timestamp']
              .toString(), // Convert Timestamp to String
          location: location,
        );
        // Log the image URL
        print('Image URL from promotion: ${promotionCardData.imageUrl}');

        promotions.add(promotionCardData);
      }
    }

    return promotions;
  }


}
