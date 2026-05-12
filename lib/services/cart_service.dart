import '../models/cart_model.dart';
import 'base_api_service.dart';

class CartService extends BaseApiService {
  CartService() : super(baseUrl: 'https://fakestoreapi.com');

  Future<CartModel> fetchCart(int cartId) async {
    final data = await get('/carts/$cartId');
    return CartModel.fromJson(data);
  }

  Future<CartModel> addToCart(int cartId, int productId, int quantity) async {
    // للحصول على السلة الحالية وتعديلها يدويًا
    final currentCart = await fetchCart(cartId);
    final existingItem = currentCart.products.indexWhere(
        (item) => item.productId == productId);

    if (existingItem != -1) {
      currentCart.products[existingItem] = CartItemApi(
          productId: productId,
          quantity: currentCart.products[existingItem].quantity + quantity);
    } else {
      currentCart.products.add(CartItemApi(productId: productId, quantity: quantity));
    }

    // تحديث السلة بالكامل (FakeStore API لا تدعم تعديل جزئي)
    final updatedData = await put('/carts/$cartId', currentCart.toJson());
    return CartModel.fromJson(updatedData);
  }

  Future<CartModel> removeFromCart(int cartId, int productId) async {
    final currentCart = await fetchCart(cartId);
    currentCart.products.removeWhere((item) => item.productId == productId);
    final updatedData = await put('/carts/$cartId', currentCart.toJson());
    return CartModel.fromJson(updatedData);
  }
}