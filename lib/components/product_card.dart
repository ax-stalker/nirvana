// Product model
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  final String name;
  final String imageUrl;
  final double price;

  const Product({required this.name, required this.imageUrl, required this.price});
}

// Widget for individual product card
Widget buildProductCard(Product product) {
  return Card(
    child: InkWell(
      onTap: () {
        // Navigate to product details or other action
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 8.0),
            Text(product.name, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            Text(
              "\$${product.price}",
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    ),
  );
}

// StreamBuilder example (assuming Firebase)

