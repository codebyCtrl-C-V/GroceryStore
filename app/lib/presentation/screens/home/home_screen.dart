import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load home products on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductProvider>();
      provider.fetchProductsForHome();
      provider.fetchNewProducts();
    });
  }

  Widget _buildProductSection({
    required String title,
    required List outstandingProducts,
    required VoidCallback onViewAll,
  }) {
    if (outstandingProducts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: onViewAll,
                child: const Row(
                  children: [
                    Text(
                      AppStrings.viewAll,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: outstandingProducts.length,
            itemBuilder: (context, index) {
              final product = outstandingProducts[index];
              return ProductCard(product: product);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final isLoading = productProvider.isLoading;

    if (isLoading && productProvider.vegetables.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await productProvider.fetchProductsForHome();
        await productProvider.fetchNewProducts();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Promos / Banner Slider Mock
            Container(
              margin: const EdgeInsets.all(16),
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Opacity(
                      opacity: 0.15,
                      child: Icon(Icons.shopping_bag_outlined, size: 200, color: Colors.white),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ContainerBadge(text: 'Khuyến mãi đặc biệt'),
                        SizedBox(height: 12),
                        Text(
                          'Rau Củ Tươi Sạch\nGiảm Giá Đến 20%',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Hóa đơn từ 150k • Miễn phí vận chuyển',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Category sections
            _buildProductSection(
              title: 'Sản phẩm mới về',
              outstandingProducts: productProvider.newProducts,
              onViewAll: () => Navigator.pushNamed(context, '/category-products', arguments: {'slug': 'new', 'name': 'Sản phẩm mới về'}),
            ),
            _buildProductSection(
              title: 'Rau xanh tươi mát',
              outstandingProducts: productProvider.vegetables,
              onViewAll: () => Navigator.pushNamed(context, '/category-products', arguments: {'slug': 'rau-cu', 'name': 'Rau xanh tươi mát'}),
            ),
            _buildProductSection(
              title: 'Trái cây ngọt lành',
              outstandingProducts: productProvider.fruits,
              onViewAll: () => Navigator.pushNamed(context, '/category-products', arguments: {'slug': 'trai-cay', 'name': 'Trái cây ngọt lành'}),
            ),
            _buildProductSection(
              title: 'Đồ uống & Nước ép',
              outstandingProducts: productProvider.juices,
              onViewAll: () => Navigator.pushNamed(context, '/category-products', arguments: {'slug': 'do-uong', 'name': 'Đồ uống & Nước ép'}),
            ),
            _buildProductSection(
              title: 'Thực phẩm chế biến',
              outstandingProducts: productProvider.processed,
              onViewAll: () => Navigator.pushNamed(context, '/category-products', arguments: {'slug': 'thuc-pham-che-bien', 'name': 'Thực phẩm chế biến'}),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class ContainerBadge extends StatelessWidget {
  final String text;
  const ContainerBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
