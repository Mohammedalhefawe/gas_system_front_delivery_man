import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/order_model.dart';
import 'package:gas_delivery_app/data/repos/orders_repo.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';

class DriverOrdersController extends GetxController {
  final OrderRepo orderRepo = Get.find<OrderRepo>();
  final myOrders = <OrderModel>[].obs;
  final newOrders = <OrderModel>[].obs;
  final myOrdersLoadingState = LoadingState.idle.obs;
  final newOrdersLoadingState = LoadingState.idle.obs;
  final myOrdersLoadingMoreState = LoadingState.idle.obs;
  final newOrdersLoadingMoreState = LoadingState.idle.obs;
  final myOrdersCurrentPage = 1.obs;
  final myOrdersLastPage = 1.obs;
  final myOrdersHasMorePages = false.obs;
  final newOrdersCurrentPage = 1.obs;
  final newOrdersLastPage = 1.obs;
  final newOrdersHasMorePages = false.obs;
  final currentTab = 0.obs;
  final ScrollController myOrdersScrollController = ScrollController();
  final ScrollController newOrdersScrollController = ScrollController();
  @override
  void onInit() {
    super.onInit();
    fetchDriverOrders(page: 1);
    fetchNewOrders(page: 1);
    myOrdersScrollController.addListener(myOrdersScrollListener);
    newOrdersScrollController.addListener(newOrdersScrollListener);
    ever(currentTab, (_) => _onTabChanged());
  }

  @override
  void onClose() {
    myOrdersScrollController.dispose();
    newOrdersScrollController.dispose();
    super.onClose();
  }

  void myOrdersScrollListener() {
    if (myOrdersScrollController.position.pixels >=
        myOrdersScrollController.position.maxScrollExtent * 0.8) {
      loadMoreDriverOrders();
    }
  }

  void newOrdersScrollListener() {
    if (newOrdersScrollController.position.pixels >=
        newOrdersScrollController.position.maxScrollExtent * 0.8) {
      loadMoreNewOrders();
    }
  }

  void _onTabChanged() {
    if (currentTab.value == 0 &&
        myOrdersLoadingState.value != LoadingState.loading) {
      fetchDriverOrders(page: 1);
    } else if (currentTab.value == 1 &&
        newOrdersLoadingState.value != LoadingState.loading) {
      fetchNewOrders(page: 1);
    }
  }

  Future<void> fetchDriverOrders({required int page, int pageSize = 10}) async {
    if (myOrdersLoadingState.value == LoadingState.loading) return;
    myOrdersLoadingState.value = LoadingState.loading;

    final response = await orderRepo.getOrders(page: page, pageSize: pageSize);
    if (!response.success || response.data == null) {
      myOrdersLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }

    if (page == 1) {
      myOrders.clear();
    }
    myOrders.addAll(response.data!.data);
    myOrdersCurrentPage.value = response.data!.currentPage;
    myOrdersLastPage.value = response.data!.lastPage;
    myOrdersHasMorePages.value =
        myOrdersCurrentPage.value < myOrdersLastPage.value;

    myOrdersLoadingState.value = myOrders.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }

  Future<void> fetchNewOrders({required int page, int pageSize = 10}) async {
    if (newOrdersLoadingState.value == LoadingState.loading) return;
    newOrdersLoadingState.value = LoadingState.loading;

    final response = await orderRepo.getNewOrders(
      page: page,
      pageSize: pageSize,
    );
    if (!response.success || response.data == null) {
      newOrdersLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }

    if (page == 1) {
      newOrders.clear();
    }
    newOrders.addAll(response.data!.data);
    newOrdersCurrentPage.value = response.data!.currentPage;
    newOrdersLastPage.value = response.data!.lastPage;
    newOrdersHasMorePages.value =
        newOrdersCurrentPage.value < newOrdersLastPage.value;

    newOrdersLoadingState.value = newOrders.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }

  Future<void> loadMoreDriverOrders() async {
    if (myOrdersLoadingMoreState.value == LoadingState.loading ||
        !myOrdersHasMorePages.value) {
      return;
    }

    myOrdersLoadingMoreState.value = LoadingState.loading;

    final nextPage = myOrdersCurrentPage.value + 1;
    final response = await orderRepo.getOrders(page: nextPage);

    if (!response.success || response.data == null) {
      myOrdersLoadingMoreState.value = LoadingState.hasError;
      return;
    }

    myOrders.addAll(response.data!.data);
    myOrdersCurrentPage.value = response.data!.currentPage;
    myOrdersLastPage.value = response.data!.lastPage;
    myOrdersHasMorePages.value =
        myOrdersCurrentPage.value < myOrdersLastPage.value;

    myOrdersLoadingMoreState.value = LoadingState.doneWithData;
  }

  Future<void> loadMoreNewOrders() async {
    if (newOrdersLoadingMoreState.value == LoadingState.loading ||
        !newOrdersHasMorePages.value) {
      return;
    }

    newOrdersLoadingMoreState.value = LoadingState.loading;

    final nextPage = newOrdersCurrentPage.value + 1;
    final response = await orderRepo.getNewOrders(page: nextPage);

    if (!response.success || response.data == null) {
      newOrdersLoadingMoreState.value = LoadingState.hasError;
      return;
    }

    newOrders.addAll(response.data!.data);
    newOrdersCurrentPage.value = response.data!.currentPage;
    newOrdersLastPage.value = response.data!.lastPage;
    newOrdersHasMorePages.value =
        newOrdersCurrentPage.value < newOrdersLastPage.value;

    newOrdersLoadingMoreState.value = LoadingState.doneWithData;
  }

  Future<void> refreshOrders() async {
    if (currentTab.value == 0) {
      myOrders.clear();
      myOrdersCurrentPage.value = 1;
      myOrdersLastPage.value = 1;
      myOrdersHasMorePages.value = false;
      myOrdersLoadingState.value = LoadingState.idle;
      myOrdersLoadingMoreState.value = LoadingState.idle;
      await fetchDriverOrders(page: 1);
    } else {
      newOrders.clear();
      newOrdersCurrentPage.value = 1;
      newOrdersLastPage.value = 1;
      newOrdersHasMorePages.value = false;
      newOrdersLoadingState.value = LoadingState.idle;
      newOrdersLoadingMoreState.value = LoadingState.idle;
      await fetchNewOrders(page: 1);
    }
  }

  Future<void> acceptOrder(BuildContext context, int orderId) async {
    final loadingState = currentTab.value == 0
        ? myOrdersLoadingState
        : newOrdersLoadingState;
    loadingState.value = LoadingState.loading;
    final response = await orderRepo.acceptOrder(orderId);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    await refreshOrders();
    CustomToasts(
      message: response.successMessage ?? 'OrderAccepted'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future<void> rejectOrder(BuildContext context, int orderId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        title: Text(
          'RejectOrder'.tr,
          style: TextStyle(
            fontSize: FontSize.s16,
            fontWeight: FontWeight.w600,
            color: ColorManager.colorFontPrimary,
          ),
        ),
        content: Text(
          'RejectOrderPrompt'.tr,
          style: TextStyle(
            fontSize: FontSize.s14,
            color: ColorManager.colorDoveGray600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No'.tr,
              style: TextStyle(
                fontSize: FontSize.s14,
                color: ColorManager.colorDoveGray600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final loadingState = currentTab.value == 0
                  ? myOrdersLoadingState
                  : newOrdersLoadingState;
              loadingState.value = LoadingState.loading;
              final response = await orderRepo.rejectOrder(orderId);
              if (!response.success) {
                loadingState.value = LoadingState.hasError;
                CustomToasts(
                  message: response.getErrorMessage(),
                  type: CustomToastType.error,
                ).show();
                return;
              }
              await refreshOrders();
              CustomToasts(
                message: response.successMessage ?? 'OrderRejected'.tr,
                type: CustomToastType.success,
              ).show();
            },
            child: Text(
              'Yes'.tr,
              style: TextStyle(
                fontSize: FontSize.s14,
                color: ColorManager.colorPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> startOrder(BuildContext context, int orderId) async {
    final loadingState = currentTab.value == 0
        ? myOrdersLoadingState
        : newOrdersLoadingState;
    loadingState.value = LoadingState.loading;
    final response = await orderRepo.startOrder(orderId);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    await refreshOrders();
    CustomToasts(
      message: response.successMessage ?? 'OrderStarted'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future<void> completeOrder(BuildContext context, int orderId) async {
    final loadingState = currentTab.value == 0
        ? myOrdersLoadingState
        : newOrdersLoadingState;
    loadingState.value = LoadingState.loading;
    final response = await orderRepo.completeOrder(orderId);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    await refreshOrders();
    CustomToasts(
      message: response.successMessage ?? 'OrderCompleted'.tr,
      type: CustomToastType.success,
    ).show();
  }
}
