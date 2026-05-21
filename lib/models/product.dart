import 'package:cloud_firestore/cloud_firestore.dart';
class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating; // قد يكون موجوداً في بعض الإصدارات
 final int ratingCount;
  final int stock;
  final bool isFeatured;
  final List<String> searchKeywords;
  final DateTime? createdAt;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.stock = 0,
    this.isFeatured = false,
    this.searchKeywords = const [],
    this.createdAt,

  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      title: data['title'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: data['ratingCount'] ?? 0,
      stock: data['stock'] ?? 0,
      isFeatured: data['isFeatured'] ?? false,
      searchKeywords: List<String>.from(data['searchKeywords'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
         );
  }
 /// تحويل المنتج إلى خريطة لتخزينها في Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'rating': rating,
      'ratingCount': ratingCount,
      'stock': stock,
      'isFeatured': isFeatured,
      'searchKeywords': searchKeywords,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }


  // ========== JSON القديم (للتوافق) ==========
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['image'] ?? json['imageUrl'] ?? '',
      rating: (json['rating'] is Map)
          ? (json['rating']['rate'] as num?)?.toDouble() ?? 0.0
          : (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['rating'] is Map)
          ? json['rating']['count'] ?? 0
          : json['ratingCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'imageUrl': imageUrl,
 'rating': {'rate': rating, 'count': ratingCount},    
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