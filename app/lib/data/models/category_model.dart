class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String? description;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
    };
  }
}
