import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';
import '../screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(product.imageUrl, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.deepPurple)),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<FavoritesProvider>(
                    builder: (context, fav, _) => IconButton(
                      icon: Icon(
                        fav.isFavorite(product)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: fav.isFavorite(product) ? Colors.red : null,
                      ),
                      onPressed: () => fav.toggleFavorite(product),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<CartProvider>().addToCart(product),
                    icon: const Icon(Icons.add_shopping_cart, size: 18),
                    label: const Text('أضف'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}