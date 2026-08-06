import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/user_provider.dart';
import 'routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      // Màn hình khởi động thực hiện initAuth() — tương đương setReady(true) trong App.tsx
      home: const _AuthGate(),
      routes: AppRoutes.routes,
    );
  }
}

/// Auth gate kiểm tra token lưu trong secure storage khi app khởi động.
/// Giống với logic useEffect() / initAuth() trong App.tsx của React.
class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  @override
  void initState() {
    super.initState();
    // Gọi initAuth() ngay sau khi widget được mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().initAuth().then((_) {
        if (!mounted) return;
        final status = context.read<UserProvider>().authStatus;
        if (status == AuthStatus.authenticated) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.main);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Splash screen — tương đương `return ready ? <AppRouter /> : null`
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_grocery_store_rounded,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              AppStrings.appName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
