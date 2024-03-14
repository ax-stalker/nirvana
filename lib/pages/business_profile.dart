import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class BusinessProfilePage extends StatelessWidget {
  final String businessId;
  final Position? userPosition;

  const BusinessProfilePage(
      {required this.businessId, required this.userPosition});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('businesses')
            .doc(businessId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data found'));
          }

          final businessData = snapshot.data!.data() as Map<String, dynamic>;

          double distanceInKm = 0.0;
          if (userPosition != null) {
            final businessLocation =
                businessData['business_location'] as String;
            final businessCoordinates = extractCoordinates(businessLocation);
            distanceInKm = Geolocator.distanceBetween(
                  userPosition!.latitude,
                  userPosition!.longitude,
                  businessCoordinates[0],
                  businessCoordinates[1],
                ) /
                1000; // Convert to kilometers
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (businessData['logo'] != null &&
                    businessData['logo'].isNotEmpty)
                  Center(
                    child: Image.network(
                      businessData['logo'],
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 16.0),
                Card(
                  child: ListTile(
                    title: Text('Name: ${businessData['business_name']}'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title:
                        Text('Category: ${businessData['business_category']}'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                        'Description: ${businessData['business_description']}'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                        'Location: ${(distanceInKm).toStringAsFixed(2)} km'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                        'Phone Number: ${businessData['business_phone_number']}'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<double> extractCoordinates(String coordinatesString) {
    // Remove leading and trailing parentheses (if present)
    coordinatesString =
        coordinatesString.trim().replaceAll(RegExp(r'^[()]*$'), '');

    // Split the string by comma, handling potential spaces around the comma
    List<String> coordinatesList =
        coordinatesString.split(',').map((str) => str.trim()).toList();

    // Check if the number of coordinates is valid (should be 2)
    if (coordinatesList.length != 2) {
      throw FormatException(
          'Invalid coordinates format. Expected "(latitude, longitude)".');
    }

    // Convert each coordinate string to a double
    List<double> coordinates = [];
    for (String coordinateStr in coordinatesList) {
      try {
        coordinates.add(double.parse(coordinateStr));
      } catch (e) {
        throw FormatException('Invalid coordinate format. Expected numbers.');
      }
    }

    return coordinates;
  }
}
