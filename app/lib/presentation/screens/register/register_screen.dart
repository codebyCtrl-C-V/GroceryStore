import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.passwordsDoNotMatch),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final userProvider = context.read<UserProvider>();
    final success = await userProvider.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      repassword: _confirmPasswordController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.registerSuccess),
          backgroundColor: AppColors.secondary,
        ),
      );
      Navigator.of(context).pop();
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(AppStrings.registerTitle),
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
                  const Icon(Icons.person_add_outlined, size: 80, color: AppColors.primary),
                  const SizedBox(height: 24),
                  const Text(
                    'Tạo tài khoản mới',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: AppStrings.nameHint,
                      prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Vui lòng nhập họ và tên';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: AppStrings.emailHint,
                      prefixIcon: Icon(Icons.email_outlined, color: AppColors.textSecondary),
                    ),
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: AppStrings.passwordHint,
                      prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary),
                    ),
                    validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: AppStrings.confirmPasswordHint,
                      prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Vui lòng xác nhận mật khẩu';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    label: AppStrings.registerButton,
                    isLoading: isLoading,
                    onPressed: _handleRegister,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      AppStrings.loginNavigate,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
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
