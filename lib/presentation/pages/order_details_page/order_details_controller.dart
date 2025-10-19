import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/order_model.dart';
import 'package:gas_delivery_app/data/repos/orders_repo.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';

class DriverOrderDetailsController extends GetxController {
  final OrderRepo orderRepo = Get.find<OrderRepo>();
  late int orderId;
  final order = Rxn<OrderModel>();
  final loadingState = LoadingState.doneWithData.obs;

  @override
  void onInit() {
    super.onInit();
    order.value = Get.arguments;
    orderId = order.value!.orderId;
  }

  Future<void> acceptOrder(BuildContext context) async {
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
    order.value!.copyWith(orderStatus: 'accepted');
    loadingState.value = LoadingState.doneWithData;
    CustomToasts(
      message: response.successMessage ?? 'OrderAccepted'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future<void> rejectOrder(BuildContext context) async {
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
              Get.back();
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

  Future<void> startOrder(BuildContext context) async {
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
    order.value!.copyWith(orderStatus: 'on_the_way');

    loadingState.value = LoadingState.doneWithData;
    CustomToasts(
      message: response.successMessage ?? 'OrderStarted'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future<void> completeOrder(BuildContext context) async {
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
    order.value!.copyWith(orderStatus: 'completed');

    loadingState.value = LoadingState.doneWithData;
    CustomToasts(
      message: response.successMessage ?? 'OrderCompleted'.tr,
      type: CustomToastType.success,
    ).show();
  }
}
