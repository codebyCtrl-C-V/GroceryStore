class ProductModel {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final int stock;
  final int? categoryId;
  final String image;
  final int sale;

  const ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    required this.stock,
    this.categoryId,
    required this.image,
    required this.sale,
  });

  double get discountPrice => price * (1 - sale / 100);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String?,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      categoryId: int.tryParse(json['category_id'].toString()),
      image: json['image'] as String? ?? '',
      sale: int.tryParse(json['sale'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'price': price,
      'stock': stock,
      'category_id': categoryId,
      'image': image,
      'sale': sale,
    };
  }
}
