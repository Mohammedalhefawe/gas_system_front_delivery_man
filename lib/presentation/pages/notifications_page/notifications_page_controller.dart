// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:gas_delivery_app/data/dto/get_notifications_dto.dart';
// import 'package:gas_delivery_app/data/models/notification_model.dart';
// import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';
// import '../../../data/repos/notification_repo.dart';

// class NotificationsPageController extends GetxController {
//   final NotificationRepo notificationsRepo = Get.find<NotificationRepo>();

//   RxList<NotificationModel> notifications = <NotificationModel>[].obs;

//   final currentPage = 1.obs;
//   final lastPage = 1.obs;
//   final hasMorePages = false.obs;

//   final loadingNotificationsState = LoadingState.idle.obs;
//   final loadingMoreNotificationsState = LoadingState.idle.obs;

//   final ScrollController scrollController = ScrollController();

//   @override
//   void onInit() {
//     getNotifications(page: 1);
//     scrollController.addListener(scrollListener);
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     scrollController.dispose();
//     super.onClose();
//   }

//   Future<void> refreshNotifications() async {
//     notifications.clear();
//     currentPage.value = 1;
//     lastPage.value = 1;
//     hasMorePages.value = false;
//     loadingNotificationsState.value = LoadingState.idle;
//     loadingMoreNotificationsState.value = LoadingState.idle;
//     await getNotifications(page: 1);
//   }

//   Future<void> getNotifications({required int page, int pageSize = 10}) async {
//     if (loadingNotificationsState.value == LoadingState.loading) return;
//     loadingNotificationsState.value = LoadingState.loading;

//     final response = await notificationsRepo.getNotifications(
//       GetNotificationsDto(page: page, perPage: pageSize),
//     );

//     if (!response.success || response.data == null) {
//       loadingNotificationsState.value = LoadingState.hasError;
//       CustomToasts(
//         message: response.networkFailure?.message ?? "حدث خطأ ما".tr,
//         type: CustomToastType.error,
//       ).show();
//       return;
//     }

//     if (page == 1) {
//       notifications.clear();
//     }
//     notifications.addAll(response.data!.data);
//     currentPage.value = response.data!.currentPage;
//     lastPage.value = response.data!.lastPage;
//     hasMorePages.value = currentPage.value < lastPage.value;

//     loadingNotificationsState.value = notifications.isEmpty
//         ? LoadingState.doneWithNoData
//         : LoadingState.doneWithData;
//   }

//   Future<void> loadMoreNotifications() async {
//     if (loadingMoreNotificationsState.value == LoadingState.loading ||
//         !hasMorePages.value) {
//       return;
//     }

//     loadingMoreNotificationsState.value = LoadingState.loading;

//     final nextPage = currentPage.value + 1;
//     final response = await notificationsRepo.getNotifications(
//       GetNotificationsDto(page: nextPage, perPage: 10),
//     );

//     if (!response.success || response.data == null) {
//       loadingMoreNotificationsState.value = LoadingState.hasError;
//       CustomToasts(
//         message: response.networkFailure?.message ?? "حدث خطأ ما".tr,
//         type: CustomToastType.error,
//       ).show();
//       return;
//     }

//     notifications.addAll(response.data!.data);
//     currentPage.value = response.data!.currentPage;
//     lastPage.value = response.data!.lastPage;
//     hasMorePages.value = currentPage.value < lastPage.value;

//     loadingMoreNotificationsState.value = LoadingState.doneWithData;
//   }

//   void scrollListener() {
//     if (scrollController.position.pixels >=
//         scrollController.position.maxScrollExtent * 0.8) {
//       loadMoreNotifications();
//     }
//   }

//   void onNotificationTap(NotificationModel notification) {}
// }
