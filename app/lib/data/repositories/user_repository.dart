import '../datasources/user_remote_datasource.dart';
import '../models/user_model.dart';

class UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepository({UserRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? UserRemoteDataSource();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return _remoteDataSource.login(email: email, password: password);
  }

  Future<String> refreshToken({required String refreshTokenValue}) {
    return _remoteDataSource.refreshToken(refreshTokenValue: refreshTokenValue);
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String repassword,
  }) {
    return _remoteDataSource.register(
      name: name,
      email: email,
      password: password,
      repassword: repassword,
    );
  }

  Future<UserModel> getProfile(String token) {
    return _remoteDataSource.getProfile(token);
  }

  Future<bool> updateProfile({
    required String token,
    required String name,
    required String phone,
    required String address,
  }) {
    return _remoteDataSource.updateProfile(
      token: token,
      name: name,
      phone: phone,
      address: address,
    );
  }

  Future<bool> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _remoteDataSource.changePassword(
      token: token,
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }

  Future<bool> logout({String? token, String? refreshTokenValue}) {
    return _remoteDataSource.logout(
      token: token,
      refreshTokenValue: refreshTokenValue,
    );
  }
}
