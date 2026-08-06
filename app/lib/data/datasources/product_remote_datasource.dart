import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  Future<Map<String, List<ProductModel>>> getProductsForHome() async {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.productsForHome}'),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      final data = responseBody['data'] as Map<String, dynamic>;
      final result = <String, List<ProductModel>>{};

      data.forEach((key, value) {
        final list = value as List? ?? [];
        result[key] = list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
      });

      return result;
    } else {
      throw Exception(responseBody['message'] ?? 'Lấy danh sách sản phẩm trang chủ thất bại.');
    }
  }

  Future<List<ProductModel>> getNewProducts() async {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.newProducts}'),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      final list = responseBody['data'] as List? ?? [];
      return list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception(responseBody['message'] ?? 'Lấy danh sách sản phẩm mới thất bại.');
    }
  }

  Future<ProductModel> getProductDetail(String slug) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.productDetail(slug)}'),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      return ProductModel.fromJson(responseBody['data'] as Map<String, dynamic>);
    } else {
      throw Exception(responseBody['message'] ?? 'Không tìm thấy thông tin chi tiết sản phẩm.');
    }
  }

  Future<Map<String, dynamic>> searchProducts({
    required String query,
    String sort = 'default',
    int page = 1,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.searchProducts}?q=$query&sort=$sort&page=$page'),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      final data = responseBody['data'] as Map<String, dynamic>;
      final list = data['products'] as List? ?? [];
      final products = list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
      return {
        'products': products,
        'currentPage': data['currentPage'] ?? 1,
        'totalPages': data['totalPages'] ?? 1,
      };
    } else {
      throw Exception(responseBody['message'] ?? 'Tìm kiếm sản phẩm thất bại.');
    }
  }
}
