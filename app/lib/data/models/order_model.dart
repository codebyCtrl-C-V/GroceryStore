class OrderModel {
  final String id;
  final String status;
  final double total;
  final String createdAt;
  final String paymentMethod;
  final List<OrderDetailModel> details;

  const OrderModel({
    required this.id,
    required this.status,
    required this.total,
    required this.createdAt,
    required this.paymentMethod,
    required this.details,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final list = json['details'] as List? ?? [];
    return OrderModel(
      id: json['id'].toString(),
      status: json['status'] as String? ?? 'pending',
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      createdAt: json['createdAt'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? 'COD',
      details: list.map((e) => OrderDetailModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'total': total,
      'createdAt': createdAt,
      'paymentMethod': paymentMethod,
      'details': details.map((e) => e.toJson()).toList(),
    };
  }
}

class OrderDetailModel {
  final OrderDetailProductModel product;
  final int quantity;
  final double price;
  final double total;

  const OrderDetailModel({
    required this.product,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      product: OrderDetailProductModel.fromJson(json['product'] as Map<String, dynamic>? ?? {}),
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      total: double.tryParse(json['total'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'price': price,
      'total': total,
    };
  }
}

class OrderDetailProductModel {
  final String name;
  final String image;

  const OrderDetailProductModel({
    required this.name,
    required this.image,
  });

  factory OrderDetailProductModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailProductModel(
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
    };
  }
}
