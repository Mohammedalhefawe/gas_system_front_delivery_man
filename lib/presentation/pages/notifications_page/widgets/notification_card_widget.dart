// import 'package:flutter/material.dart';
// import 'package:gas_delivery_app/data/models/notification_model.dart';
// import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
// import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
// import 'package:gas_delivery_app/presentation/util/date_converter.dart';

// class NotificationCardWidget extends StatelessWidget {
//   const NotificationCardWidget({
//     super.key,
//     required this.notification,
//     required this.onTap,
//   });

//   final NotificationModel notification;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     final notificationType = notification.notificationType;

//     return Container(
//       margin: EdgeInsets.symmetric(
//         horizontal: AppSize.sWidth * 0.05,
//         vertical: AppSize.sHeight * 0.01,
//       ),
//       child: Card(
//         elevation: 2,
//         color: ColorManager.colorWhite,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(12),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildNotificationIcon(notificationType),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             notification.localizedTitle,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: ColorManager.colorFontPrimary,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             notification.localizedBody,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               color: ColorManager.colorFontSecondary,
//                               height: 1.4,
//                             ),
//                             maxLines: 3,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (!notification.delivered)
//                       Container(
//                         width: 8,
//                         height: 8,
//                         decoration: const BoxDecoration(
//                           color: ColorManager.colorPrimary,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildNotificationType(notificationType),
//                     Text(
//                       _formatNotificationDate(notification.createdAt),
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: ColorManager.colorGrey2,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNotificationIcon(notificationType) {
//     return Container(
//       width: 40,
//       height: 40,
//       decoration: BoxDecoration(
//         color: notificationType.backgroundColor,
//         shape: BoxShape.circle,
//       ),
//       child: Icon(
//         notificationType.icon,
//         color: notificationType.color,
//         size: 20,
//       ),
//     );
//   }

//   Widget _buildNotificationType(notificationType) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: notificationType.backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         notificationType.localizedTitle,
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           color: notificationType.color,
//         ),
//       ),
//     );
//   }

//   String _formatNotificationDate(String dateString) {
//     try {
//       final DateTime? date = DateConverter.stringToDate(dateString);
//       if (date == null) return "";

//       return DateConverter.timeDifference(date, DateTime.now());
//     } catch (e) {
//       return "";
//     }
//   }
// }
