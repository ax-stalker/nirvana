//  displays a single product
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';


class ProductDescriptionPage extends StatefulWidget {
  final DocumentSnapshot product;

  const ProductDescriptionPage(this.product);

  @override
  State<ProductDescriptionPage> createState() => _ProductDescriptionPageState();
}


class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
  


  Future<double> _calculateDistance(String location) async {
    final userLocation = await _getUserLocation();
    final List<String> parts = location.split(',');
    final double businessLatitude = double.parse(parts[0]);
    final double businessLongitude = double.parse(parts[1]);
    final double distanceInMeters = await Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      businessLatitude,
      businessLongitude,
    );
    return distanceInMeters / 1000; // Convert meters to kilometers
  }

  Future<Position> _getUserLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }


  // added

  Future<String?> _checkUserRole() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();
        if (userDoc.exists && userDoc.data() != null) {
          final Map<String, dynamic> userData =
              userDoc.data()! as Map<String, dynamic>;
          return userData['role'];
        }
      }
    } catch (e) {
      print('Error checking user role: $e');
    }
    return null;
  }

  Future<void> _deleteProduct() async {
    try {
      await FirebaseFirestore.instance
          .collection('product')
          .doc(widget.product.id)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully!'),
        ),
      );
      Navigator.pop(context); // Go back to the previous page
    } catch (e) {
      print('Error deleting product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting product: ${e.toString()}'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Description"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: AspectRatio(
                  aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
                  child: Image.network(
                    widget.product['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('businesses')
                  .doc(widget.product['business_id'])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Text('No data found');
                }

                final businessData =
                    snapshot.data!.data() as Map<String, dynamic>;
                final businessName = businessData['business_name'];
                final businessLocation = businessData['business_location'];
                final businessPhoneNumber =
                    businessData['business_phone_number'];
               

                // for google maps
                Future<void> _openMap() async {
                  final String location = businessLocation;
                  final List<String> parts = location.split(',');
                  final double latitude = double.parse(parts[0]);
                  final double longitude = double.parse(parts[1]);
                  final String mapsUrl =
                      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

                  if (await canLaunch(mapsUrl)) {
                    await launch(mapsUrl);
                  } else {
                    throw 'Could not launch $mapsUrl';
                  }
                }

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product['name'],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Price: KSH: ${widget.product['price']}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                         SizedBox(height: 16.0),
                        Text(
                          widget.product['description'],
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(height: 16.0),
                        
                        Text(
                          'Business Name: $businessName',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // SizedBox(height: 16.0),
                        Text(
                          'Contact: $businessPhoneNumber',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // distance
                        FutureBuilder<double>(
                          future: _calculateDistance(businessLocation),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (!snapshot.hasData || snapshot.data == null) {
                              return Text('No data found');
                            }

                            final distance = snapshot.data!;
                            return Text(
                              'Distance: ${distance.toStringAsFixed(2)} km',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          
                            // SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: _openMap,
                              child: Text('View on Map'),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  final _call = 'tel:$businessPhoneNumber';
                                  if (await canLaunch(_call)) {
                                    await launch(_call);
                                  }
                                },
                                child: Icon(Icons.call)),

                                FutureBuilder<String?>(
  future: _checkUserRole(),
  builder: (context, snapshot) {
    if (snapshot.hasData && snapshot.data == 'admin') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red, // Indicate a destructive action
        ),
        onPressed: () async {
          final shouldDelete = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Confirm Deletion'),
              content: const Text(
                  'Are you sure you want to delete this product? This action cannot be undone.'),
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
            await _deleteProduct();
          }
        },
        child: const Text('Delete'),
      );
    } else {
      return Container(); // Hide button for non-admins
    }
  },
),

                          ],
                        ),
                      ],
                    ),
                  ),
                );

              },
             
            ),
            
          ],
        ),
      ),
    );
  }
 
}
