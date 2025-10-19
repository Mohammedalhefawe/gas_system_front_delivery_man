import 'dart:convert';

class AddressModel {
  final int addressId;
  final int customerId;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final String? floorNumber;
  final String? addressName;
  final String? details;
  final String? createdAt;
  final String? updatedAt;

  AddressModel({
    required this.addressId,
    required this.customerId,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    this.floorNumber,
    this.addressName,
    this.details,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() =>
      {
        'address': address,
        'city': city,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'floor_number': floorNumber,
        'address_name': addressName,
        'details': details,
      }..removeWhere(
        (key, value) => value == null,
      ); // Remove null values to avoid sending null fields

  String toRawJson() => json.encode(toJson());

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['address_id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      latitude: double.tryParse(json['latitude']?.toString() ?? '0.0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0.0') ?? 0.0,
      floorNumber: json['floor_number']?.toString(), // Ensure string type
      addressName: json['address_name']?.toString(), // Ensure string type
      details: json['details']?.toString(), // Ensure string type
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  factory AddressModel.fromRawJson(String str) =>
      AddressModel.fromJson(json.decode(str));

  factory AddressModel.empty() => AddressModel(
    addressId: 0,
    customerId: 0,
    address: '',
    city: '',
    latitude: 0.0,
    longitude: 0.0,
  );

  AddressModel copyWith({
    int? addressId,
    int? customerId,
    String? address,
    String? city,
    double? latitude,
    double? longitude,
    String? floorNumber,
    String? addressName,
    String? details,
    String? createdAt,
    String? updatedAt,
  }) {
    return AddressModel(
      addressId: addressId ?? this.addressId,
      customerId: customerId ?? this.customerId,
      address: address ?? this.address,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      floorNumber: floorNumber ?? this.floorNumber,
      addressName: addressName ?? this.addressName,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
