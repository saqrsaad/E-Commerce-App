import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item_model.dart';
import '../providers/cart_provider.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel cartItem;
  const CartItemTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(product.image, width: 60, height: 60, fit: BoxFit.cover),
      ),
      title: Text(product.title, maxLines: 1),
      subtitle: Text('\$${product.price.toStringAsFixed(2)} لكل وحدة'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => context.read<CartProvider>().decrementQuantity(product),
          ),
          Text('${cartItem.quantity}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.read<CartProvider>().incrementQuantity(product),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => context.read<CartProvider>().removeFromCart(product),
          ),
        ],
      ),
    );
  }
}