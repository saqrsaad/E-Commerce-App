import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/cart_item_model.dart';
import '../services/cart_database_service.dart';

class CartProvider extends ChangeNotifier {
  final CartDatabaseService _cartDb = CartDatabaseService();

  List<CartItemModel> _cartItems = [];
  bool _isLoading = false;  
  String? _errorMessage;

  List<CartItemModel> get cartItems => _cartItems;
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal =>
      _cartItems.fold(0, (sum, item) => sum + item.product.price * item.quantity);
  double get tax => subtotal * 0.10;
  double get total => subtotal + tax;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  CartProvider() {
    _loadCartFromDatabase();
  }

  Future<void> _loadCartFromDatabase() async {
    _isLoading = true;
    notifyListeners();

    try {
      final localItems = await _cartDb.getCartItems();
      _cartItems = localItems.map((local) {

        final product = Product(
          id: local.productId,
          title: local.title,
          price: local.price,
          description: '',
          category: '',
          imageUrl: local.image,
        );
        return CartItemModel(product: product, quantity: local.quantity);
      }).toList();
      _errorMessage = null;
    } catch (e) {

      _cartItems = [];
      _errorMessage = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(Product product) async {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cartItems[index].quantity++;

      final local = _cartItems[index].toLocal();
      await _cartDb.addOrUpdateCartItem(local);
    } else {

      final newItem = CartItemModel(product: product, quantity: 1);
      _cartItems.add(newItem);
      final local = newItem.toLocal();
      await _cartDb.addOrUpdateCartItem(local);
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _removeFromCart(product);
  }

  Future<void> _removeFromCart(Product product) async {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      final local = _cartItems[index].toLocal();
      _cartItems.removeAt(index);
      if (local.id != null) {
        await _cartDb.removeItem(local.id!);
      }
      notifyListeners();
    }
  }

  void incrementQuantity(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cartItems[index].quantity++;
      _updateDbQuantity(_cartItems[index]);
      notifyListeners();
    }
  }

  void decrementQuantity(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
        _updateDbQuantity(_cartItems[index]);
      } else {
        _removeFromCart(product);
        return; 
      }
      notifyListeners();
    }
  }

  Future<void> _updateDbQuantity(CartItemModel item) async {
    final local = item.toLocal();
    if (local.id != null) {
      await _cartDb.updateQuantity(local.id!, item.quantity);
    }
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    await _cartDb.clearCart();
    notifyListeners();
  }
}