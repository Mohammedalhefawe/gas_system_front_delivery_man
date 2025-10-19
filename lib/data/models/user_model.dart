import 'dart:convert';

class UserModel {
  final int userId;
  final String phoneNumber;
  // final String fullName;
  final String role;
  final bool isVerified;
  final String? createdAt;
  final dynamic roleInfo;

  UserModel({
    required this.userId,
    required this.phoneNumber,
    required this.role,
    required this.isVerified,
    // required this.fullName,
    this.createdAt,
    this.roleInfo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // fullName: json['role_info']?['full_name'] as String,
      userId: json['user_id'] as int,
      phoneNumber: json['phone_number'] as String,
      role: json['role'] as String,
      isVerified: json['is_verified'] as bool,
      createdAt: json['created_at'] as String?,
      roleInfo: json['role_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'phone_number': phoneNumber,
      'role': role,
      'is_verified': isVerified,
      'created_at': createdAt,
      'role_info': roleInfo,
    };
  }

  /// Convert JSON string to UserModel
  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  /// Convert UserModel to JSON string
  String toRawJson() => json.encode(toJson());

  /// Return an empty user
  factory UserModel.emptyUser() {
    return UserModel(
      userId: 0,
      // fullName: '',
      phoneNumber: '',
      role: '',
      isVerified: false,
      createdAt: null,
      roleInfo: null,
    );
  }
}
