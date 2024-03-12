import 'package:flutter/material.dart';

class Promotion {
  final String businessName;
  final String message;
  final String? imageUrl;
  final String businessId;

  Promotion({
    required this.businessName,
    required this.message,
    required this.imageUrl,
    required this.businessId,
  });
}

class PromotionCard extends StatelessWidget {
  final Promotion promotion;

  const PromotionCard({required this.promotion});

  @override
  Widget build(BuildContext context) {
    // Your PromotionCard widget implementation
    return ListTile(
      title: Text(promotion.businessName),
      subtitle: Text(promotion.message),
    );
  }
}
