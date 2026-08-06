import 'package:flutter/material.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepository _repository;

  OrderProvider({OrderRepository? repository})
      : _repository = repository ?? OrderRepository();

  bool _isLoading = false;
  String? _errorMessage;

  List<OrderModel> _pendingOrders = [];
  List<OrderModel> _processingOrders = [];
  List<OrderModel> _completedOrders = [];
  List<OrderModel> _cancelledOrders = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<OrderModel> get pendingOrders => _pendingOrders;
  List<OrderModel> get processingOrders => _processingOrders;
  List<OrderModel> get completedOrders => _completedOrders;
  List<OrderModel> get cancelledOrders => _cancelledOrders;

  Future<void> fetchOrders({String? token}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _repository.getOrders(token: token);
      _pendingOrders = res['pending'] ?? [];
      _processingOrders = res['processing'] ?? [];
      _completedOrders = res['completed'] ?? [];
      _cancelledOrders = res['cancelled'] ?? [];
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitOrder({
    required String name,
    required String phone,
    required String address,
    required String paymentMethod,
    String? token,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.submitOrder(
        name: name,
        phone: phone,
        address: address,
        paymentMethod: paymentMethod,
        token: token,
      );
      if (success) {
        await fetchOrders(token: token);
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelOrder({
    required String orderId,
    String? token,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.cancelOrder(orderId: orderId, token: token);
      if (success) {
        await fetchOrders(token: token);
      }
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
