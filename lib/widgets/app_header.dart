import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import 'login_dialog.dart';

class AppHeader extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const AppHeader({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // الصف العلوي: الشعار + أيقونات المستخدم/السلة/المفضلة
              Row(
                children: [
                  const Icon(Icons.store, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'متجري',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // المفضلة
                  Consumer<FavoritesProvider>(
                    builder: (context, fav, _) => Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.white),
                          onPressed: () {},
                        ),
                        if (fav.isUserLoggedIn && fav.favorites.isNotEmpty)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                  minWidth: 18, minHeight: 18),
                              child: Text(
                                '${fav.favorites.length}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // السلة
                  Consumer<CartProvider>(
                    builder: (context, cart, _) => Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart,
                              color: Colors.white),
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
                              constraints: const BoxConstraints(
                                  minWidth: 18, minHeight: 18),
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
                  // المستخدم
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      final user = auth.user;
                      return user != null
                          ? PopupMenuButton<String>(
                              icon: const Icon(Icons.person,
                                  color: Colors.white),
                              onSelected: (value) async {
                                if (value == 'logout') {
                                  await auth.signOut();
                                }
                              },
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                  value: 'email',
                                  enabled: false,
                                  child: Text(user.email ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                const PopupMenuDivider(),
                                const PopupMenuItem(
                                  value: 'logout',
                                  child: Row(
                                    children: [
                                      Icon(Icons.logout, size: 18),
                                      SizedBox(width: 8),
                                      Text('تسجيل الخروج'),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : IconButton(
                              icon: const Icon(Icons.person_outline,
                                  color: Colors.white),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => const LoginDialog(),
                                );
                              },
                            );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // شريط البحث
              TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'ابحث عن منتج...',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}