/// Model đại diện cho dữ liệu User, có hàm chuyển đổi
/// qua lại với JSON để làm việc với API/local storage.
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? role,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
    );
  }
}
