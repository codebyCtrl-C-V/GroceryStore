import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../models/order_model.dart';
import 'user_remote_datasource.dart';

class OrderRemoteDataSource {
  Map<String, String> _headers([String? token]) {
    final activeToken = token ?? UserRemoteDataSource.accessToken;
    return {
      'Content-Type': 'application/json',
      if (activeToken != null) 'Authorization': 'Bearer $activeToken',
    };
  }

  Future<Map<String, List<OrderModel>>> getOrders({String? token}) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.orders}'),
      headers: _headers(token),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      final data = responseBody['data'] as Map<String, dynamic>;
      
      final pendingList = data['pendingOrders'] as List? ?? [];
      final processingList = data['processingOrders'] as List? ?? [];
      final completedList = data['completedOrders'] as List? ?? [];
      final cancelledList = data['cancelledOrders'] as List? ?? [];

      return {
        'pending': pendingList.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList(),
        'processing': processingList.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList(),
        'completed': completedList.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList(),
        'cancelled': cancelledList.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList(),
      };
    } else {
      throw Exception(responseBody['message'] ?? 'Lấy danh sách đơn hàng thất bại.');
    }
  }

  Future<bool> submitOrder({
    required String name,
    required String phone,
    required String address,
    required String paymentMethod,
    String? token,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.checkoutSubmit}'),
      headers: _headers(token),
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'address': address,
        'paymentMethod': paymentMethod,
      }),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      return true;
    } else {
      throw Exception(responseBody['message'] ?? 'Đặt hàng thất bại.');
    }
  }

  Future<bool> cancelOrder({
    required String orderId,
    String? token,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.cancelOrder(orderId)}'),
      headers: _headers(token),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      return true;
    } else {
      throw Exception(responseBody['message'] ?? 'Hủy đơn hàng thất bại.');
    }
  }
}
