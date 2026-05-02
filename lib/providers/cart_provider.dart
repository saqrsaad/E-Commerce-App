import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  // Total number of items (sum of quantities).
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  // Computed financial properties.
  double get subtotal => _cartItems.fold(0, (sum, item) => sum + item.product.price * item.quantity);
  double get tax => subtotal * 0.10;
  double get total => subtotal + tax;

  void addToCart(Product product) {
    final index = _cartItems.indexWhere((item) => item.product == product);
    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item.product == product);
    notifyListeners();
  }

  void incrementQuantity(Product product) {
    final index = _cartItems.indexWhere((item) => item.product == product);
    if (index >= 0) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(Product product) {
    final index = _cartItems.indexWhere((item) => item.product == product);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index); // quantity becomes 0 -> remove
      }
      notifyListeners();
    }
  }
}