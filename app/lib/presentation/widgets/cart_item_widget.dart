import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/cart_model.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final cartProvider = context.read<CartProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 64,
              height: 64,
              color: Colors.grey[50],
              child: item.product.image.isNotEmpty
                  ? Image.network(
                      item.product.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 24, color: Colors.grey),
                    )
                  : const Icon(Icons.image_not_supported, size: 24, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'đ${item.finalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tổng: đ${item.total.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                onPressed: () {
                  cartProvider.deleteCartItem(
                    cartItemId: item.id,
                    token: userProvider.accessToken,
                  );
                },
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (item.quantity > 1) {
                        cartProvider.updateCartItemQuantity(
                          cartItemId: item.id,
                          quantity: item.quantity - 1,
                          token: userProvider.accessToken,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.remove, size: 14, color: Colors.black87),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      item.quantity.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      cartProvider.updateCartItemQuantity(
                        cartItemId: item.id,
                        quantity: item.quantity + 1,
                        token: userProvider.accessToken,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, size: 14, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
