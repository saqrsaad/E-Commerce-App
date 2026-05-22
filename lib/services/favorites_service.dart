import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // جلب قائمة المفضلة كـ Stream
  Stream<List<Product>> getFavoritesStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              // تخزين معلومات المنتج داخل كل مستند مفضلة (كما هو مطلوب)
              final data = doc.data();
              return Product(
                id: data['productId'] ?? doc.id,
                title: data['title'] ?? '',
                price: (data['price'] as num?)?.toDouble() ?? 0.0,
                description: data['description'] ?? '',
                category: data['category'] ?? '',
                imageUrl: data['imageUrl'] ?? '',
                rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
                ratingCount: data['ratingCount'] ?? 0,
              );
            }).toList());
  }

  // إضافة منتج إلى المفضلة
  Future<void> addToFavorites(String userId, Product product) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(product.id)
        .set({
      'productId': product.id,
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'category': product.category,
      'imageUrl': product.imageUrl,
      'rating': product.rating,
      'ratingCount': product.ratingCount,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  // حذف منتج من المفضلة
  Future<void> removeFromFavorites(String userId, String productId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(productId)
        .delete();
  }
}