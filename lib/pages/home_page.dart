// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/components/appbar.dart';
import 'package:nirvana/components/bottom_nav_bar.dart';
import 'package:nirvana/components/promotion_card.dart';
// import 'package:nirvana/components/business_dropdown.dart';
// import 'package:nirvana/components/location_slider.dart';

// import 'package:nirvana/models/promotions.dart';
 import 'package:nirvana/pages/search_business_page.dart' as SearchBusiness;

import 'package:nirvana/services/display/promotion_service.dart';
// import 'package:nirvana/services/search/search_business_service.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
   List<Map<String, dynamic>> _combinedData = []; // Store combined data

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data on initialization
  }


  Future<void> _fetchData() async {
    // ... (existing code to fetch businesses and promotions)
     // Call your functions to fetch businesses and promotions
    final businesses = await fetchBusinesses();
    final promotions = await fetchPromotions();

    _combinedData = promotions
        .map((promotion) {
          final matchingBusiness = businesses.firstWhere(
            (business) => business.business_id == promotion.businessId,
             // Handle case where business is not found
          );

          if (matchingBusiness == null)
            return null; // Skip promotion if business not found

          return {
            'businessName': matchingBusiness.name,
            'businessLocation': matchingBusiness.businessLocation,
            'imageUrl': promotion.imageUrl ?? '', // Handle null image URL
            'message': promotion.message,
           
          };
        })
        .where((data) => data != null).cast<Map<String, dynamic>>()
        .toList();

    // Update UI with combined data
    setState(() {});
  }
  

  void showLocationRangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        double _distance = 50; // Initialize slider value

        return AlertDialog(
          title: Text("Select Range for Promotions"),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Avoid exceeding screen size
            children: [
              
              
              StatefulBuilder(
                builder: (context, state) {
                  return Slider(
                    value: _distance,
                  
                    min: 10,
                    max: 200,
                    divisions: 19,
                    label: '${_distance.toString()} km',
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Theme.of(context).colorScheme.secondary,
                    thumbColor: Theme.of(context).colorScheme.tertiary,
                    onChanged: (value) {
                      state(() {
                        // Use setState within the dialog's context
                        _distance = value;
                      });
                    },
                  );
                }
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Process the selected distance (e.g., print it)
                print("Selected distance: $_distance km");
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context), // Close without saving
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar("HOMEPAGE"),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => SearchBusiness.SearchBusinessPage()),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Theme.of(context).colorScheme.background,
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary)),
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          
                          children: [
                          Icon(Icons.search,
                              color: Theme.of(context).colorScheme.primary, size: 30),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Search for a service",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right:25.0),
                child: IconButton(
                    onPressed: () => showLocationRangeDialog(context),
                    icon: Icon(Icons.sort,
                        color: Theme.of(context).colorScheme.primary)),
              )
            ],
          ),
        // promotions and offers section
         _combinedData.isNotEmpty
              ? ListView.builder(
                shrinkWrap: true,
                  itemCount: _combinedData.length,
                  itemBuilder: (context, index) {
                    final promotionData = _combinedData[index];
                    // Use this promotion data to populate your promotion card widget
                    return PromotionCard(promotionData: promotionData,);
                  },
                )
              : Text("No promotions found"),
        ],
        
      ),
      // MyBottomNavBar(onTabChange: (int ) { 0 },);
    );
  }
}
