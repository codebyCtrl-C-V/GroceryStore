import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/providers/category_provider.dart';
import 'presentation/providers/chatbot_provider.dart';
import 'presentation/providers/news_provider.dart';
import 'presentation/providers/order_provider.dart';
import 'presentation/providers/product_provider.dart';
import 'presentation/providers/user_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => ChatbotProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
