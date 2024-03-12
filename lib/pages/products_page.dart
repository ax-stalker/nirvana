import 'package:flutter/material.dart';
import 'package:nirvana/components/appbar.dart';
import 'package:nirvana/components/favorites.dart'; // Likely not needed here (check usage)
import 'package:nirvana/components/my_drawer.dart';
import 'package:nirvana/components/product_card.dart';
import 'package:nirvana/services/display/display_products_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // Add a state variable to store the list of products
  List<Product> products = [];

  // Fetch products on initState
  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    // Replace with actual logic to fetch favorite products
    // (e.g., call an API or access local storage)
    final service = DisplayProductService();
    products =
        await service.getProducts(); // Get all products for demonstration
    setState(() {}); // Update UI after fetching
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const MyAppBar('Favorites'),
      drawer: MyDrawer(),
      body: products.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : GridView.count(
              crossAxisCount: 2, // Two columns
              children: products
                  .map((product) => ProductCard(product: product))
                  .toList(),
            ),
    );
  }
}
