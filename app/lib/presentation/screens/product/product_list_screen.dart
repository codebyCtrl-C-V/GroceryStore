import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/category_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _sort = 'default';
  bool _initialized = false;
  late String _slug;
  late String _title;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _slug = args['slug'] as String;
      _title = args['name'] as String? ?? 'Sản phẩm';

      _fetchProducts();
      _initialized = true;
    }
  }

  void _fetchProducts() {
    if (_slug == 'new') {
      context.read<ProductProvider>().fetchNewProducts();
    } else {
      context.read<CategoryProvider>().fetchCategoryProducts(
            slug: _slug,
            sort: _sort,
            page: 1,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final catProvider = context.watch<CategoryProvider>();
    final prodProvider = context.watch<ProductProvider>();

    final isNewProductSlug = _slug == 'new';
    final isLoading = isNewProductSlug ? prodProvider.isLoading : catProvider.isLoading;
    final products = isNewProductSlug ? prodProvider.newProducts : catProvider.categoryProducts;
    final title = isNewProductSlug ? _title : (catProvider.categoryName.isNotEmpty ? catProvider.categoryName : _title);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Filter / Sort Bar
          if (!isNewProductSlug)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sắp xếp theo:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  DropdownButton<String>(
                    value: _sort,
                    underline: const SizedBox.shrink(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _sort = newValue;
                        });
                        _fetchProducts();
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 'default', child: Text('Mặc định', style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(value: 'price-asc', child: Text('Giá tăng dần', style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(value: 'price-desc', child: Text('Giá giảm dần', style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(value: 'name-asc', child: Text('Tên A-Z', style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(value: 'name-desc', child: Text('Tên Z-A', style: TextStyle(fontSize: 13))),
                    ],
                  ),
                ],
              ),
            ),
          const Divider(height: 1),
          // Product Grid
          Expanded(
            child: isLoading && products.isEmpty
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : products.isEmpty
                    ? const Center(child: Text('Không có sản phẩm nào.'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(product: product);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
