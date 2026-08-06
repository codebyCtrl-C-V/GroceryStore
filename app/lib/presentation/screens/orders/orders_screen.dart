import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/order_provider.dart';
import '../../providers/user_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = context.read<UserProvider>();
      if (userProvider.isLoggedIn) {
        context.read<OrderProvider>().fetchOrders(token: userProvider.accessToken);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildOrderList(List orders) {
    if (orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 12),
              const Text(
                'Không có đơn hàng nào ở trạng thái này.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        final order = orders[index];
        final userProvider = context.read<UserProvider>();
        final orderProvider = context.read<OrderProvider>();

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppStrings.orderId}: #${order.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    _buildStatusBadge(order.status),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Thanh toán: ${order.paymentMethod.toUpperCase()}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const Divider(height: 24),
                // Items details
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.details.length,
                  itemBuilder: (context, dIndex) {
                    final detail = order.details[dIndex];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              width: 36,
                              height: 36,
                              color: Colors.grey[50],
                              child: detail.product.image.isNotEmpty
                                  ? Image.network(
                                      detail.product.image,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.image_not_supported, size: 16, color: Colors.grey),
                                    )
                                  : const Icon(Icons.image_not_supported, size: 16, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  detail.product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'SL: ${detail.quantity} • Giá: ${detail.price.toStringAsFixed(0)}đ',
                                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${detail.total.toStringAsFixed(0)}đ',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng tiền: ${order.total.toStringAsFixed(0)}đ',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.error),
                    ),
                    if (order.status == 'pending')
                      SizedBox(
                        height: 32,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(AppStrings.cancelOrderButton),
                                content: const Text(AppStrings.cancelOrderConfirm),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text(AppStrings.cancel, style: TextStyle(color: Colors.grey)),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Xác nhận', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              final success = await orderProvider.cancelOrder(
                                orderId: order.id,
                                token: userProvider.accessToken,
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(success ? 'Hủy đơn hàng thành công!' : 'Hủy đơn hàng thất bại.'),
                                    backgroundColor: success ? AppColors.secondary : AppColors.error,
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(AppStrings.cancelOrderButton, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        text = 'Chờ xử lý';
        break;
      case 'processing':
        color = Colors.blue;
        text = 'Đang giao';
        break;
      case 'completed':
        color = AppColors.secondary;
        text = 'Đã giao';
        break;
      case 'cancelled':
        color = AppColors.error;
        text = 'Đã hủy';
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final userProvider = context.watch<UserProvider>();
    final isLoading = orderProvider.isLoading;

    if (!userProvider.isLoggedIn) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.ordersTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 12),
                const Text('Vui lòng đăng nhập để xem lịch sử mua hàng.', style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text('Đăng nhập', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.ordersTitle),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(child: Text('Chờ xử lý', style: TextStyle(fontSize: 11))),
            Tab(child: Text('Đang giao', style: TextStyle(fontSize: 11))),
            Tab(child: Text('Đã giao', style: TextStyle(fontSize: 11))),
            Tab(child: Text('Đã hủy', style: TextStyle(fontSize: 11))),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(orderProvider.pendingOrders),
                _buildOrderList(orderProvider.processingOrders),
                _buildOrderList(orderProvider.completedOrders),
                _buildOrderList(orderProvider.cancelledOrders),
              ],
            ),
    );
  }
}
