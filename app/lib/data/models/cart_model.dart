class CartItemModel {
  final String id;
  final String userId;
  final String productId;
  final int quantity;
  final CartProductModel product;
  final double finalPrice;
  final double total;

  const CartItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.product,
    required this.finalPrice,
    required this.total,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      productId: json['productId'].toString(),
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,
      product: CartProductModel.fromJson(
          json['product'] as Map<String, dynamic>? ?? {}),
      finalPrice: double.tryParse(json['finalPrice'].toString()) ?? 0.0,
      total: double.tryParse(json['total'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'quantity': quantity,
      'product': product.toJson(),
      'finalPrice': finalPrice,
      'total': total,
    };
  }

  CartItemModel copyWith({int? quantity}) {
    final newQty = quantity ?? this.quantity;
    return CartItemModel(
      id: id,
      userId: userId,
      productId: productId,
      quantity: newQty,
      product: product,
      finalPrice: finalPrice,
      total: finalPrice * newQty,
    );
  }
}

class CartProductModel {
  final String id;
  final String name;
  final double price;
  final int sale;
  final String image;

  const CartProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.sale,
    required this.image,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      sale: int.tryParse(json['sale'].toString()) ?? 0,
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'sale': sale,
      'image': image,
    };
  }
}
