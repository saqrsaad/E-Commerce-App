import 'product.dart';

// عنصر السلة المحلي (مدمج مع Product كامل)
class CartItemModel {
  final Product product;
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});
}