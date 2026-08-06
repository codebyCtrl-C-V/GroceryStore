import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../models/news_model.dart';

class NewsRemoteDataSource {
  Future<Map<String, dynamic>> getAllNews({int page = 1}) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.news}?page=$page'),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      final data = responseBody['data'] as Map<String, dynamic>;
      final list = data['news'] as List? ?? [];
      final news = list.map((e) => NewsModel.fromJson(e as Map<String, dynamic>)).toList();
      return {
        'news': news,
        'currentPage': int.tryParse(data['currentPage'].toString()) ?? 1,
        'totalPages': int.tryParse(data['totalPages'].toString()) ?? 1,
      };
    } else {
      throw Exception(responseBody['message'] ?? 'Lấy danh sách tin tức thất bại.');
    }
  }

  Future<NewsModel> getNewsDetail(String slug) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.newsDetail(slug)}'),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      final data = responseBody['data'] as Map<String, dynamic>;
      return NewsModel.fromJson(data['news'] as Map<String, dynamic>);
    } else {
      throw Exception(responseBody['message'] ?? 'Lấy chi tiết tin tức thất bại.');
    }
  }
}
