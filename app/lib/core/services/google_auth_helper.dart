import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleAuthHelper {
  // serverClientId PHẢI là WEB CLIENT ID (không phải Android Client ID)
  // -> chỉ khi đó idToken trả về mới verify được ở backend Node.js
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: dotenv.env['GOOGLE_IOS_CLIENT_ID']!,
    serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID']!,
  );

  /// Mở popup chọn tài khoản Google, trả về idToken (null nếu user huỷ hoặc lỗi).
  static Future<String?> getIdToken() async {
    try {
      // Xoá session cũ trước để buộc Google hiện lại danh sách tài khoản
      // để chọn, thay vì tự động dùng lại tài khoản lần trước.
      await _googleSignIn.signOut();

      final account = await _googleSignIn.signIn();
      if (account == null) return null; // user bấm huỷ

      final auth = await account.authentication;
      return auth.idToken;
    } catch (e) {
      // ignore: avoid_print
      print('Google sign-in error: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
