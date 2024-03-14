import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusinessDropdown extends StatefulWidget {
  const BusinessDropdown({Key? key}) : super(key: key);

  @override
  State<BusinessDropdown> createState() => _BusinessDropdownState();
}

class _BusinessDropdownState extends State<BusinessDropdown> {
  String? selectedBusiness;
  List<Business> businesses = [];

  final _firestore = FirebaseFirestore.instance;

  Stream<List<String>> getBusinesses() {
    // Get business categories only
    return _firestore
        .collection(
            'categories') // Replace 'businesses' with your collection name
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc['title'] as String)
            .toList());
  }

  Stream<List<Business>> getBusinessDetails(String businessCategory) {
    // Get details based on selected category and business_name field
    return _firestore
        .collection('businesses')
        .where('business_category', isEqualTo: businessCategory)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Business(
                  name: doc['business_name'] as String,
                  location: doc['business_location'] as String,
                ))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<List<String>>(
          stream: getBusinesses(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final businesses = snapshot.data!;

            return DropdownButton<String>(
              value: selectedBusiness,
              items: businesses
                  .map((business) => DropdownMenuItem(
                        value: business,
                        child: Text(business),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedBusiness = value!;
                  // Clear previous results and fetch new details
                  this.businesses = [];
                });
              },
            );
          },
        ),
        if (selectedBusiness != null) ...[
          // Show list view with retrieved details
          StreamBuilder<List<Business>>(
            stream: getBusinessDetails(selectedBusiness!),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return Text('Loading details...');
              }

              this.businesses = snapshot.data!; // Update businesses list
              return ListView.builder(
                shrinkWrap: true, // Prevent list from expanding
                itemCount: businesses.length,
                itemBuilder: (context, index) {
                  final business = businesses[index];
                  return ListTile(
                    title: Text(business.name),
                    subtitle: Text(business.location),
                  );
                },
              );
            },
          ),
        ],
      ],
    );
  }
}

class Business {
  final String name;
  final String location;

  Business({required this.name, required this.location});
}
