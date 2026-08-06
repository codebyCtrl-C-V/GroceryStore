import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository;

  CategoryProvider({CategoryRepository? repository})
      : _repository = repository ?? CategoryRepository();

  bool _isLoading = false;
  String? _errorMessage;

  List<CategoryModel> _categories = [];
  List<ProductModel> _categoryProducts = [];
  int _currentPage = 1;
  int _totalPages = 1;
  String _categoryName = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<CategoryModel> get categories => _categories;
  List<ProductModel> get categoryProducts => _categoryProducts;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  String get categoryName => _categoryName;

  Future<void> fetchAllCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _repository.getAllCategories();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategoryProducts({
    required String slug,
    String sort = 'default',
    int page = 1,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    if (page == 1) {
      _categoryProducts = [];
    }
    notifyListeners();

    try {
      if (slug == 'sale-vegetables') {
        final res = await _repository.getSaleVegetablesFruits(page: page);
        _categoryProducts = res['products'];
        _currentPage = res['currentPage'] ?? 1;
        _totalPages = res['totalPages'] ?? 1;
        _categoryName = 'Rau quả khuyến mãi';
      } else if (slug == 'sale-processed') {
        final res = await _repository.getSaleProcessed(page: page);
        _categoryProducts = res['products'];
        _currentPage = res['currentPage'] ?? 1;
        _totalPages = res['totalPages'] ?? 1;
        _categoryName = 'Thực phẩm chế biến khuyến mãi';
      } else {
        final res = await _repository.getCategoryProducts(slug: slug, sort: sort, page: page);
        final products = res['products'] as List<ProductModel>;
        if (page == 1) {
          _categoryProducts = products;
        } else {
          _categoryProducts.addAll(products);
        }
        _currentPage = res['currentPage'] ?? 1;
        _totalPages = res['totalPages'] ?? 1;
        _categoryName = res['categoryName'] ?? '';
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
