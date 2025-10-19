// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gas_delivery_app/presentation/pages/notifications_page/notifications_page_controller.dart';
// import 'package:gas_delivery_app/presentation/pages/notifications_page/widgets/content_notifications_page_widget.dart';
// import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
// import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';

// class NotificationsPage extends GetView<NotificationsPageController> {
//   const NotificationsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.put(NotificationsPageController());
//     return Scaffold(
//       backgroundColor: ColorManager.colorBackground,
//       appBar: AppBar(
//         backgroundColor: ColorManager.colorBackground,
//         elevation: 0,
//         title: Text(
//           "notifications".tr,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () => controller.refreshNotifications(),
//         child: CustomScrollView(
//           controller: controller.scrollController,
//           slivers: [
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: AppSize.sWidth * 0.05,
//                   vertical: AppSize.sHeight * 0.02,
//                 ),
//                 child: Text(
//                   "browseRecentNotifications".tr,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: ColorManager.colorGrey2,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//             ContentNotificationsPageWidget(),
//           ],
//         ),
//       ),
//     );
//   }
// }
