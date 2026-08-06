import '../datasources/news_remote_datasource.dart';
import '../models/news_model.dart';

class NewsRepository {
  final NewsRemoteDataSource _remoteDataSource;

  NewsRepository({NewsRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? NewsRemoteDataSource();

  Future<Map<String, dynamic>> getAllNews({int page = 1}) {
    return _remoteDataSource.getAllNews(page: page);
  }

  Future<NewsModel> getNewsDetail(String slug) {
    return _remoteDataSource.getNewsDetail(slug);
  }
}
