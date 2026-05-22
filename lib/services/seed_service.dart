import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class SeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  Future<void> seedProducts() async {
    // Check if products already exist (to avoid duplication)
    final snapshot = await _firestore.collection('products').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      print('Products already exist, skipping seeding.');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
        headers: {'Accept': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch products from FakeStore API');
      }

      final List<dynamic> productsJson = jsonDecode(response.body);
      int addedCount = 0;

      for (final jsonObj in productsJson) {
        try {
          final product = Product.fromJson(jsonObj);

          // Generate search keywords from the title (split into lowercase words)
          final searchKeywords = product.title
              .toLowerCase()
              .split(RegExp(r'\s+'))
              .where((word) => word.length > 2)
              .toList();

          // Create a new Firestore document with an auto-generated id
          // (or use product.id if preferred)
          await _firestore.collection('products').add({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'category': product.category,
            'imageUrl': product.imageUrl,
            'rating': product.rating,
            'ratingCount': product.ratingCount,
            'stock': 10, // Default value
            'isFeatured': false,
            'searchKeywords': searchKeywords,
            'createdAt': FieldValue.serverTimestamp(),
          });

          addedCount++;
        } catch (e) {
          print('⚠️ Failed to add product "${jsonObj['title']}": $e');
        }
      }

      print(
        '✅ Successfully added $addedCount products out of ${productsJson.length}',
      );
    } catch (e) {
      print('Error while seeding products: $e');
    }
  }

  Future<void> seedSiteContent() async {
    final snapshot = await _firestore.collection('siteContent').limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      print('Site content already exists.');
      return;
    }

    final Map<String, Map<String, String>> content = {
      'about': {
        'title': 'من نحن',
        'body':
            'متجرنا تأسس عام 2026، نقدم منتجات عالية الجودة بأفضل الأسعار.'
      },
      'privacy': {
        'title': 'سياسة الخصوصية',
        'body':
            'نحن نحمي بياناتك. نجمع فقط البريد الإلكتروني والاسم. لا نشاركها مع طرف ثالث.'
      },
      'terms': {
        'title': 'الشروط والأحكام',
        'body':
            'باستخدامك للموقع توافق على الشروط. الأسعار قابلة للتغيير.'
      },
      'contact': {
        'title': 'اتصل بنا',
        'body': 'يمكنك التواصل عبر البريد الإلكتروني info@norexstore.com'
      },
      'sellWithUs': {
        'title': 'تسوق معنا',
        'body': 'هل تود بيع منتجاتك؟ تواصل معنا.'
      },
    };

    for (final entry in content.entries) {
      await _firestore
          .collection('siteContent')
          .doc(entry.key)
          .set(entry.value);
    }

    print('Default site content has been added.');
  }

  // ========== Run All Seeds ==========
  Future<void> runAllSeeds() async {
    await seedProducts();
    await seedSiteContent();
  }
}