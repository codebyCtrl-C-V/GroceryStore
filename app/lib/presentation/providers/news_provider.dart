import 'package:flutter/material.dart';
import '../../data/models/news_model.dart';
import '../../data/repositories/news_repository.dart';

class NewsProvider extends ChangeNotifier {
  final NewsRepository _repository;

  NewsProvider({NewsRepository? repository})
      : _repository = repository ?? NewsRepository();

  bool _isLoading = false;
  String? _errorMessage;

  List<NewsModel> _newsList = [];
  int _currentPage = 1;
  int _totalPages = 1;
  NewsModel? _newsDetail;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<NewsModel> get newsList => _newsList;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  NewsModel? get newsDetail => _newsDetail;

  Future<void> fetchAllNews({int page = 1}) async {
    _isLoading = true;
    _errorMessage = null;
    if (page == 1) {
      _newsList = [];
    }
    notifyListeners();

    try {
      final res = await _repository.getAllNews(page: page);
      final news = res['news'] as List<NewsModel>;
      if (page == 1) {
        _newsList = news;
      } else {
        _newsList.addAll(news);
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

  Future<void> fetchNewsDetail(String slug) async {
    _isLoading = true;
    _errorMessage = null;
    _newsDetail = null;
    notifyListeners();

    try {
      _newsDetail = await _repository.getNewsDetail(slug);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
