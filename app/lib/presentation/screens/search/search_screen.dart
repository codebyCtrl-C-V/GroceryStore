import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _sort = 'default';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _triggerSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<ProductProvider>().searchProducts(
            query: query,
            sort: _sort,
            page: 1,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final results = productProvider.searchResults;
    final isLoading = productProvider.isLoading;

    return Column(
      children: [
        // Search Input Bar
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppStrings.searchHint,
                    prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (val) {
                    setState(() {});
                  },
                  onSubmitted: (_) => _triggerSearch(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _triggerSearch,
                child: const Text('Tìm', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),

        // Sort filter bar
        if (results.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      _triggerSearch();
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

        // Results Grid
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : results.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_outlined, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 12),
                            const Text(
                              AppStrings.noProductsFound,
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final product = results[index];
                        return ProductCard(product: product);
                      },
                    ),
        ),
      ],
    );
  }
}
