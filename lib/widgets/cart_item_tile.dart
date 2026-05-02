import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  const CartItemTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final product = cartItem.product;
    // We use listen: false inside callbacks; the tile itself rebuilds via the parent Consumer.
    final cart = Provider.of<CartProvider>(context, listen: false);

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        //child: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
        child: Image.asset(product.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
      ),
      title: Text(product.name),
      subtitle: Text('\$${product.price.toStringAsFixed(2)} each'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quantity controls
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => cart.decrementQuantity(product),
          ),
          Text('${cartItem.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => cart.incrementQuantity(product),
          ),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => cart.removeFromCart(product),
          ),
        ],
      ),
    );
  }
}