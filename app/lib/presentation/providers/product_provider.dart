import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository;

  ProductProvider({ProductRepository? repository})
      : _repository = repository ?? ProductRepository();

  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> _vegetables = [];
  List<ProductModel> _fruits = [];
  List<ProductModel> _juices = [];
  List<ProductModel> _processed = [];
  List<ProductModel> _newProducts = [];
  
  List<ProductModel> _searchResults = [];
  int _currentPage = 1;
  int _totalPages = 1;

  ProductModel? _productDetail;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<ProductModel> get vegetables => _vegetables;
  List<ProductModel> get fruits => _fruits;
  List<ProductModel> get juices => _juices;
  List<ProductModel> get processed => _processed;
  List<ProductModel> get newProducts => _newProducts;

  List<ProductModel> get searchResults => _searchResults;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  ProductModel? get productDetail => _productDetail;

  Future<void> fetchProductsForHome() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _repository.getProductsForHome();
      _vegetables = data['vegetables'] ?? [];
      _fruits = data['fruits'] ?? [];
      _juices = data['juices'] ?? [];
      _processed = data['processed'] ?? [];
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNewProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _newProducts = await _repository.getNewProducts();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductDetail(String slug) async {
    _isLoading = true;
    _errorMessage = null;
    _productDetail = null;
    notifyListeners();

    try {
      _productDetail = await _repository.getProductDetail(slug);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProducts({required String query, String sort = 'default', int page = 1}) async {
    _isLoading = true;
    _errorMessage = null;
    if (page == 1) {
      _searchResults = [];
    }
    notifyListeners();

    try {
      final res = await _repository.searchProducts(query: query, sort: sort, page: page);
      final products = res['products'] as List<ProductModel>;
      if (page == 1) {
        _searchResults = products;
      } else {
        _searchResults.addAll(products);
      }
      _currentPage = res['currentPage'] ?? 1;
      _totalPages = res['totalPages'] ?? 1;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
