import 'package:gas_delivery_app/data/models/address_model.dart';
import 'package:gas_delivery_app/data/models/customer_model.dart';
import 'package:gas_delivery_app/data/models/product_model.dart';

class OrderModel {
  final int orderId;
  final int customerId;
  final int? driverId;
  final int addressId;
  final String totalAmount;
  final String deliveryFee;
  final String orderStatus;
  final String orderDate;
  final String? deliveryDate;
  final String? deliveryTime;
  final String paymentMethod;
  final String paymentStatus;
  final String? note;
  final int immediate;
  final String? rating;
  final String? review;
  final List<OrderItemModel> items;
  final AddressModel? address;
  final CustomerModel? customer;

  OrderModel({
    this.orderId = 0,
    this.customerId = 0,
    this.driverId,
    this.addressId = 0,
    this.totalAmount = "",
    this.deliveryFee = "",
    this.orderStatus = "",
    this.orderDate = "",
    this.deliveryDate,
    this.deliveryTime,
    this.paymentMethod = "",
    this.paymentStatus = "",
    this.note,
    this.immediate = 0,
    this.rating,
    this.review,
    this.items = const [],
    this.address,
    this.customer,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      driverId: json['driver_id'],
      addressId: json['address_id'] ?? 0,
      totalAmount: json['total_amount'] ?? "",
      deliveryFee: json['delivery_fee'] ?? "",
      orderStatus: json['order_status'] ?? "",
      orderDate: json['order_date'] ?? "",
      deliveryDate: json['delivery_date'],
      deliveryTime: json['delivery_time'],
      paymentMethod: json['payment_method'] ?? "",
      paymentStatus: json['payment_status'] ?? "",
      note: json['note'],
      immediate: json['immediate'] ?? 0,
      rating: json['rating'],
      review: json['review'],
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : null,
      customer: json['customer'] != null
          ? CustomerModel.fromJson(json['customer'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'customer_id': customerId,
      'driver_id': driverId,
      'address_id': addressId,
      'total_amount': totalAmount,
      'delivery_fee': deliveryFee,
      'order_status': orderStatus,
      'order_date': orderDate,
      'delivery_date': deliveryDate,
      'delivery_time': deliveryTime,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'note': note,
      'immediate': immediate,
      'rating': rating,
      'review': review,
      'items': items.map((e) => e.toJson()).toList(),
      'address': address?.toJson(),
    };
  }

  OrderModel copyWith({
    int? orderId,
    int? customerId,
    int? driverId,
    int? addressId,
    String? totalAmount,
    String? deliveryFee,
    String? orderStatus,
    String? orderDate,
    String? deliveryDate,
    String? deliveryTime,
    String? paymentMethod,
    String? paymentStatus,
    String? note,
    int? immediate,
    String? rating,
    String? review,
    List<OrderItemModel>? items,
    AddressModel? address,
    CustomerModel? customer,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      customerId: customerId ?? this.customerId,
      driverId: driverId ?? this.driverId,
      addressId: addressId ?? this.addressId,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      orderStatus: orderStatus ?? this.orderStatus,
      orderDate: orderDate ?? this.orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      note: note ?? this.note,
      immediate: immediate ?? this.immediate,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      items: items ?? this.items,
      address: address ?? this.address,
      customer: customer ?? this.customer,
    );
  }
}

class OrderItemModel {
  final int orderItemId;
  final int orderId;
  final int productId;
  final int quantity;
  final String unitPrice;
  final String subtotal;
  final String? productNotes;
  final ProductModel product;

  OrderItemModel({
    required this.orderItemId,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    this.productNotes,
    required this.product,
  });

  Map<String, dynamic> toJson() => {
    'order_item_id': orderItemId,
    'order_id': orderId,
    'product_id': productId,
    'quantity': quantity,
    'unit_price': unitPrice,
    'subtotal': subtotal,
    'product_notes': productNotes,
    'product': product.toJson(),
  };

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      orderItemId: json['order_item_id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      unitPrice: json['unit_price'] ?? '0',
      subtotal: json['subtotal'] ?? '0',
      productNotes: json['product_notes'],
      product: ProductModel.fromJson(json['product'] ?? {}),
    );
  }
}
