class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating? rating; // قد يكون موجوداً في بعض الإصدارات

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: json['rating'] != null ? Rating.fromJson(json['rating']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
        'rating': rating?.toJson(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Product && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Rating {
  final double rate;
  final int count;

  const Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rate: (json['rate'] as num).toDouble(),
        count: json['count'],
      );

  Map<String, dynamic> toJson() => {'rate': rate, 'count': count};
}