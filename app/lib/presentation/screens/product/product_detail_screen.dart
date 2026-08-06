import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/user_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final slug = ModalRoute.of(context)!.settings.arguments as String;
      context.read<ProductProvider>().fetchProductDetail(slug);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final product = productProvider.productDetail;
    final isLoading = productProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(product?.name ?? 'Chi tiết sản phẩm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : product == null
              ? const Center(child: Text('Không tìm thấy sản phẩm này.'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Container
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: 300,
                        alignment: Alignment.center,
                        child: product.image.isNotEmpty
                            ? Image.network(
                                product.image,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                              )
                            : const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sale tag
                            if (product.sale > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Giảm giá ${product.sale}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 12),
                            // Title
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Price
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${product.discountPrice.toStringAsFixed(0)}đ',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.error,
                                  ),
                                ),
                                if (product.sale > 0) ...[
                                  const SizedBox(width: 12),
                                  Text(
                                    '${product.price.toStringAsFixed(0)}đ',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Stock Status
                            Row(
                              children: [
                                const Text('Tình trạng: '),
                                Text(
                                  product.stock > 0 ? 'Còn hàng (${product.stock})' : 'Hết hàng',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: product.stock > 0 ? AppColors.secondary : AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 32),
                            // Description
                            const Text(
                              'Mô tả sản phẩm',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.description ?? 'Hiện tại chưa có mô tả chi tiết cho sản phẩm này.',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 100), // padding for bottom action bar
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      bottomSheet: product == null
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Quantity adjustment
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (_quantity > 1) {
                              setState(() {
                                _quantity--;
                              });
                            }
                          },
                        ),
                        Text(
                          _quantity.toString(),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (_quantity < product.stock) {
                              setState(() {
                                _quantity++;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Add to Cart
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                            quantity: _quantity,
                            token: userProvider.accessToken,
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(success
                                    ? 'Đã thêm $_quantity ${product.name} vào giỏ hàng!'
                                    : 'Thêm vào giỏ hàng thất bại.'),
                                backgroundColor: success ? AppColors.secondary : AppColors.error,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Thêm vào giỏ hàng',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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
