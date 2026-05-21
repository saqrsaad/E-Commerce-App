import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  static final FirebaseFirestore instance = FirebaseFirestore.instance;

  // ========== المنتجات ==========
  Stream<List<Product>> getProductsStream({String? category}) {
    Query query = instance.collection('products');
    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromFirestore(doc))
              .toList(),
        );
  }

  Future<List<Product>> searchProducts(String query) async {
    final words = query.trim().toLowerCase().split(RegExp(r'\s+'));
    if (words.isEmpty) return [];

    // نبحث عن أول كلمة تطابق
    final snapshot = await instance
        .collection('products')
        .where('searchKeywords', arrayContains: words.first)
        .get();

    final products = snapshot.docs
        .map((doc) => Product.fromFirestore(doc))
        .toList();

    // ترشيح إضافي حسب باقي الكلمات (لتحسين الدقة)
    if (words.length > 1) {
      products.retainWhere((product) {
        final titleWords = product.title.toLowerCase().split(RegExp(r'\s+'));
        return words.every((word) => titleWords.any((tw) => tw.contains(word)));
      });
    }

    return products;
  }

  Future<List<String>> getCategories() async {
    final snapshot = await instance.collection('products').get();
    final categories = snapshot.docs
        .map((doc) => Product.fromFirestore(doc).category)
        .toSet()
        .toList();
    return categories;
  }
}