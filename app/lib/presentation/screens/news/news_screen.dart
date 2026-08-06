import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/news_provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().fetchAllNews(page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = context.watch<NewsProvider>();
    final newsList = newsProvider.newsList;
    final isLoading = newsProvider.isLoading;

    return Scaffold(
      body: isLoading && newsList.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: () => newsProvider.fetchAllNews(page: 1),
              child: ListView.builder(
                itemCount: newsList.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final news = newsList[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/news-detail',
                        arguments: news.slug,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEEEEEE)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.01),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cover Image
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Container(
                              height: 160,
                              width: double.infinity,
                              color: Colors.grey[50],
                              child: news.image.isNotEmpty
                                  ? Image.network(
                                      news.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.image_not_supported,
                                              size: 40, color: Colors.grey),
                                    )
                                  : const Icon(Icons.image_not_supported,
                                      size: 40, color: Colors.grey),
                            ),
                          ),
                          // Text Contents
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  news.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  news.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        size: 12, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      news.updatedAt.split(' ').first,
                                      style: const TextStyle(
                                          fontSize: 10, color: AppColors.textSecondary),
                                    ),
                                    const Spacer(),
                                    const Text(
                                      'Đọc tiếp →',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
