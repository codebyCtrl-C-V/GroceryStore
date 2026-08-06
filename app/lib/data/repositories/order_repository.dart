import '../datasources/order_remote_datasource.dart';
import '../models/order_model.dart';

class OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;

  OrderRepository({OrderRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? OrderRemoteDataSource();

  Future<Map<String, List<OrderModel>>> getOrders({String? token}) {
    return _remoteDataSource.getOrders(token: token);
  }

  Future<bool> submitOrder({
    required String name,
    required String phone,
    required String address,
    required String paymentMethod,
    String? token,
  }) {
    return _remoteDataSource.submitOrder(
      name: name,
      phone: phone,
      address: address,
      paymentMethod: paymentMethod,
      token: token,
    );
  }

  Future<bool> cancelOrder({
    required String orderId,
    String? token,
  }) {
    return _remoteDataSource.cancelOrder(orderId: orderId, token: token);
  }
}
