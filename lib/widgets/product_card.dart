import 'package:e_commerce_app/screens/auth_screen.dart';
import 'package:e_commerce_app/widgets/login_dialog.dart';
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
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Colors.grey.shade100,
                    // aspectRatio: 1,
                    child: Image.network(product.imageUrl, fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.deepPurple),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<FavoritesProvider>(
                    builder: (context, favProvider, _) {
                      final isFav = favProvider.isFavorite(product);
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : null,
                        ),
                        onPressed: () async {
                          // Check if user is logged in
                          if (!favProvider.isUserLoggedIn) {
                            // Show login dialog
                            final loggedIn = await showDialog<bool>(
                              context: context,
                              builder: (_) => const LoginDialog(),
                            );
                            // If user logged in successfully, toggle favorite
                            if (loggedIn == true && context.mounted) {
                              favProvider.toggleFavorite(product);
                            }
                          } else {
                            favProvider.toggleFavorite(product);
                          }
                        },
                      );
                    },
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

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تنبيه'),
        content: Text('يجب تسجيل الدخول لإضافة المنتج إلى المفضلة.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('لاحقًا'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // الانتقال إلى شاشة المصادقة
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => AuthScreen()));
            },
            child: Text('تسجيل الدخول'),
          ),
        ],
      ),
    );
  }
}
