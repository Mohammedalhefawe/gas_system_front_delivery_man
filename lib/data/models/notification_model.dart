import 'package:gas_delivery_app/core/app_config/app_translation.dart';

class NotificationData {
  final int? orderId;
  final String? payloadRoute;
  final String? titleAr;
  final String? bodyAr;

  NotificationData({
    this.orderId,
    this.payloadRoute,
    this.titleAr,
    this.bodyAr,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      orderId: json['order_id'],
      payloadRoute: json['payload_route'],
      titleAr: json['title_ar'],
      bodyAr: json['body_ar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'payload_route': payloadRoute,
      'title_ar': titleAr,
      'body_ar': bodyAr,
    };
  }

  NotificationData copyWith({
    int? orderId,
    String? payloadRoute,
    String? titleAr,
    String? bodyAr,
  }) {
    return NotificationData(
      orderId: orderId ?? this.orderId,
      payloadRoute: payloadRoute ?? this.payloadRoute,
      titleAr: titleAr ?? this.titleAr,
      bodyAr: bodyAr ?? this.bodyAr,
    );
  }
}

class NotificationModel {
  final int notificationId;
  final int userId;
  final String title;
  final String message;
  final String? notificationType;
  final bool isRead;
  final int? relatedOrderId;
  final String? actionUrl;
  final NotificationData? data;
  final DateTime? sentAt;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.title,
    required this.message,
    this.notificationType,
    required this.isRead,
    this.relatedOrderId,
    this.actionUrl,
    this.data,
    this.sentAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notification_id'],
      userId: json['user_id'],
      title: AppTranslations.isArabic && json['data']!['title_ar'] != null
          ? json['data']['title_ar']
          : json['title'],
      message: AppTranslations.isArabic && json['data']!['body_ar'] != null
          ? json['data']['body_ar']
          : json['message'],
      notificationType: json['notification_type'],
      isRead: json['is_read'] ?? false,
      relatedOrderId: json['related_order_id'],
      actionUrl: json['action_url'],
      data: json['data'] != null
          ? NotificationData.fromJson(Map<String, dynamic>.from(json['data']))
          : null,
      sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_id': notificationId,
      'user_id': userId,
      'title': title,
      'message': message,
      'notification_type': notificationType,
      'is_read': isRead,
      'related_order_id': relatedOrderId,
      'action_url': actionUrl,
      'data': data?.toJson(),
      'sent_at': sentAt?.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    int? notificationId,
    int? userId,
    String? title,
    String? message,
    String? notificationType,
    bool? isRead,
    int? relatedOrderId,
    String? actionUrl,
    NotificationData? data,
    DateTime? sentAt,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      notificationType: notificationType ?? this.notificationType,
      isRead: isRead ?? this.isRead,
      relatedOrderId: relatedOrderId ?? this.relatedOrderId,
      actionUrl: actionUrl ?? this.actionUrl,
      data: data ?? this.data,
      sentAt: sentAt ?? this.sentAt,
    );
  }
}
