import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../models/cart_model.dart';
import 'user_remote_datasource.dart';

class CartRemoteDataSource {
  Map<String, String> _headers([String? token]) {
    final activeToken = token ?? UserRemoteDataSource.accessToken;
    return {
      'Content-Type': 'application/json',
      if (activeToken != null) 'Authorization': 'Bearer $activeToken',
    };
  }

  Future<List<CartItemModel>> getCart({String? token}) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.cart}'),
      headers: _headers(token),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      final data = responseBody['data'] as Map<String, dynamic>;
      final list = data['cartItems'] as List? ?? [];
      return list.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception(responseBody['message'] ?? 'Lấy giỏ hàng thất bại.');
    }
  }

  Future<CartItemModel> addToCart({
    required String productId,
    required int quantity,
    String? token,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.cartAdd}'),
      headers: _headers(token),
      body: jsonEncode({
        'productId': int.parse(productId),
        'quantity': quantity,
      }),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // The backend returns { message: "Thêm vào giỏ hàng...", cartItem: {...} }
      return CartItemModel.fromJson(responseBody['cartItem'] as Map<String, dynamic>);
    } else {
      throw Exception(responseBody['message'] ?? 'Thêm vào giỏ hàng thất bại.');
    }
  }

  Future<bool> updateCartItem({
    required String cartItemId,
    required int quantity,
    String? token,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.cartUpdate(cartItemId)}'),
      headers: _headers(token),
      body: jsonEncode({
        'id': int.parse(cartItemId),
        'quantity': quantity,
      }),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(responseBody['message'] ?? 'Cập nhật số lượng thất bại.');
    }
  }

  Future<bool> deleteCartItem({
    required String cartItemId,
    String? token,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.cartDelete(cartItemId)}'),
      headers: _headers(token),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      return true;
    } else {
      throw Exception(responseBody['message'] ?? 'Xóa sản phẩm khỏi giỏ hàng thất bại.');
    }
  }
}
