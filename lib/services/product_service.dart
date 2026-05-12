import '../models/product.dart';
import 'base_api_service.dart';

class ProductService extends BaseApiService {
  ProductService()
      : super(baseUrl: 'https://fakestoreapi.com');

  Future<List<Product>> fetchProducts() async {
    final data = await get('/products');
    return (data as List).map((json) => Product.fromJson(json)).toList();
  }

  Future<List<String>> fetchCategories() async {
    final data = await get('/products/categories');
    return List<String>.from(data);
  }
}