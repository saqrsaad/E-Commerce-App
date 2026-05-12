import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class LocalStorage {
  static const _productsKey = 'cached_products';

  static Future<void> cacheProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(products.map((p) => p.toJson()).toList());
    await prefs.setString(_productsKey, jsonString);
  }

  static Future<List<Product>?> getCachedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_productsKey);
    if (jsonString == null) return null;
    final List<dynamic> list = jsonDecode(jsonString);
    return list.map((e) => Product.fromJson(e)).toList();
  }
}