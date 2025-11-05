import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/enums/order_status_enum.dart';
import 'package:gas_delivery_app/data/models/address_model.dart';
import 'package:gas_delivery_app/data/models/order_model.dart';
import 'package:gas_delivery_app/data/repos/orders_repo.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverOrderDetailsController extends GetxController {
  final OrderRepo orderRepo = Get.find<OrderRepo>();
  late int orderId;
  final Rxn<OrderModel> order = Rxn<OrderModel>();
  final loadingState = LoadingState.doneWithData.obs;

  @override
  void onInit() {
    super.onInit();
    // order.value = Get.arguments;
    // orderId = order.value!.orderId;
    orderId = Get.arguments;
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    loadingState.value = LoadingState.loading;
    final response = await orderRepo.getOrderById(orderId);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    order.value = response.data!;
    loadingState.value = LoadingState.doneWithData;
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
    order.value!.copyWith(orderStatus: OrderStatus.accepted);
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
    order.value!.copyWith(orderStatus: OrderStatus.onTheWay);

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
    order.value!.copyWith(orderStatus: OrderStatus.completed);

    loadingState.value = LoadingState.doneWithData;
    CustomToasts(
      message: response.successMessage ?? 'OrderCompleted'.tr,
      type: CustomToastType.success,
    ).show();
  }

  void showLocationDialog(BuildContext context, AddressModel address) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(AppPadding.p16),
          child: Column(
            children: [
              Text(
                'Location'.tr,
                style: TextStyle(
                  fontSize: FontSize.s18,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.colorFontPrimary,
                ),
              ),
              const SizedBox(height: AppSize.s16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSize.s12),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(address.latitude, address.longitude),
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId(address.addressId.toString()),
                        position: LatLng(address.latitude, address.longitude),
                        infoWindow: InfoWindow(
                          title: address.address,
                          snippet: address.city,
                        ),
                      ),
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppSize.s16),
              AppButton(
                onPressed: () => Navigator.pop(context),
                text: 'Close'.tr,
                backgroundColor: ColorManager.colorPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
