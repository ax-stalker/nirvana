import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/business/business_registration.dart';
import 'package:nirvana/business/geolocation.dart';
import 'package:nirvana/models/categories.dart';
import 'package:nirvana/services/auth/auth_gate.dart';

import 'package:nirvana/firebase_options.dart';

import 'package:nirvana/pages/profile_page.dart';

import 'package:nirvana/themes/light_mode.dart';
import 'package:nirvana/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);


  runApp(
    ChangeNotifierProvider(create: (context) => ThemeProvider(),
    child:const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: AuthGate(),
      // home: Categories(),  
      routes: {
        '/profilePage':(context)=>  ProfilePage(),
        '/MyGeolocator':(context) => MyGeolocator(),
        '/MyBusinessRegistration':(context) => MyBusinessRegistration(onPressed: () {  },),
      },
    );
  }
}
