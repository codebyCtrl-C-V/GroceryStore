import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../providers/cart_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final userProvider = context.read<UserProvider>();
    final success = await userProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      // Fetch cart items immediately
      context.read<CartProvider>().fetchCart(token: userProvider.accessToken);

      Navigator.of(context).pushReplacementNamed('/main');
    } else if (userProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userProvider.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleLoginWithGoogle() async {
    final userProvider = context.read<UserProvider>();
    final success = await userProvider.loginWithGoogle();

    if (!mounted) return;

    if (success) {
      context.read<CartProvider>().fetchCart(token: userProvider.accessToken);
      Navigator.of(context).pushReplacementNamed('/main');
    } else if (userProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userProvider.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<UserProvider>().isLoading;
    final googleLoading = context.watch<UserProvider>().isGoogleLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(AppStrings.loginTitle),
        elevation: 0,
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.shopping_basket,
                    size: 80,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Chào mừng quay lại!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Đăng nhập để tiếp tục mua sắm các thực phẩm tươi sạch.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: AppStrings.emailHint,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: AppStrings.passwordHint,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    label: AppStrings.loginButton,
                    isLoading: isLoading,
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 20),
                  //Nut button google login
                  OutlinedButton.icon(
                    icon: googleLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Image.asset('assets/images/google.png', height: 24),
                    label: Text(
                      googleLoading
                          ? 'Đang đăng nhập...'
                          : AppStrings.loginWithGoogle,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: googleLoading ? null : _handleLoginWithGoogle,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      AppStrings.registerNavigate,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Bỏ qua đăng nhập
                      Navigator.pushReplacementNamed(context, '/main');
                    },
                    child: const Text(
                      'Khám phá không cần đăng nhập',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
