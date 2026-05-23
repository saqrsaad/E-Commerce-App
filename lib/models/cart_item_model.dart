import 'package:e_commerce_app/models/cart_item_local.dart';

import 'product.dart';

// عنصر السلة المحلي (مدمج مع Product كامل)
class CartItemModel {
  final Product product;
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});

  
  CartItemLocal toLocal() {
    return CartItemLocal(
      id: null, // سيتم توليده تلقائياً في القاعدة
      productId: product.id,
      title: product.title,
      price: product.price,
      image: product.imageUrl,
      quantity: quantity,
    );
  }
}