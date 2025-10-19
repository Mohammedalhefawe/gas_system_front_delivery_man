class RegisterResponseDto {
  final int userId;
  final String phoneNumber;

  RegisterResponseDto({required this.userId, required this.phoneNumber});

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) {
    return RegisterResponseDto(
      userId: json['user_id'] as int,
      phoneNumber: json['phone_number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'phone_number': phoneNumber};
  }
}
