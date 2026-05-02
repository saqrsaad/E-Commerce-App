import 'package:flutter/foundation.dart';
import '../models/product.dart';

class FavoritesProvider extends ChangeNotifier {
  // Internal set to prevent duplicates.
  final Set<Product> _favorites = {};

  List<Product> get favorites => _favorites.toList();

  void toggleFavorite(Product product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  bool isFavorite(Product product) => _favorites.contains(product);
}