import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class SeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== 1. بذور المنتجات ==========
  Future<void> seedProducts() async {
    // التحقق إذا كانت المنتجات موجودة مسبقًا (لتفادي التكرار)
    final snapshot = await _firestore.collection('products').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      print('المنتجات موجودة مسبقًا، تم تخطي البذور.');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://fakestoreapi.com/products'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('فشل جلب المنتجات من FakeStore API');
      }

      final List<dynamic> productsJson = jsonDecode(response.body);

      // تحويل كل منتج JSON إلى كائن Product ثم إلى خريطة Firestore
      for (final jsonObj in productsJson) {
        final product = Product.fromJson(jsonObj);

        // إنشاء كلمات البحث من العنوان (تقسيمه إلى كلمات صغيرة)
        final searchKeywords = product.title
            .toLowerCase()
            .split(RegExp(r'\s+'))
            .where((word) => word.length > 2)
            .toList();

        // إنشاء وثيقة جديدة في Firestore مع id تلقائي (أو استخدم product.id)
        await _firestore.collection('products').add({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'category': product.category,
          'imageUrl': product.imageUrl,
          'rating': product.rating,
          'ratingCount': product.ratingCount,
          'stock': 10, // قيمة افتراضية
          'isFeatured': false,
          'searchKeywords': searchKeywords,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      print('تمت إضافة ${productsJson.length} منتجًا إلى Firestore.');
    } catch (e) {
      print('خطأ أثناء بذر المنتجات: $e');
      // لا نوقف التطبيق على هذا الخطأ
    }
  }

  // ========== 2. بذور محتوى الموقع ==========
  Future<void> seedSiteContent() async {
    // التحقق من الوجود
    final snapshot = await _firestore.collection('siteContent').limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      print('محتوى الموقع موجود مسبقًا.');
      return;
    }

    final Map<String, Map<String, String>> content = {
      'about': {
        'title': 'من نحن',
        'body': 'متجرنا تأسس عام 2026، نقدم منتجات عالية الجودة بأفضل الأسعار.'
      },
      'privacy': {
        'title': 'سياسة الخصوصية',
        'body': 'نحن نحمي بياناتك. نجمع فقط البريد الإلكتروني والاسم. لا نشاركها مع طرف ثالث.'
      },
      'terms': {
        'title': 'الشروط والأحكام',
        'body': 'باستخدامك للموقع توافق على الشروط. الأسعار قابلة للتغيير.'
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
      await _firestore.collection('siteContent').doc(entry.key).set(entry.value);
    }

    print('تمت إضافة محتوى الموقع الافتراضي.');
  }

  // ========== تشغيل جميع البذور ==========
  Future<void> runAllSeeds() async {
    await seedProducts();
    await seedSiteContent();
  }
}