import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';

enum NotificationType {
  system(1),
  message(2),
  follow(3),
  newAd(4);

  const NotificationType(this.value);
  final int value;

  static NotificationType fromValue(int value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationType.system,
    );
  }

  String get translationKey {
    switch (this) {
      case NotificationType.system:
        return "systemNotification";
      case NotificationType.message:
        return "newMessage";
      case NotificationType.follow:
        return "newFollower";
      case NotificationType.newAd:
        return "newAd";
    }
  }

  String get localizedTitle {
    return translationKey.tr;
  }

  IconData get icon {
    switch (this) {
      case NotificationType.system:
        return Icons.info_outline;
      case NotificationType.message:
        return Icons.message_outlined;
      case NotificationType.follow:
        return Icons.person_add_outlined;
      case NotificationType.newAd:
        return Icons.shopping_bag_outlined;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.system:
        return ColorManager.colorPrimary;
      case NotificationType.message:
        return ColorManager.colorSecondary;
      case NotificationType.follow:
        return Colors.green;
      case NotificationType.newAd:
        return Colors.orange;
    }
  }

  Color get backgroundColor {
    return color.withValues(alpha: 0.1);
  }
}
