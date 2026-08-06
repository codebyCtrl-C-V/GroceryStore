import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories() async {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.categories}'),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final list = responseBody as List? ?? [];
      return list.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Lấy danh sách danh mục thất bại.');
    }
  }

  Future<Map<String, dynamic>> getCategoryProducts({
    required String slug,
    String sort = 'default',
    int page = 1,
  }) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.categoryProducts(slug)}?sort=$sort&page=$page'),
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
        'categoryName': data['categoryName'] ?? '',
      };
    } else {
      throw Exception(responseBody['message'] ?? 'Lấy sản phẩm theo danh mục thất bại.');
    }
  }

  Future<Map<String, dynamic>> getSaleVegetablesFruits({int page = 1}) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.saleVegetablesFruits}?page=$page'),
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
      throw Exception(responseBody['message'] ?? 'Lấy rau củ quả khuyến mãi thất bại.');
    }
  }

  Future<Map<String, dynamic>> getSaleProcessed({int page = 1}) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.saleProcessed}?page=$page'),
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
      throw Exception(responseBody['message'] ?? 'Lấy thực phẩm chế biến khuyến mãi thất bại.');
    }
  }
}
