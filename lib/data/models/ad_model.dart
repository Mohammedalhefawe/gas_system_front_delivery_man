import 'package:gas_delivery_app/core/extensions/prefix_url_image_extension.dart';

class AdModel {
  final int id;
  final String title;
  final String description;
  final String? image;
  final String link;
  final int userId;
  final String createdAt;
  final String updatedAt;

  AdModel({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    required this.link,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      image: (json['image'] as String?)?.withImagePrefix,
      link: json['link'] as String,
      userId: json['user_id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'link': link,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
