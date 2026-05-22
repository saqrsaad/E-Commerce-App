import 'package:e_commerce_app/screens/auth_screen.dart';
import 'package:e_commerce_app/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('المفضلة')),
      body: Column(
        children: [
          AppHeader(
            searchController: TextEditingController(), // غير مستخدم لكن ضروري
            onSearchChanged: (_) {},
          ),
          Expanded(
            child: Consumer<FavoritesProvider>(
              builder: (context, favProvider, _) {
                // تحقق من تسجيل الدخول
                if (!favProvider.isUserLoggedIn) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_outline, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'يجب تسجيل الدخول لعرض المفضلة',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => AuthScreen()),
                            );
                          },
                          child: Text('تسجيل الدخول'),
                        ),
                      ],
                    ),
                  );
                }

                if (favProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (favProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          favProvider.errorMessage!,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => favProvider
                              .toggleFavorite, // لا يمكن إعادة المحاولة بسهولة
                          child: Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                if (favProvider.favorites.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'لا توجد مفضلات بعد',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: favProvider.favorites.length,
                  itemBuilder: (context, index) {
                    final product = favProvider.favorites[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(product.title, maxLines: 1),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red),
                        onPressed: () => favProvider.toggleFavorite(product),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        
        ],
      ),
    );
  }
}
