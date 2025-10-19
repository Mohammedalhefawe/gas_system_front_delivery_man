class DeliveryFeeModel {
  final int feeId;
  final String fee;
  final String date;
  final String? createdAt;
  final String? updatedAt;

  DeliveryFeeModel({
    required this.feeId,
    required this.fee,
    required this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory DeliveryFeeModel.fromJson(Map<String, dynamic> json) {
    return DeliveryFeeModel(
      feeId: json['fee_id'] as int,
      fee: json['fee'] as String,
      date: json['date'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fee_id': feeId,
      'fee': fee,
      'date': date,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
