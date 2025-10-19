import 'package:gas_delivery_app/data/models/user_model.dart';

class LoginResponseDto {
  final UserModel user;
  final String token;

  LoginResponseDto({required this.user, required this.token});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      user: UserModel.fromJson(json["data"]['user'] as Map<String, dynamic>),
      token: json['data']['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'token': token};
  }
}
