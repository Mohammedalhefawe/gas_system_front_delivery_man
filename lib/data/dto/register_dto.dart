class RegisterDto {
  final String fullName;
  final String phoneNumber;
  final String password;
  final String passwordConfirmation;

  RegisterDto({
    required this.fullName,
    required this.phoneNumber,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone_number': phoneNumber,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}