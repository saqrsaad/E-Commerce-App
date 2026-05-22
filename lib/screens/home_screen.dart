import 'dart:async';

import 'package:e_commerce_app/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/error_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // بدء تحميل البيانات عند دخول الشاشة لأول مرة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = context.read<ProductProvider>();
      if (productProvider.state == LoadingState.idle) {
        productProvider.loadProducts();
        //.then((_) => productProvider.loadCategories());
      }
    });
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<ProductProvider>().setSearchQuery(value);
    });
  }

@override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
           AppHeader(
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
          ),
         
          Consumer<ProductProvider>(
            builder: (context, provider, _) {
              return SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: provider.categories.length,
                  itemBuilder: (context, index) {
                    final cat = provider.categories[index];
                    final isSelected = provider.selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: Colors.deepPurple.shade100,
                        onSelected: (_) => provider.setCategory(cat),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                if (provider.state == LoadingState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.state == LoadingState.error) {
                  return AppErrorWidget(
                    message: provider.errorMessage,
                    onRetry: () => provider.retry(),
                  );
                }
                final products = provider.filteredProducts;
                if (products.isEmpty) {
                  return const Center(
                    child: Text('لم يتم العثور على منتجات',
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) =>
                      ProductCard(product: products[index]),
                );
              },
            ),
          ),
          
        ],
      ),
    );
  }
}