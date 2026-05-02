import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  // Hardcoded fake products with placeholder images.
  final List<Product> _allProducts = [
    const Product(id: '1', name: 'Wireless Headphones', imageUrl: 'assets/images/headphones.png', price: 79.99, category: 'Electronics'),
    const Product(id: '2', name: 'Smart Watch', imageUrl: 'assets/images/computer.png', price: 199.99, category: 'Electronics'),
    const Product(id: '3', name: 'Leather Jacket', imageUrl: 'assets/images/leather_jacket.png', price: 149.99, category: 'Fashion'),
    const Product(id: '4', name: 'Running Shoes', imageUrl: 'assets/images/running_shoes.png', price: 89.99, category: 'Fashion'),
    const Product(id: '5', name: 'Basketball', imageUrl: 'assets/images/basketball.png', price: 29.99, category: 'Sports'),
    const Product(id: '6', name: 'Yoga Mat', imageUrl: 'assets/images/yoga_mat.png', price: 39.99, category: 'Sports'),
    const Product(id: '7', name: 'Eau de Parfum', imageUrl: 'assets/images/parfum.png', price: 59.99, category: 'Perfumes'),
    const Product(id: '8', name: 'Scented Candle Set', imageUrl: 'assets/images/candle_set.png', price: 34.99, category: 'Perfumes'),
  ];

  String _selectedCategory = 'All';

  // Returns the filtered list based on the active category.
  List<Product> get filteredProducts {
    if (_selectedCategory == 'All') return _allProducts;
    return _allProducts.where((p) => p.category == _selectedCategory).toList();
  }

  String get selectedCategory => _selectedCategory;

  // Categories for the filter chips.
  final List<String> categories = ['All', 'Electronics', 'Fashion', 'Sports', 'Perfumes'];

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}