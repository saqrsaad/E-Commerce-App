import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  User? get user => _user;
  Stream<User?> get authStateStream => _authService.authStateChanges;

  AuthProvider() {
    // الاستماع لتغيرات حالة المصادقة وتحديث الـ user المحلي
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // تسجيل الدخول
  Future<String?> signIn(String email, String password) async {
    try {
      await _authService.signIn(email, password);
      return null; // null يعني نجاح
    } catch (e) {
      return e.toString(); // رسالة الخطأ العربية
    }
  }

  // إنشاء حساب
  Future<String?> signUp(String email, String password) async {
    try {
      await _authService.signUp(email, password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await _authService.signOut();
  }
}