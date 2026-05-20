import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  @HiveField(4)
  String fullName;

  @HiveField(5)
  String phoneNumber;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  String role;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
    required this.createdAt,
    this.role = 'customer',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final roleValue =
        json['role']?.toString().trim().toLowerCase() ?? 'customer';

    return User(
      id: json['id'].toString(),
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: '', // Password tidak dikirim dari API
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      role: roleValue,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'password': password,
        'full_name': fullName,
        'phone_number': phoneNumber,
        'created_at': createdAt.toIso8601String(),
        'role': role,
      };
}
