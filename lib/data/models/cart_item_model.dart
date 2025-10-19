import 'dart:convert';
import 'package:gas_delivery_app/data/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;

  CartItemModel({required this.product, required this.quantity});

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
  };

  String toRawJson() => json.encode(toJson());

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
    );
  }

  factory CartItemModel.fromRawJson(String str) =>
      CartItemModel.fromJson(json.decode(str));
}
