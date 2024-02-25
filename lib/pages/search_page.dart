import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nirvana/components/appbar.dart';
import 'package:nirvana/components/my_drawer.dart';
import 'package:nirvana/components/search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

 final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _userLocationController = TextEditingController();

  late final String _userId;

  String _category="0";

  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    print(position);
    print(_auth.currentUser?.uid);
    _userId = _auth.currentUser!.uid;
    _userLocationController.text =
        position.latitude.toString() + ',' + position.longitude.toString();
  }
   Stream<QuerySnapshot>? _categoriesStream;

  @override
  void initState() {
    super.initState();
    getLocation();
    _categoriesStream = _firestore.collection('categories').snapshots();
  }
   void getBusinesses() async{
    String location = _userLocationController.text;
    String category = _category;
    QuerySnapshot querySnapshot = await _firestore
     .collection('businesses')
    //  .where('location', isEqualTo: location)
     .where('business_category', isEqualTo: category)
     .get();
    print(querySnapshot.docs);


   }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: const MyAppBar( 'S E A R C H'),
      body: ListView(
          children: [
            StreamBuilder(
                stream: _firestore.collection('categories').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('Some errors occurred ${snapshot.error}'),
                    );
                  }
                  List<DropdownMenuItem> categoryItems = [];
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    final categories = snapshot.data?.docs.reversed.toList();

                    categoryItems.add(
                      DropdownMenuItem(
                        value: '0',
                        child: const Text('Select Category'),
                      ),
                    );
                    for (var category in categories!) {
                      categoryItems.add(
                        DropdownMenuItem(
                          value: category['title'],
                          child: Text(
                            category['title'],
                          ),
                        ),
                      );
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      padding: EdgeInsets.only(right: 15, left: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: DropdownButton(
                        //

                        items: categoryItems,
                        onChanged: (value) {
                          setState(() {
                            _category = value!;
                          });
                          print(value);
                        },
                        value: _category,
                        isExpanded: true,
                        underline: const SizedBox(),
                      ),
                    ),
                  );
                }),

                ElevatedButton(onPressed: getBusinesses, child: Icon(Icons.search))
          ],
        ));
  }
}
