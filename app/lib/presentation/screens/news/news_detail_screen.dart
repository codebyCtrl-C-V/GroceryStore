import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/news_provider.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({super.key});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final slug = ModalRoute.of(context)!.settings.arguments as String;
      context.read<NewsProvider>().fetchNewsDetail(slug);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = context.watch<NewsProvider>();
    final news = newsProvider.newsDetail;
    final isLoading = newsProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(news?.title ?? 'Chi tiết bài viết'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : news == null
              ? const Center(child: Text('Không tìm thấy bài viết.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      if (news.image.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.white,
                            child: Image.network(
                              news.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      // Title
                      Text(
                        news.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Time
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            news.updatedAt.split(' ').first,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      // Content text
                      Text(
                        news.content,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
    );
  }
}
