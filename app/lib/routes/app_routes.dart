import 'package:flutter/material.dart';

import '../presentation/screens/cart/cart_screen.dart';
import '../presentation/screens/chatbot/chatbot_screen.dart';
import '../presentation/screens/checkout/checkout_screen.dart';
import '../presentation/screens/login/login_screen.dart';
import '../presentation/screens/main_shell.dart';
import '../presentation/screens/news/news_detail_screen.dart';
import '../presentation/screens/orders/orders_screen.dart';
import '../presentation/screens/product/product_detail_screen.dart';
import '../presentation/screens/product/product_list_screen.dart';
import '../presentation/screens/register/register_screen.dart';

/// Quản lý routing tập trung tại một nơi thay vì rải rác
/// Navigator.push khắp nơi trong code.
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String productDetail = '/product-detail';
  static const String categoryProducts = '/category-products';
  static const String newsDetail = '/news-detail';
  static const String chatbot = '/chatbot';

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginScreen(),
        register: (_) => const RegisterScreen(),
        main: (_) => const MainShell(),
        cart: (_) => const CartScreen(),
        checkout: (_) => const CheckoutScreen(),
        orders: (_) => const OrdersScreen(),
        productDetail: (_) => const ProductDetailScreen(),
        categoryProducts: (_) => const ProductListScreen(),
        newsDetail: (_) => const NewsDetailScreen(),
        chatbot: (_) => const ChatbotScreen(),
      };
}
