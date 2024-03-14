import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/business/geolocation.dart';
import 'package:nirvana/business/image_upload.dart';
import 'package:nirvana/business/pages/business_registration.dart';
import 'package:nirvana/business/profile_image.dart';
import 'package:nirvana/models/categories.dart';
import 'package:nirvana/pages/business_list.dart';
import 'package:nirvana/pages/home_page.dart';
import 'package:nirvana/pages/settings_page.dart';
import 'package:nirvana/services/auth/auth_gate.dart';

import 'package:nirvana/firebase_options.dart';

import 'package:nirvana/pages/profile_page.dart';

import 'package:nirvana/themes/light_mode.dart';
import 'package:nirvana/themes/theme_provider.dart';
import 'package:provider/provider.dart';

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
       home: AuthGate(),
      // home: Categories(),
      // home: ImageUpload(),
      // home: MyHome(),
      // home: BusinessList(),
      routes: {
        '/profilePage': (context) => ProfilePage(),
        '/settingsPage': (context) => SettingsPage(),
        '/MyGeolocator': (context) => MyGeolocator(),
        '/MyBusinessRegistration': (context) => MyBusinessRegistration(
              onPressed: () {},
            ),
      },
    );
  }
}
