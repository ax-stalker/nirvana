import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nirvana/pages/business_profile.dart';
import 'package:nirvana/pages/business_search.dart';
import 'package:nirvana/services/locate/locate_service.dart';

class BusinessList extends StatefulWidget {
  @override
  _BusinessListState createState() => _BusinessListState();
}

class _BusinessListState extends State<BusinessList> {
  final _firestore = FirebaseFirestore.instance;
  Position? userLocation; // Store user location

  @override
  void initState() {
    super.initState();
    getLocation();
    _checkLocationPermission();
  }

   Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Handle the case where the user has permanently denied location permission
        return;
      }
    }
  }

  Future<void> getLocation() async {
    userLocation = await LocationService.getCurrentLocation();
    setState(() {}); // Trigger UI rebuild after location update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Businesses', style: TextStyle(color: Theme.of(context).colorScheme.primary),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('businesses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              List<DocumentSnapshot> sortedDocs = snapshot.data!.docs;

              if (userLocation != null) {
                sortedDocs.sort((a, b) {
                  final aLocation = a['business_location'].split(',');
                  final bLocation = b['business_location'].split(',');

                  final aLatitude = double.parse(aLocation[0]);
                  final aLongitude = double.parse(aLocation[1]);
                  final bLatitude = double.parse(bLocation[0]);
                  final bLongitude = double.parse(bLocation[1]);

                  final aDistance = Geolocator.distanceBetween(
                        userLocation!.latitude,
                        userLocation!.longitude,
                        aLatitude,
                        aLongitude,
                      ) /
                      1000; // Convert distance to kilometers

                  final bDistance = Geolocator.distanceBetween(
                        userLocation!.latitude,
                        userLocation!.longitude,
                        bLatitude,
                        bLongitude,
                      ) /
                      1000; // Convert distance to kilometers

                  return aDistance.compareTo(bDistance);
                });
              }

              return ListView.builder(
                itemCount: sortedDocs.length,
                itemBuilder: (context, index) {
                  final businessDoc = sortedDocs[index];

                  // Extract business data
                  final businessName = businessDoc['business_name'];
                  final businessCategory = businessDoc['business_category'];
                  final businessLocationString =
                      businessDoc['business_location'];
                  final logoUrl = businessDoc['logo'] ?? '';
                  final businessId = businessDoc.id;

                  // Calculate distance if user location available
                  double distance = 0.0;
                  if (userLocation != null) {
                    final locationParts = businessLocationString.split(',');
                    final businessLatitude = double.parse(locationParts[0]);
                    final businessLongitude = double.parse(locationParts[1]);
                    distance = Geolocator.distanceBetween(
                            userLocation!.latitude,
                            userLocation!.longitude,
                            businessLatitude,
                            businessLongitude) /
                        1000;
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusinessProfilePage(
                            businessId: businessId,
                            userPosition: userLocation,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color:  Theme.of(context).colorScheme.tertiaryContainer,
                      child: ListTile(
                        leading: businessDoc['logo'].isEmpty
                            ? Icon(Icons.business, color: Theme.of(context).colorScheme.secondary)
                            : SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: Image.network(
                                  logoUrl,
                                  errorBuilder: (context, error, stackTrace) =>
                                      CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary),
                                ),
                              ),
                        title: Text(businessName, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                        subtitle: Text(businessCategory ,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary)),
                        trailing: Text(distance.toStringAsFixed(2) +
                            ' km',  style: TextStyle(color: Theme.of(context).colorScheme.primary)), // Display distance
                      ),
                    ),
                  );
                },
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchBusinessPage(),
            ),
          );
        },
        child: Icon(Icons.filter_list),
      ),
    );
  }
}
