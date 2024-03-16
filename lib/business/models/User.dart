import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:nirvana/business/models/businessController.dart';

class User{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser =FirebaseAuth.instance.currentUser!;
  final bscontrol = Get.put(BusinessController());

  String email=  '';

  
 
  List<dynamic> references = [];
  late Object userData;


  // functions
  


  // }


Future<void> queryDocumentByUID() async {
  try {
    // Get a reference to the  user collection
    CollectionReference UsersRef =
        FirebaseFirestore.instance.collection('Users');

    // Query documents where the UID field matches the provided UID
    QuerySnapshot querySnapshot = await UsersRef.where('uid', isEqualTo: currentUser.uid).get();

    // Loop through the documents found
    querySnapshot.docs.forEach((doc) {
      // Access document data
       bscontrol.docId = doc['uid'];
       email= doc['email'];
        references =  doc['businessReference'];
        // references = doc['businessReference'];
        print(references);
          references.forEach((item) {
    // Extract the document ID from each reference
    bscontrol.businessId.add(item.id);
     
    
    // Print or process the document ID as needed
    print("successful");
  });

     
    });
    
  } catch (e) {
    print('Error querying document by UID: $e');
  }
}

}