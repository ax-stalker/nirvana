import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled. Request user to enable them.
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          // Explanation why the app needs location access
          return null;
        }
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied with system settings.
        return null;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager:
          true, // Optional on Android to improve GPS accuracy
    );
     print('latitude =${position.latitude}, longitude =${position.longitude}');

    return position;
  }
}
