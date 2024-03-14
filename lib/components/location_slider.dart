import 'package:flutter/material.dart';

class MyLocationSlider extends StatefulWidget {
  const MyLocationSlider({super.key});

  @override
  State<MyLocationSlider> createState() => _MyLocationSliderState();
}

class _MyLocationSliderState extends State<MyLocationSlider> {
  // create variable
  double _distance = 50;
  double _minValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        Text('Select range for promotional messages', style: TextStyle(fontSize: 20),),
        Text('${_distance.toString()} km', style: TextStyle(fontSize: 20),),
        Slider(
          min:10,
          max: 200,
          divisions: 19,
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Theme.of(context).colorScheme.secondary,
          thumbColor: Theme.of(context).colorScheme.tertiary ,

          value:_distance, 
          onChanged:(value){
          setState(() {
            _distance =value;
          });
        })
      ]),
    );
  }
}
