import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      if (userProvider.isLoggedIn) {
        userProvider.loadProfile();
      }
    });
  }

  void _showUpdateProfileDialog() {
    final user = context.read<UserProvider>().currentUser;
    if (user == null) return;

    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone ?? '');
    final addressController = TextEditingController(text: user.address ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.updateProfileTitle),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: AppStrings.nameHint),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Nhập họ tên' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: AppStrings.receiverPhone),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: AppStrings.shippingAddress),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppStrings.cancel, style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                final userProvider = context.read<UserProvider>();
                final success = await userProvider.updateProfile(
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  address: addressController.text.trim(),
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? AppStrings.profileUpdateSuccess : 'Cập nhật thất bại!'),
                      backgroundColor: success ? AppColors.secondary : AppColors.error,
                    ),
                  );
                }
              },
              child: const Text(AppStrings.save, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.changePasswordTitle),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: oldPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: AppStrings.oldPasswordHint),
                    validator: (v) => v == null || v.isEmpty ? 'Nhập mật khẩu cũ' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: AppStrings.newPasswordHint),
                    validator: (v) => v == null || v.length < 6 ? 'Mật khẩu phải từ 6 ký tự' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: AppStrings.confirmPasswordHint),
                    validator: (v) => v == null || v.isEmpty ? 'Xác nhận mật khẩu mới' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppStrings.cancel, style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                if (newPasswordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(AppStrings.passwordsDoNotMatch), backgroundColor: AppColors.error),
                  );
                  return;
                }

                final userProvider = context.read<UserProvider>();
                final success = await userProvider.changePassword(
                  oldPassword: oldPasswordController.text,
                  newPassword: newPasswordController.text,
                  confirmPassword: confirmPasswordController.text,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? AppStrings.passwordChangeSuccess : 'Đổi mật khẩu thất bại!'),
                      backgroundColor: success ? AppColors.secondary : AppColors.error,
                    ),
                  );
                }
              },
              child: const Text(AppStrings.save, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.currentUser;
    final isLoggedIn = userProvider.isLoggedIn;
    final isLoading = userProvider.isLoading;

    if (isLoading && user == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (!isLoggedIn) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle_outlined, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Vui lòng đăng nhập để xem thông tin cá nhân.',
                style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 160,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Đăng nhập', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Avatar & Name Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user!.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      if (user.role != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            user.role!.toUpperCase(),
                            style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // User Info details list
          _buildInfoTile(Icons.phone_outlined, 'Số điện thoại', user.phone ?? 'Chưa cập nhật'),
          _buildInfoTile(Icons.location_on_outlined, 'Địa chỉ giao hàng', user.address ?? 'Chưa cập nhật'),
          const SizedBox(height: 24),

          // Settings List
          _buildActionCard(
            title: 'Cài đặt tài khoản',
            children: [
              _buildActionRow(Icons.edit_outlined, 'Cập nhật thông tin', _showUpdateProfileDialog),
              _buildActionRow(Icons.lock_outline, 'Đổi mật khẩu', _showChangePasswordDialog),
            ],
          ),
          const SizedBox(height: 16),

          _buildActionCard(
            title: 'Mua sắm',
            children: [
              _buildActionRow(Icons.history_toggle_off, AppStrings.ordersTitle, () {
                Navigator.pushNamed(context, '/orders');
              }),
            ],
          ),
          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final navigator = Navigator.of(context); // capture trước await
                await userProvider.logout();
                if (!mounted) return;
                navigator.pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Text(AppStrings.logoutButton, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({required String title, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildActionRow(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }
}
