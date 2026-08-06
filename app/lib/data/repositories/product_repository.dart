import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepository({ProductRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ProductRemoteDataSource();

  Future<Map<String, List<ProductModel>>> getProductsForHome() {
    return _remoteDataSource.getProductsForHome();
  }

  Future<List<ProductModel>> getNewProducts() {
    return _remoteDataSource.getNewProducts();
  }

  Future<ProductModel> getProductDetail(String slug) {
    return _remoteDataSource.getProductDetail(slug);
  }

  Future<Map<String, dynamic>> searchProducts({
    required String query,
    String sort = 'default',
    int page = 1,
  }) {
    return _remoteDataSource.searchProducts(query: query, sort: sort, page: page);
  }
}
