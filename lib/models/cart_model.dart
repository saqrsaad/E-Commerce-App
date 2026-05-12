//import 'cart_item_api.dart';

// تمثيل السلة كما تُرجعها API (FakeStore)
class CartModel {
  final int id;
  final int userId;
  final DateTime date;
  final List<CartItemApi> products; // العناصر تحتوي على productId و quantity

  CartModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      products: (json['products'] as List)
          .map((e) => CartItemApi.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'date': date.toIso8601String(),
        'products': products.map((e) => e.toJson()).toList(),
      };
}

class CartItemApi {
  final int productId;
  final int quantity;

  CartItemApi({required this.productId, required this.quantity});

  factory CartItemApi.fromJson(Map<String, dynamic> json) =>
      CartItemApi(productId: json['productId'], quantity: json['quantity']);

  Map<String, dynamic> toJson() => {'productId': productId, 'quantity': quantity};
}