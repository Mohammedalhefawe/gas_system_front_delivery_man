import 'package:gas_delivery_app/core/extensions/prefix_url_image_extension.dart';

class ProductModel {
  final int id;
  final int categoryId;
  final String productName;
  final String description;
  final String? imageUrl;
  final double price;
  final bool isAvailable;
  final String? specialNotes;
  final String createdAt;
  final bool isExistInCart;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.productName,
    required this.description,
    this.imageUrl,
    required this.price,
    required this.isAvailable,
    this.specialNotes,
    required this.createdAt,
    this.isExistInCart = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['product_id'] as int,
      categoryId: json['category_id'] as int,
      productName: json['product_name'] as String,
      description: json['description'] as String,
      imageUrl: (json['image_url'] as String?)?.withImagePrefix,
      price: double.parse(json['price'] as String),
      isAvailable: (json['is_available'] as int) == 1,
      specialNotes: json['special_notes'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'category_id': categoryId,
      'product_name': productName,
      'description': description,
      'image_url': imageUrl,
      'price': price.toString(),
      'is_available': isAvailable ? 1 : 0,
      'special_notes': specialNotes,
      'created_at': createdAt,
    };
  }

  ProductModel copyWith({
    int? id,
    int? categoryId,
    String? productName,
    String? description,
    String? imageUrl,
    double? price,
    bool? isAvailable,
    String? specialNotes,
    String? createdAt,
    bool? isExistInCart,
  }) {
    return ProductModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
      specialNotes: specialNotes ?? this.specialNotes,
      createdAt: createdAt ?? this.createdAt,
      isExistInCart: isExistInCart ?? this.isExistInCart,
    );
  }
}
