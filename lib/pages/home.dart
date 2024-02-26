import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/components/promotion_card.dart';
import 'package:nirvana/services/display/display_service.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
   late Future<List<PromotionCardData>> _promotions;

  @override
  void initState() {
    super.initState();
    _promotions = DisplayServices.getPromotions(); // Fetch promotions
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      FutureBuilder<List<PromotionCardData>>(
      future: _promotions,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final promotions = snapshot.data;
          return ListView.builder(
            itemCount: promotions?.length,
            itemBuilder: (context, index) {
              final promotion = promotions?[index];
              if (promotion != null) {
                  return PromotionCard(promotionData: promotion);
                } else {
                  return null; // Or return an alternative widget (e.g., Text('No data available'))
                }
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Handle errors
        }
        return const Center(child: CircularProgressIndicator()); // Show loading indicator
      },
    ),
  );
}
}