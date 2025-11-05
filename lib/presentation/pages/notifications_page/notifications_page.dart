import 'package:flutter/material.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/presentation/pages/notifications_page/widgtes/content_data_notification_page_widget.dart';
import 'package:gas_delivery_app/presentation/pages/notifications_page/widgtes/content_error_notification_page_widget.dart';
import 'package:gas_delivery_app/presentation/pages/notifications_page/widgtes/shimmer_notification_page_widget.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';
import 'notifications_page_controller.dart';

class NotificationsScreen extends GetView<NotificationsPageController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppBar(title: 'Notifications'.tr, backIcon: true),
      body: Obx(() {
        if (controller.loadingNotificationsState.value ==
            LoadingState.loading) {
          return ShimmerNotificationPageWidget();
        }
        if (controller.loadingNotificationsState.value ==
            LoadingState.hasError) {
          return ContentErrorNotificationPageWidget();
        }
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off,
                  size: AppSize.s60,
                  color: ColorManager.colorDoveGray600,
                ),
                const SizedBox(height: AppSize.s16),
                Text(
                  'NoNotifications'.tr,
                  style: TextStyle(
                    fontSize: FontSize.s18,
                    color: ColorManager.colorDoveGray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
        return ContentDataNotificationPageWidget();
      }),
    );
  }
}
