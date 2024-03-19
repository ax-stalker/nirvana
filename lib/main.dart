import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/business/geolocation.dart';
import 'package:nirvana/pages/profile_page.dart';
import 'package:nirvana/pages/settings_page.dart';
import 'package:nirvana/services/auth/auth_gate.dart';

import 'package:nirvana/firebase_options.dart';

import 'package:nirvana/pages/promotions_page.dart';

import 'package:nirvana/themes/theme_provider.dart';
import 'package:provider/provider.dart';

// ignore: unused_import
import 'business/pages/bussiness_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
       home: const AuthGate(),
      // home: Categories(),
      // home: ImageUpload(),
      // home: MyHome(),
      // home: BusinessList(),
      // home: PromotionsPage(),
      routes: {
        '/profilePage': (context) => ProfilePage(),
        '/settingsPage': (context) => SettingsPage(),
        '/MyGeolocator': (context) => MyGeolocator(),
        '/MyBusinessRegistration': (context) => createBusiness(),
      },
    );
  }
}
