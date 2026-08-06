import '../datasources/cart_remote_datasource.dart';
import '../models/cart_model.dart';

class CartRepository {
  final CartRemoteDataSource _remoteDataSource;

  CartRepository({CartRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? CartRemoteDataSource();

  Future<List<CartItemModel>> getCart({String? token}) {
    return _remoteDataSource.getCart(token: token);
  }

  Future<CartItemModel> addToCart({
    required String productId,
    required int quantity,
    String? token,
  }) {
    return _remoteDataSource.addToCart(productId: productId, quantity: quantity, token: token);
  }

  Future<bool> updateCartItem({
    required String cartItemId,
    required int quantity,
    String? token,
  }) {
    return _remoteDataSource.updateCartItem(cartItemId: cartItemId, quantity: quantity, token: token);
  }

  Future<bool> deleteCartItem({
    required String cartItemId,
    String? token,
  }) {
    return _remoteDataSource.deleteCartItem(cartItemId: cartItemId, token: token);
  }
}
