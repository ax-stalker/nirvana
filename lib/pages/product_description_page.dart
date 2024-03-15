import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';

class ProductDescriptionPage extends StatelessWidget {
  final DocumentSnapshot product;

  const ProductDescriptionPage(this.product);

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
                    product['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('businesses')
                  .doc(product['business_id'])
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
                          product['name'],
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Price: \$${product['price']}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                         SizedBox(height: 16.0),
                        Text(
                          product['description'],
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
                        Text(
                          'Location: $businessLocation',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // IconButton(
                            //   icon: Icon(Icons.shopping_cart),
                            //   onPressed: () {},
                            // ),
                            // SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: _openMap,
                              child: Text('View on Map'),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  final _call = 'tel:+254$businessPhoneNumber';
                                  if (await canLaunch(_call)) {
                                    await launch(_call);
                                  }
                                },
                                child: Icon(Icons.call))
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
