import 'dart:async';
import 'package:e_commerce_app/services/favorites_service.dart';
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import 'auth_provider.dart';  

class FavoritesProvider extends ChangeNotifier {
  final FavoritesService _favoritesService = FavoritesService();
  final AuthProvider _authProvider;

  List<Product> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isUserLoggedIn => _authProvider.user != null;

  FavoritesProvider(this._authProvider) {

    _authProvider.addListener(_onAuthChanged);

    if (_authProvider.user != null) {
      _listenToFavorites();
    }
  }

  void _onAuthChanged() {
    if (_authProvider.user != null) {
      _listenToFavorites();
    } else {
      // عند تسجيل الخروج، امسح القائمة المحلية
      _favorites = [];
      notifyListeners();
    }
  }

  StreamSubscription<List<Product>>? _favSub;

  void _listenToFavorites() {
    final userId = _authProvider.user!.uid;
    _favSub?.cancel();
    _isLoading = true;
    notifyListeners();
    _favSub = _favoritesService.getFavoritesStream(userId).listen(
      (products) {
        _favorites = products;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _errorMessage = _translateError(error);
        notifyListeners();
      },
    );
  }

  bool isFavorite(Product product) {
    return _favorites.any((p) => p.id == product.id);
  }

  Future<void> toggleFavorite(Product product) async {
    if (_authProvider.user == null) {
      return;
    }

    final userId = _authProvider.user!.uid;
    try {
      if (isFavorite(product)) {
        await _favoritesService.removeFromFavorites(userId, product.id);
      } else {
        await _favoritesService.addToFavorites(userId, product);
      }
    } catch (e) {
      _errorMessage = _translateError(e);
      notifyListeners();
    }
  }

  String _translateError(dynamic e) {
    if (e.toString().contains('permission-denied')) return 'ليس لديك صلاحية';
    return 'حدث خطأ في المفضلة';
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    _favSub?.cancel();
    super.dispose();
  }
}