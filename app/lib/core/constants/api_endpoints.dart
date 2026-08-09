import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static String baseUrl = dotenv.env['API_BASE_URL']!;

  // Authentication
  static const String login = 'login';
  static const String refreshToken = 'login/refresh-token';
  static const String register = 'register';
  static const String logout = 'logout';
  static const String profile = 'profile';
  static const String profileUpdate = 'profile/update';
  static const String changePassword = 'profile/change-password';
  static const String googleAuth = 'login/google';

  // Products
  static const String productsForHome = 'product/for_home';
  static const String newProducts = 'product/new';
  static const String searchProducts = 'product/search';
  static String productDetail(String slug) => 'product/$slug';

  // Categories
  static const String categories = 'category';
  static String categoryProducts(String slug) => 'category/$slug';
  static const String saleVegetablesFruits = 'category/sale/vegetables-fruits';
  static const String saleProcessed = 'category/sale/proceed';

  // Cart
  static const String cart = 'cart';
  static const String cartAdd = 'cart/add';
  static String cartUpdate(dynamic id) => 'cart/update/$id';
  static String cartDelete(dynamic id) => 'cart/delete/$id';

  // Checkout & Orders
  static const String checkout = 'checkout';
  static const String checkoutSubmit = 'checkout/submit';
  static const String orders = 'orders';
  static String cancelOrder(dynamic id) => 'orders/$id/cancel';

  // News
  static const String news = 'news';
  static String newsDetail(String slug) => 'news/$slug';

  // Chatbot
  static const String chatbot = 'chatbot/api/chat';
}
