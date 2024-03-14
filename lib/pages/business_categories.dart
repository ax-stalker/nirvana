import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/pages/business_list.dart';

class BusinessCategories extends StatefulWidget {
  @override
  _BusinessCategoriesState createState() => _BusinessCategoriesState();
}

class _BusinessCategoriesState extends State<BusinessCategories> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return ListView.builder(
              // Display a limited number of items for better performance
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final category = snapshot.data!.docs[index];
                final categoryTitle = category['title'];

                // return ListTile(
                //   title: Text(categoryTitle),
                //   onTap: () {
                //     // Navigate to business_list page and pass the category
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => BusinessList(
                //           selectedCategory: categoryTitle,
                //         ),
                //       ),
                //     );
                //   },
                // );
                //   trial
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal:25.0, vertical: 8.0),
                  child: GestureDetector(
                     onTap: () {
                      // Navigate to business_list page and pass the category
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => BusinessList(
                      //       selectedCategory: categoryTitle,
                      //     ),
                      //   ),
                      // );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,

                      ),
                      child: Text(categoryTitle),
                    ),
                  ),
                );




              },
            );
        }
      },
    );
  }
}

