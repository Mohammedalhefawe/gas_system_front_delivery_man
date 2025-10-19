// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
// import 'package:gas_delivery_app/presentation/pages/notifications_page/notifications_page_controller.dart';
// import 'package:gas_delivery_app/presentation/pages/notifications_page/widgets/notification_card_widget.dart';
// import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
// import 'package:gas_delivery_app/presentation/util/widgets/empty_screen_widget.dart';
// import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';

// class ContentNotificationsPageWidget
//     extends GetView<NotificationsPageController> {
//   const ContentNotificationsPageWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       if (controller.loadingNotificationsState.value == LoadingState.loading) {
//         return const SliverToBoxAdapter(
//           child: Center(
//             child: Padding(
//               padding: EdgeInsets.all(20),
//               child: CircularProgressIndicator(),
//             ),
//           ),
//         );
//       }

//       if (controller.loadingNotificationsState.value == LoadingState.hasError) {
//         return SliverToBoxAdapter(
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.error_outline,
//                     size: 64,
//                     color: ColorManager.colorError,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     "errorLoadingNotifications".tr,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => controller.refreshNotifications(),
//                     child: Text("retryButton".tr),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }

//       if (controller.loadingNotificationsState.value ==
//           LoadingState.doneWithNoData) {
//         return SliverToBoxAdapter(
//           child: EmptyScreenWidget(
//             image: Assets.icons.notificationIcon.path,
//             title: "noNotifications".tr,
//             subtitle: "noNotificationsDescription".tr,
//             isSvg: true,
//           ),
//         );
//       }

//       return SliverList.builder(
//         itemCount:
//             controller.notifications.length +
//             (controller.hasMorePages.value ? 1 : 0),
//         itemBuilder: (context, index) {
//           if (index == controller.notifications.length) {
//             return Obx(() {
//               if (controller.loadingMoreNotificationsState.value ==
//                   LoadingState.loading) {
//                 return const Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               }
//               return const SizedBox.shrink();
//             });
//           }

//           final notification = controller.notifications[index];
//           return NotificationCardWidget(
//             notification: notification,
//             onTap: () => controller.onNotificationTap(notification),
//           );
//         },
//       );
//     });
//   }
// }
