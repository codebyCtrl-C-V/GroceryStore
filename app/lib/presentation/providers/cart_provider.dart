import 'package:flutter/material.dart';
import '../../data/models/cart_model.dart';
import '../../data/repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repository;

  CartProvider({CartRepository? repository})
      : _repository = repository ?? CartRepository();

  List<CartItemModel> _cartItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CartItemModel> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => _cartItems.fold(0.0, (sum, item) => sum + (item.finalPrice * item.quantity));

  Future<void> fetchCart({String? token}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cartItems = await _repository.getCart(token: token);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart({
    required String productId,
    required int quantity,
    String? token,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.addToCart(productId: productId, quantity: quantity, token: token);
      // Reload cart to get synchronized state
      _cartItems = await _repository.getCart(token: token);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateCartItemQuantity({
    required String cartItemId,
    required int quantity,
    String? token,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (quantity <= 0) {
        await _repository.deleteCartItem(cartItemId: cartItemId, token: token);
      } else {
        await _repository.updateCartItem(cartItemId: cartItemId, quantity: quantity, token: token);
      }
      _cartItems = await _repository.getCart(token: token);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCartItem({
    required String cartItemId,
    String? token,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteCartItem(cartItemId: cartItemId, token: token);
      _cartItems = await _repository.getCart(token: token);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearLocalCart() {
    _cartItems = [];
    notifyListeners();
  }
}
