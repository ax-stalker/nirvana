
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CategoryModel{
  String title;

  CategoryModel( {required this.title, });

  CategoryModel.fromJson(Map<String, Object?> json)
    : this(
        title: json['title']! as String,
        
      );

  // final String title;


//   Map<String, Object?> toJson() {
//     return {
//       'title': title,
    
//     };
//   }
// }

// final CategoryCollection = FirebaseFirestore.instance.collection('categories').withConverter<Category>(
//      fromFirestore: (snapshot, _) => Category.fromJson(snapshot.data()!),
//      toFirestore: (Category, _) => Category.toJson(),
//    
// 
// );

}














