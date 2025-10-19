import 'dart:convert';

class ReviewModel {
  final int productId;
  final int rating;
  final String review;

  ReviewModel({
    required this.productId,
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'rating': rating,
    'review': review,
  };

  String toRawJson() => json.encode(toJson());

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      productId: json['product_id'] ?? 0,
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
    );
  }

  factory ReviewModel.fromRawJson(String str) =>
      ReviewModel.fromJson(json.decode(str));
}
