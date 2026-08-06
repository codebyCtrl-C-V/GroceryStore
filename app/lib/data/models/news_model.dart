class NewsModel {
  final String id;
  final String title;
  final String slug;
  final String image;
  final String content;
  final String createdAt;
  final String updatedAt;

  const NewsModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.image,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'].toString(),
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      image: json['image'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'image': image,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
