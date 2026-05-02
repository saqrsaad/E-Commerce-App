import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              //child: Image.network(product.imageUrl, height: 100, fit: BoxFit.cover),
             child: Image.asset(product.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            // Name and price
            Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('\$${product.price.toStringAsFixed(2)})', style: const TextStyle(color: Colors.deepPurple)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Wrapping only the heart icon with Consumer<FavoritesProvider>
                Consumer<FavoritesProvider>(
                  builder: (context, favProvider, _) => IconButton(
                    icon: Icon(
                      favProvider.isFavorite(product) ? Icons.favorite : Icons.favorite_border,
                      color: favProvider.isFavorite(product) ? Colors.red : null,
                    ),
                    onPressed: () => favProvider.toggleFavorite(product),
                  ),
                ),
                // Add to cart button – uses listen: false to avoid rebuilding
                ElevatedButton.icon(
                  onPressed: () => Provider.of<CartProvider>(context, listen: false).addToCart(product),
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.white, backgroundColor: Colors.deepPurple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}