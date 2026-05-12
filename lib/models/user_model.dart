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

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
    required this.createdAt,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'password': password,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'createdAt': createdAt.toIso8601String(),
  };

  // From JSON
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    username: json['username'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    fullName: json['fullName'] as String,
    phoneNumber: json['phoneNumber'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
