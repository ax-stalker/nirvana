import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MySearch extends StatefulWidget {
 MySearch({super.key});

  @override
  State<MySearch> createState() => _MySearchState();
}

class _MySearchState extends State<MySearch> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

   final TextEditingController _userLocationController =
      TextEditingController();

   late final String _userId;

  String _category = '0';

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
    _categoriesStream = _firestore.collection('categories').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: ListView(children: [
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
      ],)
    );
  }
}