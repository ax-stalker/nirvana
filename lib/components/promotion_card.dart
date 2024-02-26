import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nirvana/services/display/display_service.dart';

class PromotionCard extends StatefulWidget {
  final PromotionCardData promotionData;

  const PromotionCard({
    required this.promotionData,
  });

  @override
  State<PromotionCard> createState() => _PromotionCardState();
}

class _PromotionCardState extends State<PromotionCard> {
  Position? _userLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Handle location service disabled case (e.g., prompt user to enable)
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        // Handle denied permission case (e.g., inform user)
        return;
      }
    }

    final Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.promotionData.imageUrl != null)
              CachedNetworkImage(
                imageUrl: widget
                    .promotionData.imageUrl!, // Use ! for non-null assertion
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            const SizedBox(height: 8.0), // Adjust spacing as needed
            Text(
              widget.promotionData.businessName,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0), // Adjust spacing as needed
            Text(widget.promotionData.message),
            const SizedBox(height: 8.0), // Adjust spacing as needed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.promotionData.timestamp),
                Text(widget.promotionData.location),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
