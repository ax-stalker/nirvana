import 'package:geolocator/geolocator.dart';
import 'package:nirvana/models/fetch_business.dart';
import 'package:nirvana/services/locate/locate_service.dart';

class DistanceService {
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
