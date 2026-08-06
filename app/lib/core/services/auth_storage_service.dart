import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Quản lý lưu trữ token bảo mật — tương đương với SecureStore ở React Native
/// hoặc localStorage của React web.
/// Lưu cả access_token và refresh_token vào encrypted keystore trên thiết bị.
class AuthStorageService {
  AuthStorageService._();
  static final AuthStorageService instance = AuthStorageService._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyAccess  = 'access_token';
  static const _keyRefresh = 'refresh_token';

  // ── Ghi ─────────────────────────────────────────────────
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _keyAccess,  value: accessToken),
      _storage.write(key: _keyRefresh, value: refreshToken),
    ]);
  }

  Future<void> updateAccessToken(String accessToken) async {
    await _storage.write(key: _keyAccess, value: accessToken);
  }

  // ── Đọc ─────────────────────────────────────────────────
  Future<String?> get accessToken  async => _storage.read(key: _keyAccess);
  Future<String?> get refreshToken async => _storage.read(key: _keyRefresh);

  /// Trả về cả hai token cùng lúc, tương đương:
  ///   localStorage.getItem('access_token')
  ///   localStorage.getItem('refresh_token')
  Future<({String? access, String? refresh})> readAll() async {
    final results = await Future.wait([
      _storage.read(key: _keyAccess),
      _storage.read(key: _keyRefresh),
    ]);
    return (access: results[0], refresh: results[1]);
  }

  // ── Xoá ─────────────────────────────────────────────────
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _keyAccess),
      _storage.delete(key: _keyRefresh),
    ]);
  }
}
