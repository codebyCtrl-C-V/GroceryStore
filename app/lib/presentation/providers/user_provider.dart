import 'package:flutter/material.dart';
import '../../core/services/auth_storage_service.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import '../../core/services/google_auth_helper.dart';

/// Trạng thái khởi tạo auth — tương đương [ready] state trong App.tsx
enum AuthStatus {
  /// Đang kiểm tra token lưu trong storage (splash)
  checking,

  /// Đã xác thực, user đã đăng nhập
  authenticated,

  /// Chưa đăng nhập hoặc token hết hạn
  unauthenticated,
}

class UserProvider extends ChangeNotifier {
  final UserRepository _repository;
  final AuthStorageService _storage;

  UserProvider({UserRepository? repository, AuthStorageService? storage})
    : _repository = repository ?? UserRepository(),
      _storage = storage ?? AuthStorageService.instance;

  UserModel? _currentUser;
  String? _accessToken;
  String? _refreshToken;
  bool _isLoading = false;
  String? _errorMessage;
  AuthStatus _authStatus = AuthStatus.checking;
  bool _isGoogleLoading = false;

  UserModel? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _authStatus == AuthStatus.authenticated;
  AuthStatus get authStatus => _authStatus;
  bool get isGoogleLoading => _isGoogleLoading;

  // ══════════════════════════════════════════════════════════════
  // initAuth — gọi khi app khởi động, giống useEffect trong App.tsx
  // ══════════════════════════════════════════════════════════════
  /// Kiểm tra token đã lưu, thử refresh, rồi load profile.
  /// Tương đương:
  ///   const access_token  = localStorage.getItem('access_token');
  ///   const refresh_token = localStorage.getItem('refresh_token');
  ///   await refreshToken();
  ///   await fetchUserInfor();
  Future<void> initAuth() async {
    _authStatus = AuthStatus.checking;
    notifyListeners();

    final tokens = await _storage.readAll();
    final storedAccess = tokens.access;
    final storedRefresh = tokens.refresh;

    // Không có token → chuyển về login
    if (storedAccess == null || storedRefresh == null) {
      _authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }

    try {
      // Thử refresh để lấy access token mới (token cũ có thể đã hết hạn)
      final newAccessToken = await _repository.refreshToken(
        refreshTokenValue: storedRefresh,
      );
      _accessToken = newAccessToken;
      _refreshToken = storedRefresh;
      await _storage.updateAccessToken(newAccessToken);

      // Load thông tin user
      _currentUser = await _repository.getProfile(newAccessToken);
      _authStatus = AuthStatus.authenticated;
    } catch (e) {
      // Refresh hết hạn → xoá token, về trang login
      await _storage.clearTokens();
      _accessToken = null;
      _refreshToken = null;
      _currentUser = null;
      _authStatus = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  // ══════════════════════════════════════════════════════════════
  // Login
  // ══════════════════════════════════════════════════════════════
  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _repository.login(email: email, password: password);
      _currentUser = res['user'] as UserModel?;
      _accessToken = res['accessToken'] as String?;
      _refreshToken = res['refreshToken'] as String?;

      // Lưu cả hai token vào secure storage
      if (_accessToken != null && _refreshToken != null) {
        await _storage.saveTokens(
          accessToken: _accessToken!,
          refreshToken: _refreshToken!,
        );
      }

      _authStatus = AuthStatus.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _isGoogleLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // B1: Lấy idToken từ Google
      final idToken = await GoogleAuthHelper.getIdToken();

      if (idToken == null) {
        _errorMessage = 'Đăng nhập Google đã bị huỷ.';
        _isGoogleLoading = false;
        notifyListeners();
        return false;
      }

      // B2: Gửi idToken lên backend để verify + tạo/lấy user + nhận accessToken
      final result = await _repository.loginWithGoogle(token: idToken);

      _currentUser = result['user'] as UserModel?;
      _accessToken = result['accessToken'] as String?;
      _refreshToken = result['refreshToken'] as String?;

      // Lưu token vào secure storage — thiếu bước này thì app sẽ tự logout
      // ngay khi restart vì initAuth() không tìm thấy token đã lưu.
      if (_accessToken != null && _refreshToken != null) {
        await _storage.saveTokens(
          accessToken: _accessToken!,
          refreshToken: _refreshToken!,
        );
      }

      // Thiếu dòng này thì isLoggedIn luôn trả về false dù login thành công,
      // vì isLoggedIn dựa vào _authStatus chứ không phải _currentUser.
      _authStatus = AuthStatus.authenticated;

      _isGoogleLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isGoogleLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ══════════════════════════════════════════════════════════════
  // Register
  // ══════════════════════════════════════════════════════════════
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String repassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.register(
        name: name,
        email: email,
        password: password,
        repassword: repassword,
      );
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ══════════════════════════════════════════════════════════════
  // Profile
  // ══════════════════════════════════════════════════════════════
  Future<void> loadProfile() async {
    if (_accessToken == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _repository.getProfile(_accessToken!);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    if (_accessToken == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.updateProfile(
        token: _accessToken!,
        name: name,
        phone: phone,
        address: address,
      );
      if (success) await loadProfile();
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (_accessToken == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _repository.changePassword(
        token: _accessToken!,
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ══════════════════════════════════════════════════════════════
  // Logout — xoá token khỏi storage
  // ══════════════════════════════════════════════════════════════
  Future<void> logout() async {
    try {
      await _repository.logout(
        token: _accessToken,
        refreshTokenValue: _refreshToken,
      );
    } catch (_) {
      // ignore logout API error
    }

    // Xoá token secure storage
    await _storage.clearTokens();

    _currentUser = null;
    _accessToken = null;
    _refreshToken = null;
    _authStatus = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
