import 'dart:async';

import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';
  
enum LoadingState { idle, loading, error, success }

class ProductProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<Product> _allProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  LoadingState _state = LoadingState.idle;
  String _errorMessage = '';

  StreamSubscription<List<Product>>? _productsSub;
  String _searchQuery = '';
  
  List<Product> get allProducts => _allProducts;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  LoadingState get state => _state;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  // // المنتجات بعد التصفية
  // List<Product> get filteredProducts {
  //   if (_selectedCategory == 'All') return _allProducts;
  //   return _allProducts.where((p) => p.category == _selectedCategory).toList();
  // }

// المنتجات المصفاة حسب الفئة والبحث
  List<Product> get filteredProducts {
    List<Product> list = _allProducts;
    if (_selectedCategory != 'All') {
      list = list.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      list = list.where((p) {
        return p.title.toLowerCase().contains(query) ||
            p.searchKeywords.any((kw) => kw.contains(query));
      }).toList();
    }
    return list;
  }
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  // تحميل المنتجات مع دعم العمل دون اتصال

  // Future<void> loadProducts() async {
  //   _state = LoadingState.loading;
  //   notifyListeners();

  //   try {
  //     // محاولة تحميل البيانات من الإنترنت
  //     final products = await _productService.fetchProducts();
  //     _allProducts = products;
  //     // حفظ نسخة محلية للعمل offline
  //     await LocalStorage.cacheProducts(products);
  //     _state = LoadingState.success;
  //   } catch (e) {
  //     // في حالة الفشل (لا يوجد إنترنت) نعتمد على النسخة المخزنة
  //     final cached = await LocalStorage.getCachedProducts();
  //     if (cached != null && cached.isNotEmpty) {
  //       _allProducts = cached;
  //       _state = LoadingState.success;
  //     } else {
  //       _state = LoadingState.error;
  //       _errorMessage = _translateError(e);
  //     }
  //   }
  //   notifyListeners();
  // }

// بدء الاستماع إلى Firestore Stream
  Future<void> loadProducts({String? category}) async {
    _state = LoadingState.loading;
    notifyListeners();

    try {
      await _productsSub?.cancel();
      _productsSub = _firestoreService
          .getProductsStream(category: category)
          .listen(
        (products) {
          _allProducts = products;
          _state = LoadingState.success;
          notifyListeners();
        },
        onError: (error) {
          _state = LoadingState.error;
          _errorMessage = _translateError(error);
          notifyListeners();
        },
      );
      // تحميل الفئات بشكل منفصل
      _loadCategories();
    } catch (e) {
      _state = LoadingState.error;
      _errorMessage = _translateError(e);
      notifyListeners();
    }
  }
  // تحميل الأقسام (دائماً نحتاج الإنترنت لها، لكن نسمح بالفشل)
  // Future<void> loadCategories() async {
  //   try {
  //     _categories = await _productService.fetchCategories();
  //   } catch (_) {
  //     // إذا فشل جلب الأقسام، نستخرجها من المنتجات المحملة
  //     _categories = ['All', ...allProducts.map((p) => p.category).toSet()];
  //   }
  //   notifyListeners();
  // }
  
  Future<void> _loadCategories() async {
    try {
      _categories = await _firestoreService.getCategories();
      if (!_categories.contains('All')) {
        _categories.insert(0, 'All');
      }
      notifyListeners();
    } catch (_) {
      // استخراج الفئات من المنتجات إذا فشل الجلب المنفصل
      _categories = ['All', ..._allProducts.map((p) => p.category).toSet()];
      notifyListeners();
    }
  }
  // إعادة تحميل المنتجات (لزر إعادة المحاولة)
  Future<void> retry() async {
    await loadProducts(category: _selectedCategory != 'All' ? _selectedCategory : null);
  }
  
   // ترجمة الأخطاء
  String _translateError(dynamic e) {
    if (e.toString().contains('لا يوجد اتصال')) return 'لا يوجد اتصال بالإنترنت';
    if (e.toString().contains('انتهت مهلة')) return 'انتهت مهلة الاتصال';
    return 'حدث خطأ أثناء تحميل البيانات';
  }

    @override
  void dispose() {
    _productsSub?.cancel();
    super.dispose();
  }
}