import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nirvana/admin/businesses_list_admin.dart';
import 'package:nirvana/pages/home_page.dart';
import 'package:nirvana/services/auth/auth_service.dart';
import 'package:nirvana/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
   MyDrawer({super.key});

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void logOut() {
    // Get auth service
    final auth = AuthService();
    auth.signOut();
  }


 Future<String?> checkUserRole() async {
    try {
      // Get current user
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get user document from Firestore
        final DocumentSnapshot userDoc =
            await _firestore.collection('Users').doc(user.uid).get();
        if (userDoc.exists && userDoc.data() != null) {
          // Cast data to Map to use containsKey
          final Map<String, dynamic> userData =
              userDoc.data()! as Map<String, dynamic>;
          if (userData.containsKey('role')) {
            return userData['role'];
          }
        }
      }
    } catch (e) {
      print('Error checking user role: $e');
    }
    return null;
  }



  @override
  Widget build(BuildContext context) {
    final Future<String?> userRole = checkUserRole(); // Get user role

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // logo

              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.light,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                ),
              ),

               // Admin buttons (conditionally displayed)
              FutureBuilder<String?>(
                future: userRole,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data == 'admin') {
                    return Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: ListTile(
                              title: const Text('A D M I N',
                                  style: TextStyle(color: Colors.red)),
                              leading: const Icon(Icons.admin_panel_settings,
                                  color: Colors.red),
                            )),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 25.0),
                        //   child: ListTile(
                        //     title: const Text('Businesses Management'),
                        //     leading: const Icon(Icons.admin_panel_settings),
                        //     onTap: () {
                        //       // Handle admin button 1 click (replace with your action)
                        //       print('Exercise your power on businesses');
                        //       Navigator.pop(context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BusinessAdmin(),
                        //   ),);
                        //     },
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 25.0),
                        //   child: ListTile(
                        //     title: const Text('Products Management'),
                        //     leading: const Icon(Icons.admin_panel_settings),
                        //     onTap: () {
                        //       // Handle admin button 2 click (replace with your action)
                        //       print('Admin Button 2 clicked!');
                        //     },
                        //   ),
                        // ),

                        // Padding(
                        //   padding: const EdgeInsets.only(left: 25.0),
                        //   child: ListTile(
                        //     title: const Text('Category Management'),
                        //     leading: const Icon(Icons.admin_panel_settings),
                        //     onTap: () {
                        //       // Handle admin button 2 click (replace with your action)
                        //       print('Admin Button 2 clicked!');
                        //     },
                        //   ),
                        // ),
                      ],
                    );
                  } else {
                    return Container(); // Hide buttons for non-admins
                  }
                },
              ),

              // Home list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text('H O M E'),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MyHome(),
                    //   ),
                    // );
                  },
                ),
              ),

              // Settings list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text('S E T T I N G S'),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
              ),
            ],
          ),

         

          // Logout list tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              title: const Text('L O G O U T'),
              leading: const Icon(Icons.logout),
              onTap: logOut,
            ),
          ),
        ],
      ),
    );
  }
}
