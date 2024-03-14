import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nirvana/services/locate/locate_service.dart';

class SearchBusinessPage extends StatefulWidget {
  const SearchBusinessPage({super.key});

  @override
  State<SearchBusinessPage> createState() => _SearchBusinessPageState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Stream<QuerySnapshot>? _categoriesStream =
    _firestore.collection('categories').snapshots();

String _category = "0";

class _SearchBusinessPageState extends State<SearchBusinessPage> {
  late Position? userPosition;

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    userPosition = await LocationService.getCurrentLocation();
    if (userPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to get current location.')),
      );
    }
    setState(() {});
  }

  List<double> extractCoordinates(String coordinatesString) {
    // Remove leading and trailing parentheses (if present)
    coordinatesString = coordinatesString.trim().replaceAll(RegExp(r'^[()]*$'), '');

    // Split the string by comma, handling potential spaces around the comma
    List<String> coordinatesList = coordinatesString.split(',').map((str) => str.trim()).toList();

    // Check if the number of coordinates is valid (should be 2)
    if (coordinatesList.length != 2) {
      throw FormatException('Invalid coordinates format. Expected "(latitude, longitude)".');
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: StreamBuilder<QuerySnapshot>(
            stream: _categoriesStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              List<DropdownMenuItem<String>> categoryItems = [];
              categoryItems.add(
                DropdownMenuItem(
                  value: '0',
                  child: Text('Select Category', style: TextStyle(color: Colors.grey)),
                ),
              );
              for (var category in snapshot.data!.docs.reversed.toList()) {
                categoryItems.add(
                  DropdownMenuItem(
                    value: category['title'],
                    child: Text(category['title']),
                  ),
                );
              }

              return DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  // Adjust label and hint as needed
                  labelStyle: TextStyle(color: Colors.black),
                ),
                items: categoryItems,
                onChanged: (value) => setState(() => _category = value!),
                dropdownColor: Colors.white, // White background
              );
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('businesses')
              .where('business_category', isEqualTo: _category)
              .snapshots(), // Stream for businesses based on category
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

           List<Business> businesses = [];
            for (var doc in snapshot.data!.docs.reversed.toList()) {
              try {
                // Extract coordinates from business_location
                List<String> coordinatesList =
                    doc['business_location'].split(',');
                if (coordinatesList.length != 2) {
                  throw FormatException(
                      'Invalid coordinates format in business_location. Expected "(latitude, longitude)".');
                }

                // Convert coordinates to doubles
                List<double> coordinates = [];
                for (String coordinateStr in coordinatesList) {
                  coordinates.add(double.parse(
                      coordinateStr.trim())); // Trim leading/trailing spaces
                }

                businesses.add(Business(
                  name: doc['business_name'],
                  latitude: coordinates[0],
                  longitude: coordinates[1],
                ));
              } catch (e) {
                print('Error parsing coordinates for business ${doc.id}: $e');
                // Handle potential errors (e.g., ignore the business, log the error)
              }
            }

             // Sort businesses by distance to user location
            businesses.sort((a, b) {
              if (userPosition == null) {
                return 0; // No location, cannot sort
              }
              final distanceA = Geolocator.distanceBetween(
                userPosition!.latitude,
                userPosition!.longitude,
                a.latitude,
                a.longitude,
              );
              final distanceB = Geolocator.distanceBetween(
                userPosition!.latitude,
                userPosition!.longitude,
                b.latitude,
                b.longitude,
              );
              return distanceA.compareTo(distanceB); // Ascending order
            });



            return ListView.builder(
              itemCount: businesses.length,
              itemBuilder: (context, index) {
                final business = businesses[index];
                double? distance;

                if (userPosition != null) {
                  try {
                    distance = Geolocator.distanceBetween(
                      userPosition!.latitude,
                      userPosition!.longitude,
                      business.latitude,
                      business.longitude,
                    );
                  } catch (e) {
                    print('Error calculating distance: $e');
                  }
                }

                // Fixed future handling for distance
                return FutureBuilder<double>(
                  future: distance != null
                      ? Future.value(distance!)
                      : Future.value(
                          null), // Provide null for invalid or missing distance
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const ListTile(
                        title: Text('Loading distance...'),
                      );
                    }

                    final distanceInKilometers = snapshot.data! / 1000;
                    return ListTile(
                      title: Text(business.name),
                      subtitle: Text(
                        'Distance: ${distanceInKilometers.toStringAsFixed(2)} km',
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class Business {
  final String name;
  final double latitude;
  final double longitude;

  Business(
      {required this.name, required this.latitude, required this.longitude});
}

