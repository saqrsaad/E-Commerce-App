class CartItemLocal {
  final int? id;          
  final String productId; 
  final String title;
  final double price;
  final String image;     
  final int quantity;

  const CartItemLocal({
    this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  factory CartItemLocal.fromMap(Map<String, dynamic> map) {
    return CartItemLocal(
      id: map['id'] as int?,
      productId: map['productId'] as String,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      image: map['image'] as String,
      quantity: map['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }

  CartItemLocal copyWith({
    int? id,
    String? productId,
    String? title,
    double? price,
    String? image,
    int? quantity,
  }) {
    return CartItemLocal(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
    );
  }
}