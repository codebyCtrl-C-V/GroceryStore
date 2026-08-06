import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';

class ChatbotRemoteDataSource {
  Future<String> askChatbot(String message) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.chatbot}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseBody['reply'] as String? ?? 'Xin lỗi, tôi gặp sự cố khi trả lời.';
    } else {
      throw Exception(responseBody['error'] ?? 'Lỗi khi kết nối với máy chủ chatbot.');
    }
  }
}
