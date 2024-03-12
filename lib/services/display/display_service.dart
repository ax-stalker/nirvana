import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart'; // for @required annotation

// Replace with your actual model or data structure
@immutable // Enforces immutability for data integrity
class PromotionCardData {
 final String businessName;
  final String message;
  final String? imageUrl;
  final String businessId; 

  const PromotionCardData({
    required this.businessName,
    required this.message,
    required this.imageUrl,
    required this.businessId,
  });


 

}

class DisplayServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<PromotionCardData>> getPromotions() async {
    // Get promotions with timestamp order
    final promotionsQuery = await _firestore
        .collection('promotions')
        .orderBy('timestamp',
            descending: true) // You can still order by timestamp if needed
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

        // Combine data
        final promotionCardData = PromotionCardData(
          businessName: businessName,
          businessId: promotionData['business_id'],
          message: promotionData['message'],
          imageUrl: promotionData['image'],
        );
        promotions.add(promotionCardData);
      }
    }

    return promotions;
  }
}
