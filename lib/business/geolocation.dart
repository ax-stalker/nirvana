import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MyGeolocator extends StatefulWidget {
  const MyGeolocator({super.key});

  @override
  State<MyGeolocator> createState() => _MyGeolocatorState();
}

class _MyGeolocatorState extends State<MyGeolocator> {


void getLocation() async{

  await Geolocator.checkPermission();
  await Geolocator.requestPermission();
  Position position =await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
  print(position);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: ElevatedButton(onPressed: getLocation,
          child: const Text('Get location')),
        )
      )
    );
  }
}