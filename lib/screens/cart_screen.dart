import 'package:e_commerce_app/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('السلة')),
      body: Column(
        children: [
          AppHeader(
            searchController: TextEditingController(), // غير مستخدم لكن ضروري
            onSearchChanged: (_) {},
          ),
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, cart, _) {
                if (cart.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
          if (cart.cartItems.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('السلة فارغة', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.cartItems.length,
                  itemBuilder: (context, index) =>
                      CartItemTile(cartItem: cart.cartItems[index]),
                ),
              ),

              Selector<CartProvider, double>(
                selector: (_, provider) => provider.total,
                builder: (context, total, child) {
                  final cartProvider = context.read<CartProvider>();
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('المجموع الفرعي: \$${cartProvider.subtotal.toStringAsFixed(2)}'),
                        Text('الضريبة (10%): \$${cartProvider.tax.toStringAsFixed(2)}'),
                        const Divider(),
                        Text('الإجمالي: \$${total.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم تقديم الطلب! (محاكاة)')),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('إتمام الشراء'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    
    
      ),
      
        ],
      ),
    );
  }
}