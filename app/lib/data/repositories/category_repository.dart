import '../datasources/category_remote_datasource.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepository({CategoryRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? CategoryRemoteDataSource();

  Future<List<CategoryModel>> getAllCategories() {
    return _remoteDataSource.getAllCategories();
  }

  Future<Map<String, dynamic>> getCategoryProducts({
    required String slug,
    String sort = 'default',
    int page = 1,
  }) {
    return _remoteDataSource.getCategoryProducts(slug: slug, sort: sort, page: page);
  }

  Future<Map<String, dynamic>> getSaleVegetablesFruits({int page = 1}) {
    return _remoteDataSource.getSaleVegetablesFruits(page: page);
  }

  Future<Map<String, dynamic>> getSaleProcessed({int page = 1}) {
    return _remoteDataSource.getSaleProcessed(page: page);
  }
}
