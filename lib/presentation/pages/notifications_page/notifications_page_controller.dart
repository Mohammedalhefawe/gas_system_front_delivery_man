import 'package:flutter/widgets.dart';
import 'package:gas_delivery_app/data/repos/orders_repo.dart';
import 'package:gas_delivery_app/presentation/pages/order_details_page/order_details_page.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/notification_model.dart';
import 'package:gas_delivery_app/data/repos/notification_repo.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';

class NotificationsPageController extends GetxController {
  final NotificationRepo notificationsRepo = Get.find<NotificationRepo>();
  final OrderRepo orderRepo = Get.find<OrderRepo>();
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final loadingNotificationsState = LoadingState.idle.obs;
  final loadingMoreNotificationsState = LoadingState.idle.obs;
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final hasMorePages = false.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    fetchNotifications(page: 1);
    scrollController.addListener(scrollListener);
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.8) {
      loadMoreNotifications();
    }
  }

  Future<void> fetchNotifications({
    required int page,
    int pageSize = 10,
  }) async {
    if (loadingNotificationsState.value == LoadingState.loading) return;
    loadingNotificationsState.value = LoadingState.loading;

    final response = await notificationsRepo.getNotifications(
      page: page,
      pageSize: pageSize,
    );

    if (!response.success || response.data == null) {
      loadingNotificationsState.value = LoadingState.hasError;
      CustomToasts(
        message:
            response.networkFailure?.message ??
            "Failed to load notifications".tr,
        type: CustomToastType.error,
      ).show();
      return;
    }

    if (page == 1) {
      notifications.clear();
    }
    notifications.addAll(response.data!.data);
    currentPage.value = response.data!.currentPage;
    lastPage.value = response.data!.lastPage;
    hasMorePages.value = currentPage.value < lastPage.value;

    loadingNotificationsState.value = notifications.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }

  Future<void> loadMoreNotifications() async {
    if (loadingMoreNotificationsState.value == LoadingState.loading ||
        !hasMorePages.value) {
      return;
    }

    loadingMoreNotificationsState.value = LoadingState.loading;

    final nextPage = currentPage.value + 1;
    final response = await notificationsRepo.getNotifications(page: nextPage);

    if (!response.success || response.data == null) {
      loadingMoreNotificationsState.value = LoadingState.hasError;
      return;
    }

    notifications.addAll(response.data!.data);
    currentPage.value = response.data!.currentPage;
    lastPage.value = response.data!.lastPage;
    hasMorePages.value = currentPage.value < lastPage.value;

    loadingMoreNotificationsState.value = LoadingState.doneWithData;
  }

  Future<void> refreshNotifications() async {
    notifications.clear();
    currentPage.value = 1;
    lastPage.value = 1;
    hasMorePages.value = false;
    loadingNotificationsState.value = LoadingState.idle;
    loadingMoreNotificationsState.value = LoadingState.idle;
    await fetchNotifications(page: 1);
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    final response = await notificationsRepo.markNotificationAsRead(
      notificationId,
    );

    if (!response.success) {
      CustomToasts(
        message:
            response.networkFailure?.message ??
            "Failed to mark notification as read".tr,
        type: CustomToastType.error,
      ).show();
      return;
    }

    // Update the notification's isRead status locally
    final index = notifications.indexWhere(
      (n) => n.notificationId == notificationId,
    );
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      notifications.refresh(); // Trigger reactive update
      Get.to(
        () => DriverOrderDetailsPage(),
        arguments: notifications[index].relatedOrderId,
      );
    }
  }
}
