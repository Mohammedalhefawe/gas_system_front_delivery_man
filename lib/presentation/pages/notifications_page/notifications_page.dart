import 'package:flutter/material.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_delivery_app/core/app_config/app_translation.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/notification_model.dart';
import 'package:gas_delivery_app/presentation/pages/order_details_page/order_details_page.dart'
    show DriverOrderDetailsPage;
import 'package:gas_delivery_app/presentation/util/date_converter.dart';
import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
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
          return _buildShimmerList();
        }
        if (controller.loadingNotificationsState.value ==
            LoadingState.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: AppSize.s60,
                  color: ColorManager.colorDoveGray600,
                ),
                const SizedBox(height: AppSize.s16),
                Text(
                  'FailedToLoadNotifications'.tr,
                  style: TextStyle(
                    fontSize: FontSize.s18,
                    color: ColorManager.colorDoveGray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSize.s12),
                GestureDetector(
                  onTap: controller.refreshNotifications,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.refresh,
                        color: ColorManager.colorDoveGray600,
                      ),
                      SizedBox(width: AppSize.s8),
                      Text(
                        'TryAgain'.tr,
                        style: TextStyle(
                          fontSize: FontSize.s16,
                          color: ColorManager.colorDoveGray600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
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
        return Column(
          children: [
            const SizedBox(height: AppSize.s8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshNotifications,
                color: ColorManager.colorPrimary,
                backgroundColor: ColorManager.colorWhite,
                child: CustomScrollView(
                  controller: controller.scrollController,
                  slivers: [
                    SliverList.separated(
                      itemCount: controller.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = controller.notifications[index];
                        return _buildNotificationItem(notification, context);
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSize.s8),
                    ),
                    if (controller.loadingMoreNotificationsState.value ==
                        LoadingState.loading)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSize.s10,
                          ),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                    SliverToBoxAdapter(child: SizedBox(height: AppSize.s8)),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildNotificationItem(
    NotificationModel notification,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        if (!notification.isRead) {
          controller.markNotificationAsRead(notification.notificationId);
        } else {
          Get.to(
            () => DriverOrderDetailsPage(),
            arguments: notification.relatedOrderId,
          );
        }
      },
      child: Container(
        color: notification.isRead
            ? ColorManager.colorWhite.withValues(alpha: 0.5)
            : ColorManager.colorWhite,
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppPadding.p4),
                  decoration: BoxDecoration(
                    color: ColorManager.colorPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSize.s8),
                  ),
                  child: Assets.icons.notificationIcon.svg(
                    width: AppSize.s18,
                    height: AppSize.s18,
                    colorFilter: const ColorFilter.mode(
                      ColorManager.colorPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.s12),
                Expanded(
                  child: Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: FontSize.s18,
                      fontWeight: FontWeight.w700,
                      color: ColorManager.colorPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.s12),
            Text(
              notification.message,
              style: TextStyle(
                fontSize: FontSize.s16,
                fontWeight: FontWeight.w500,
                color: ColorManager.colorFontPrimary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSize.s12),
            Align(
              alignment: AppTranslations.isArabic
                  ? Alignment.topLeft
                  : Alignment.topRight,
              child: Text(
                DateConverter.dayWithTimeUTCToString(notification.sentAt!),
                style: TextStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.colorDoveGray600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Column(
      children: [
        const SizedBox(height: AppSize.s8),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverList.separated(
                itemCount: 3,
                itemBuilder: (context, index) =>
                    _buildShimmerNotificationItem(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSize.s8),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerNotificationItem() {
    return Shimmer.fromColors(
      baseColor: ColorManager.colorGrey2.withValues(alpha: 0.3),
      highlightColor: ColorManager.colorGrey2.withValues(alpha: 0.1),
      child: Container(
        color: ColorManager.colorWhite,
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: AppSize.s26,
                  height: AppSize.s26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSize.s8),
                  ),
                ),
                const SizedBox(width: AppSize.s12),
                Container(width: 120, height: 18, color: Colors.white),
                const Spacer(),
                Container(
                  width: AppSize.s24,
                  height: AppSize.s24,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSize.s12),
            Container(width: double.infinity, height: 16, color: Colors.white),
            const SizedBox(height: AppSize.s16),
            Container(height: 1, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
