import 'package:flutter/material.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:get/get.dart';

enum OrderStatus {
  pending(1),
  accepted(2),
  rejected(3),
  onTheWay(4),
  completed(5),
  cancelled(6);

  const OrderStatus(this.value);
  final int value;

  static OrderStatus fromValue(int value) {
    return OrderStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => OrderStatus.pending,
    );
  }

  String get translationKey {
    switch (this) {
      case OrderStatus.pending:
        return "pending";
      case OrderStatus.accepted:
        return "accepted";
      case OrderStatus.rejected:
        return "rejected";
      case OrderStatus.onTheWay:
        return "on_the_way";
      case OrderStatus.completed:
        return "completed";
      case OrderStatus.cancelled:
        return "cancelled";
    }
  }

  String get localizedTitle {
    return translationKey.tr;
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.pending:
        return Icons.access_time;
      case OrderStatus.accepted:
        return Icons.thumb_up_outlined;
      case OrderStatus.rejected:
        return Icons.block;
      case OrderStatus.onTheWay:
        return Icons.delivery_dining;
      case OrderStatus.completed:
        return Icons.check_circle_outline;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return ColorManager.colorPrimary;
      case OrderStatus.accepted:
        return Colors.blue;
      case OrderStatus.rejected:
        return Colors.red;
      case OrderStatus.onTheWay:
        return Colors.orange;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.redAccent;
    }
  }

  Color get backgroundColor => color.withValues(alpha: 0.1);
}
