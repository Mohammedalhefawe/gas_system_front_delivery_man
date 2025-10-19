// import 'package:flutter/material.dart';
// import 'package:gas_delivery_app/data/models/notification_model.dart';
// import 'package:gas_delivery_app/presentation/pages/notifications_page/widgets/notification_card_widget.dart';
// import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';

// class NotificationListWidget extends StatelessWidget {
//   const NotificationListWidget({
//     super.key,
//     required this.notifications,
//     required this.onNotificationTap,
//   });

//   final List<NotificationModel> notifications;
//   final Function(NotificationModel) onNotificationTap;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       padding: EdgeInsets.symmetric(vertical: AppSize.sHeight * 0.01),
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: notifications.length,
//       separatorBuilder: (context, index) => const SizedBox(height: 8),
//       itemBuilder: (context, index) {
//         final notification = notifications[index];
//         return NotificationCardWidget(
//           notification: notification,
//           onTap: () => onNotificationTap(notification),
//         );
//       },
//     );
//   }
// }
