import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/components/promotion_card.dart';

class BusinessProfilePage extends StatefulWidget {
  const BusinessProfilePage({super.key, required String businessId});

  @override
  State<BusinessProfilePage> createState() => _BusinessProfilePageState();
}

class _BusinessProfilePageState extends State<BusinessProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('hello there'),
    );
  }
}