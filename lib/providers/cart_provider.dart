import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/cart_item_model.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();
  final int _cartId = 1;

  final List<CartItemModel> _cartItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CartItemModel> get cartItems => _cartItems;
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _cartItems.fold(0, (sum, item) => sum + item.product.price * item.quantity);
  double get tax => subtotal * 0.10;
  double get total => subtotal + tax;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // محاولة جلب السلة من API، وفي حال الفشل نعتمد على السلة المحلية
  Future<void> fetchCart() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cart = await _cartService.fetchCart(_cartId);
    
          _isLoading = false;
    } catch (e) {
      // نستخدم السلة المحلية فقط
      _isLoading = false;
      _errorMessage = null; 
    }
    notifyListeners();
  }

  void addToCart(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItemModel(product: product));
    }
    // محاولة مزامنة مع API (اختياري)
    _syncAddToCart(product);
    notifyListeners();
  }

  Future<void> _syncAddToCart(Product product) async {
    try {
      await _cartService.addToCart(_cartId, product.id as int, 1);
    } catch (_) {
      // تجاهل أخطاء المزامنة، السلة المحلية هي الأساس
    }
  }

  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item.product.id == product.id);
    _syncRemoveFromCart(product);
    notifyListeners();
  }

  Future<void> _syncRemoveFromCart(Product product) async {
    try {
      await _cartService.removeFromCart(_cartId, product.id as int);
    } catch (_) {}
  }

  void incrementQuantity(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }
}