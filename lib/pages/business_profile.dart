import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessProfilePage extends StatefulWidget {
  final String businessId;
  final Position? userPosition;

  const BusinessProfilePage(
      {required this.businessId, required this.userPosition});

  @override
  State<BusinessProfilePage> createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {

// added
  final _firestore =
      FirebaseFirestore.instance; // Assuming FirebaseFirestore is initialized
  late Future<String?> userRole; // Get user role

  @override
  void initState() {
    super.initState();
    userRole = checkUserRole(); // Get user role on widget initialization
  }

  Future<void> deleteBusiness(String businessId) async {
    final shouldDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
            'Are you sure you want to delete this business and all its products? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Delete
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete ?? false) {
      try {
        // Delete products
        QuerySnapshot querySnapshot = await _firestore
            .collection('products')
            .where('business_id', isEqualTo: businessId)
            .get();
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });

        // Delete business
        await _firestore.collection('businesses').doc(businessId).delete();

        // Show success message (optional)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Business and products deleted successfully!'),
          ),
        );
      } catch (e) {
        print('Error deleting business and products: $e');
        // Show error message (optional)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting business: ${e.toString()}'),
          ),
        );
      }
    }
  }

  Future<String?> checkUserRole() async {
    try {
      // Get current user
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get user document from Firestore
        final DocumentSnapshot userDoc =
            await _firestore.collection('Users').doc(user.uid).get();
        if (userDoc.exists && userDoc.data() != null) {
          // Cast data to Map to use containsKey
          final Map<String, dynamic> userData =
              userDoc.data()! as Map<String, dynamic>;
          if (userData.containsKey('role')) {
            return userData['role'];
          }
        }
      }
    } catch (e) {
      print('Error checking user role: $e');
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('businesses')
            .doc(widget.businessId)
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
          if (widget.userPosition != null) {
            final businessLocation =
                businessData['business_location'] as String;
            final businessCoordinates = extractCoordinates(businessLocation);
            distanceInKm = Geolocator.distanceBetween(
                  widget.userPosition!.latitude,
                  widget.userPosition!.longitude,
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
                    title: Text('${businessData['business_name']}' ,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary)),
                  ),
                ),
                Card(
                  child: ListTile(
                    title:
                        Text('Category: ${businessData['business_category']}' ,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                        'Description: ${businessData['business_description']}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                        '${(distanceInKm).toStringAsFixed(2)} km away',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                        'Phone Number: ${businessData['business_phone_number']}',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                ),
                 Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
          
                    SizedBox(height: 16.0),
                    
                    ElevatedButton(
                        onPressed: () async {
                          final _call = 'tel:${businessData['business_phone_number']}';
                          if (await canLaunch(_call)) {
                            await launch(_call);
                          }
                        },
                        child: Icon(Icons.call)),

                        
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FutureBuilder<String?>(
        future: userRole,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == 'admin') {
            return FloatingActionButton(
              onPressed: () => deleteBusiness(widget.businessId),
              child: const Icon(Icons.delete),
            );
          } else {
            return Container(); // Hide button for non-admins
          }
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
