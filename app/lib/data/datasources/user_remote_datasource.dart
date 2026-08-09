import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../models/user_model.dart';

class UserRemoteDataSource {
  static String? accessToken;

  // Helper for headers
  Map<String, String> _headers([String? customToken]) {
    final token = customToken ?? accessToken;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.login}'),
      headers: _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      final data = responseBody['data'];
      accessToken = data['accessToken'] as String?;
      final userJson = data['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userJson);
      return {
        'user': user,
        'accessToken': data['accessToken'],
        'refreshToken': data['refreshToken'],
      };
    } else {
      throw Exception(responseBody['message'] ?? 'Đăng nhập thất bại.');
    }
  }

  Future<Map<String, dynamic>> loginWithGoogle({required String token}) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.googleAuth}'),
      headers: _headers(),
      body: jsonEncode({'token': token}),
    );

    final responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      final data = responseBody['data'];
      accessToken = data['accessToken'] as String?;
      final userJson = data['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userJson);
      return {
        'user': user,
        'accessToken': data['accessToken'],
        'refreshToken': data['refreshToken'],
      };
    } else {
      throw Exception(responseBody['message'] ?? 'Đăng nhập thất bại.');
    }
  }

  Future<String> refreshToken({required String refreshTokenValue}) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.refreshToken}'),
      headers: _headers(),
      body: jsonEncode({'refreshToken': refreshTokenValue}),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      final newToken = responseBody['data']['accessToken'] as String;
      accessToken = newToken;
      return newToken;
    } else {
      throw Exception(responseBody['message'] ?? 'Phiên đăng nhập đã hết hạn.');
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String repassword,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.register}'),
      headers: _headers(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'repassword': repassword,
      }),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 201 && responseBody['status'] == 'success') {
      return true;
    } else {
      throw Exception(responseBody['message'] ?? 'Đăng ký thất bại.');
    }
  }

  Future<UserModel> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.profile}'),
      headers: _headers(token),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      return UserModel.fromJson(responseBody['data'] as Map<String, dynamic>);
    } else {
      throw Exception(
        responseBody['message'] ?? 'Không thể tải thông tin cá nhân.',
      );
    }
  }

  Future<bool> updateProfile({
    required String token,
    required String name,
    required String phone,
    required String address,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.profileUpdate}'),
      headers: _headers(token),
      body: jsonEncode({'name': name, 'phone': phone, 'address': address}),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      return true;
    } else {
      throw Exception(
        responseBody['message'] ?? 'Cập nhật thông tin thất bại.',
      );
    }
  }

  Future<bool> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.changePassword}'),
      headers: _headers(token),
      body: jsonEncode({
        'oldpass': oldPassword,
        'newpass': newPassword,
        'renewpass': confirmPassword,
      }),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody['status'] == 'success') {
      return true;
    } else {
      throw Exception(responseBody['message'] ?? 'Đổi mật khẩu thất bại.');
    }
  }

  Future<bool> logout({String? token, String? refreshTokenValue}) async {
    final targetToken = token ?? accessToken;
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.logout}'),
      headers: _headers(targetToken),
      body: jsonEncode({'refreshToken': refreshTokenValue}),
    );

    accessToken = null;
    final responseBody = jsonDecode(response.body);
    return response.statusCode == 200 && responseBody['status'] == 'success';
  }
}
