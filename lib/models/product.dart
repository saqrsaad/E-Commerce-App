// A simple, immutable product model.
class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String category; // Electronics, Fashion, Sports, Perfumes, etc.

  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
  });

  // We override == and hashCode so that Set<Product> can compare by id.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Product && id == other.id;

  @override
  int get hashCode => id.hashCode;
}