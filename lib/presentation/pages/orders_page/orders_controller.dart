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
  final currentTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDriverOrders();
    fetchNewOrders();
    // Listen to tab changes
    ever(currentTab, (_) => _onTabChanged());
  }

  void _onTabChanged() {
    // Optionally refresh data when tab changes
    if (currentTab.value == 0 &&
        myOrdersLoadingState.value != LoadingState.loading) {
      fetchDriverOrders();
    } else if (currentTab.value == 1 &&
        newOrdersLoadingState.value != LoadingState.loading) {
      fetchNewOrders();
    }
  }

  Future<void> fetchDriverOrders() async {
    myOrdersLoadingState.value = LoadingState.loading;
    final response = await orderRepo.getOrders();
    if (!response.success) {
      myOrdersLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    myOrders.value = response.data ?? [];
    myOrdersLoadingState.value = myOrders.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }

  Future<void> fetchNewOrders() async {
    newOrdersLoadingState.value = LoadingState.loading;
    final response = await orderRepo.getNewOrders();
    if (!response.success) {
      newOrdersLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    newOrders.value = response.data ?? [];
    newOrdersLoadingState.value = newOrders.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
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
    // Refresh both lists to reflect status change
    await fetchDriverOrders();
    await fetchNewOrders();
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
              // Refresh both lists to reflect status change
              await fetchDriverOrders();
              await fetchNewOrders();
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
    // Refresh both lists to reflect status change
    await fetchDriverOrders();
    await fetchNewOrders();
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
    // Refresh both lists to reflect status change
    await fetchDriverOrders();
    await fetchNewOrders();
    CustomToasts(
      message: response.successMessage ?? 'OrderCompleted'.tr,
      type: CustomToastType.success,
    ).show();
  }
}
