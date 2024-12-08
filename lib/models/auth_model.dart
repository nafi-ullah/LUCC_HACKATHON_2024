import 'dart:convert';

class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final String timezone;
  final String profession;
  final String token;
  final String? notificationId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.timezone,
    required this.profession,
    required this.token,
    this.notificationId,
  });

  // JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'timezone': timezone,
      'profession': profession,
      'token': token,
      'notificationId': notificationId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      timezone: map['timezone'] ?? '',
      profession: map['profession'] ?? '',
      token: map['token'] ?? '',
      notificationId: map['notificationId'], // Nullable field
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
