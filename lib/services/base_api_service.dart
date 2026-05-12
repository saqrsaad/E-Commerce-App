import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_exception.dart';

class BaseApiService {
  final String baseUrl;
  final Duration timeout;
  final Map<String, String> defaultHeaders;

  BaseApiService({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 10),
    Map<String, String>? headers,
  }) : defaultHeaders = headers ?? {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        };

  // إضافة التوكن إذا وُجد (يُمرر من الخدمات الفرعية)
  Map<String, String> _getHeaders({String? token}) {
    if (token != null) {
      return {...defaultHeaders, 'Authorization': 'Bearer $token'};
    }
    return defaultHeaders;
  }

  // دالة عامة لإجراء الطلب والمعالجة
  Future<dynamic> _handleRequest(Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(timeout);
      return _processResponse(response);
    } on SocketException {
      throw ApiException(message: 'لا يوجد اتصال بالإنترنت');
    } on TimeoutException {
      throw ApiException(message: 'انتهت مهلة الاتصال');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'حدث خطأ غير متوقع: $e');
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      // ترجمة الأخطاء الشائعة إلى العربية
      String errorMsg;
      switch (response.statusCode) {
        case 400:
          errorMsg = 'طلب غير صالح';
          break;
        case 401:
          errorMsg = 'غير مصرح، يرجى تسجيل الدخول';
          break;
        case 403:
          errorMsg = 'محظور، لا تملك صلاحية';
          break;
        case 404:
          errorMsg = 'البيانات غير موجودة';
          break;
        case 500:
          errorMsg = 'خطأ في الخادم';
          break;
        default:
          errorMsg = 'خطأ ${response.statusCode}';
      }
      throw ApiException(statusCode: response.statusCode, message: errorMsg);
    }
  }

  Future<dynamic> get(String endpoint, {String? token}) async {
    return _handleRequest(() => http.get(
          Uri.parse('$baseUrl$endpoint'),
          headers: _getHeaders(token: token),
        ));
  }

  Future<dynamic> post(String endpoint, dynamic body, {String? token}) async {
    return _handleRequest(() => http.post(
          Uri.parse('$baseUrl$endpoint'),
          headers: _getHeaders(token: token),
          body: jsonEncode(body),
        ));
  }

  Future<dynamic> put(String endpoint, dynamic body, {String? token}) async {
    return _handleRequest(() => http.put(
          Uri.parse('$baseUrl$endpoint'),
          headers: _getHeaders(token: token),
          body: jsonEncode(body),
        ));
  }

  Future<dynamic> delete(String endpoint, {String? token}) async {
    return _handleRequest(() => http.delete(
          Uri.parse('$baseUrl$endpoint'),
          headers: _getHeaders(token: token),
        ));
  }
}