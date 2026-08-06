import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final hasSale = product.sale > 0;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product-detail',
          arguments: product.slug,
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: product.image.isNotEmpty
                          ? Image.network(
                              product.image,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                            )
                          : const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
                // Details
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Price
                      if (hasSale) ...[
                        Row(
                          children: [
                            Text(
                              '${product.discountPrice.toStringAsFixed(0)}đ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.error,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${product.price.toStringAsFixed(0)}đ',
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Text(
                          '${product.price.toStringAsFixed(0)}đ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      // Quick Add to Cart
                      SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () async {
                            final userProvider = context.read<UserProvider>();
                            if (!userProvider.isLoggedIn) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Vui lòng đăng nhập để mua hàng!')),
                              );
                              Navigator.pushNamed(context, '/login');
                              return;
                            }

                            final cartProvider = context.read<CartProvider>();
                            final success = await cartProvider.addToCart(
                              productId: product.id,
                              quantity: 1,
                              token: userProvider.accessToken,
                            );

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success
                                      ? 'Đã thêm ${product.name} vào giỏ hàng!'
                                      : 'Thêm vào giỏ hàng thất bại.'),
                                  backgroundColor: success ? AppColors.secondary : AppColors.error,
                                ),
                              );
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text('Mua', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Discount label
            if (hasSale)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '-${product.sale}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
