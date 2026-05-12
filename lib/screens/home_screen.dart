import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/error_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // بدء تحميل البيانات عند دخول الشاشة لأول مرة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = context.read<ProductProvider>();
      if (productProvider.state == LoadingState.idle) {
        productProvider.loadProducts().then((_) => productProvider.loadCategories());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المتجر'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {},
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints:
                          const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.state == LoadingState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.state == LoadingState.error) {
            return AppErrorWidget(
              message: provider.errorMessage,
              onRetry: () => provider.loadProducts().then((_) => provider.loadCategories()),
            );
          }
          // نجاح
          return Column(
            children: [
              // شرائط التصنيف
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  itemCount: provider.categories.length,
                  itemBuilder: (context, index) {
                    final category = provider.categories[index];
                    final isSelected = provider.selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: Colors.deepPurple.shade100,
                        onSelected: (_) => provider.setCategory(category),
                      ),
                    );
                  },
                ),
              ),
              // شبكة المنتجات
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: provider.filteredProducts.length,
                  itemBuilder: (context, index) => ProductCard(
                    product: provider.filteredProducts[index],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}