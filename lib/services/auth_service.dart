import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // تسجيل حساب جديد
  Future<User?> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthError(e);
    }
  }

  // تسجيل الدخول
  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthError(e);
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // بث حالة تسجيل الدخول
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // تحويل أكواد أخطاء Firebase إلى رسائل عربية
  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'هذا البريد مسجل مسبقًا. هل تريد تسجيل الدخول؟';
      case 'invalid-email':
        return 'صيغة البريد غير صحيحة';
      case 'user-not-found':
        return 'لا يوجد حساب بهذا البريد. هل تريد إنشاء حساب جديد؟';
      case 'wrong-password':
        return 'كلمة مرور غير صحيحة';
      case 'weak-password':
        return 'كلمة المرور ضعيفة. اختر كلمة مرور أقوى';
      case 'too-many-requests':
        return 'محاولات كثيرة. انتظر قليلًا';
      case 'network-request-failed':
        return 'تعذر الاتصال. تحقق من الإنترنت';
      default:
        return 'حدث خطأ: ${e.message}';
    }
  }
}