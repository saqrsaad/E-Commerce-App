import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../helpers/local_storage.dart';

enum LoadingState { idle, loading, error, success }

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _allProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  LoadingState _state = LoadingState.idle;
  String _errorMessage = '';

  List<Product> get allProducts => _allProducts;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  LoadingState get state => _state;
  String get errorMessage => _errorMessage;

  // المنتجات بعد التصفية
  List<Product> get filteredProducts {
    if (_selectedCategory == 'All') return _allProducts;
    return _allProducts.where((p) => p.category == _selectedCategory).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // تحميل المنتجات مع دعم العمل دون اتصال
  Future<void> loadProducts() async {
    _state = LoadingState.loading;
    notifyListeners();

    try {
      // محاولة تحميل البيانات من الإنترنت
      final products = await _productService.fetchProducts();
      _allProducts = products;
      // حفظ نسخة محلية للعمل offline
      await LocalStorage.cacheProducts(products);
      _state = LoadingState.success;
    } catch (e) {
      // في حالة الفشل (لا يوجد إنترنت) نعتمد على النسخة المخزنة
      final cached = await LocalStorage.getCachedProducts();
      if (cached != null && cached.isNotEmpty) {
        _allProducts = cached;
        _state = LoadingState.success;
      } else {
        _state = LoadingState.error;
        _errorMessage = _translateError(e);
      }
    }
    notifyListeners();
  }

  // تحميل الأقسام (دائماً نحتاج الإنترنت لها، لكن نسمح بالفشل)
  Future<void> loadCategories() async {
    try {
      _categories = await _productService.fetchCategories();
    } catch (_) {
      // إذا فشل جلب الأقسام، نستخرجها من المنتجات المحملة
      _categories = ['All', ...allProducts.map((p) => p.category).toSet()];
    }
    notifyListeners();
  }

  // تحويل الخطأ إلى رسالة عربية
  String _translateError(dynamic e) {
    if (e.toString().contains('لا يوجد اتصال')) return 'لا يوجد اتصال بالإنترنت';
    if (e.toString().contains('انتهت مهلة')) return 'انتهت مهلة الاتصال';
    return 'حدث خطأ أثناء تحميل البيانات';
  }
}