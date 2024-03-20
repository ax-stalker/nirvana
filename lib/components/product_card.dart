import 'package:flutter/material.dart';
import 'package:nirvana/services/display/display_products_service.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2, // Half the screen width
      child: Card(
        child: Column(
          children: [
            Image.network(product.imageUrl), // Display the image
            Text(product.name, style: const TextStyle(fontSize: 16.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'KSH: ${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // Add any additional buttons or actions here (optional)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
