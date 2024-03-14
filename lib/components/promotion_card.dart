import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nirvana/services/display/promotion_service.dart';
import 'package:nirvana/services/locate/locate_service.dart';

class PromotionCard extends StatelessWidget {
  final Map<String, dynamic> promotionData;
  // final Business business; // New required argument
  const PromotionCard({required this.promotionData});

  @override
  Widget build(BuildContext context) {
    // final userLocation = LocationService.getCurrentLocation();
    final imageUrl = promotionData['imageUrl'] ?? ''; // Handle null image URL
    final location =promotionData['businessLocation'].toString().split(',');
    
    final double? latitude = double.tryParse(location[0]);
    final double? longitude = double.tryParse(location[1]);

    
  
 Future<double> _calculateDistance(double latitude, double longitude) async {
      final userLocation = await Geolocator.getCurrentPosition();
      final userLatitude = userLocation.latitude;
      final userLongitude = userLocation.longitude;

      return Geolocator.distanceBetween(
       
        userLatitude,
        userLongitude,
         latitude,
        longitude,
      );
    }


  
Future<double> calculateDistance() async {
      // Extract location data
      final List<String> location =
          promotionData['businessLocation'].toString().split(',');
      final double? latitude = double.tryParse(location[0]);
      final double? longitude = double.tryParse(location[1]);

      if (latitude != null && longitude != null) {
        return await _calculateDistance(latitude, longitude);
      } else {
        // Handle invalid location data (optional)
        return 0.0; // Or any placeholder value
      }
    }


    return Container(
      padding: const EdgeInsets.all(16.0), // Add some padding
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // Add rounded corners
        color: Colors.white, // Set background color
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Add subtle shadow
            spreadRadius: 2.0, // Adjust shadow spread
            blurRadius: 5.0, // Adjust shadow blur
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to left
        children: [
          // Image section (conditional rendering)
          imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10.0), // Rounded corners for image
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    // height: 150.0, // Set image height
                  ),
                )
              : SizedBox.shrink(),
          const SizedBox(height: 10.0), // Add spacing after image

          // Promotion title and message
          Text(
            '@${promotionData['businessName']}',
            style: const TextStyle(fontSize: 12.0, color:Colors.blue ),
          ),
          const SizedBox(height: 5.0), 
          Text(
            promotionData['message'],
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5.0), // Add spacing after title

          // Additional information (optional)
           Text(
            promotionData['businessLocation'].toString(),
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5.0), // Add spacing after title

            FutureBuilder<double>(
          future: calculateDistance(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final distance = snapshot.data!;
              return Text(
                'Distance: ${distance.toStringAsFixed(2)} km', // Format distance with 2 decimal places
                style: const TextStyle(fontSize: 16.0),
              );
            } else if (snapshot.hasError) {
              // Handle errors during location retrieval (optional)
              print(snapshot.error);
              return Text('Error fetching distance');
            }
            // Display loading indicator while waiting for distance
            return CircularProgressIndicator();
          },
        ),
    

          
        ],
      ),
    );
  }
}
