class OtpDto {
  final String? token;
  final int? id;
  final bool isExist;

  OtpDto({required this.token, required this.id, required this.isExist});

  factory OtpDto.fromJson(Map<String, dynamic> json, isExist) =>
      OtpDto(token: json["token"], id: json["id"], isExist: isExist);
  factory OtpDto.fromJson2(Map<String, dynamic> json, isExist) => OtpDto(
    token: json["token"]["token"],
    id: json["token"]["id"],
    isExist: isExist,
  );
  Map<String, dynamic> toJson() => {"token": token, "id": id};
}
