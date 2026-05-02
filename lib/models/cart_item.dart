import 'product.dart';

// A cart entry containing a product and its quantity.
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}