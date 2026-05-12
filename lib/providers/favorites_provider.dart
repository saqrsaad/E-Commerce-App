import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<Product> _favorites = {};

  List<Product> get favorites => _favorites.toList();

  bool isFavorite(Product product) => _favorites.contains(product);

  FavoritesProvider() {
    _loadFavoritesFromPrefs();
  }

  Future<void> _loadFavoritesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('favorites');
    if (jsonString != null) {
      final List<dynamic> list = jsonDecode(jsonString);
      _favorites.addAll(list.map((e) => Product.fromJson(e)));
      notifyListeners();
    }
  }

  Future<void> _saveFavoritesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(_favorites.map((p) => p.toJson()).toList());
    await prefs.setString('favorites', jsonString);
  }

  void toggleFavorite(Product product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    _saveFavoritesToPrefs();
    notifyListeners();
  }
}