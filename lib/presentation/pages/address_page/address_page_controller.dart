import 'package:flutter/material.dart';
import 'package:gas_delivery_app/core/services/cache_service.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_delivery_app/presentation/pages/address_page/select_location_page.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/address_model.dart';
import 'package:gas_delivery_app/data/repos/address_repo.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressListController extends GetxController {
  final AddressRepo addressRepo = Get.find<AddressRepo>();
  final CacheService cacheService = Get.find<CacheService>();
  final addresses = <AddressModel>[].obs;
  final loadingState = LoadingState.idle.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    loadingState.value = LoadingState.loading;
    final response = await addressRepo.getAddresses();
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    addresses.value = response.data ?? [];
    loadingState.value = addresses.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }

  Future<void> addAddress(AddressModel address) async {
    loadingState.value = LoadingState.loading;
    final response = await addressRepo.addAddress(address);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    addresses.add(response.data!);
    loadingState.value = LoadingState.doneWithData;
    CustomToasts(
      message: response.successMessage ?? 'AddressAdded'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future<void> updateAddress(int addressId, AddressModel address) async {
    loadingState.value = LoadingState.loading;
    final response = await addressRepo.updateAddress(addressId, address);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    final index = addresses.indexWhere((a) => a.addressId == addressId);
    if (index >= 0) {
      addresses[index] = response.data!;
    }
    loadingState.value = LoadingState.doneWithData;
    CustomToasts(
      message: response.successMessage ?? 'AddressUpdated'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future<void> deleteAddress(int addressId) async {
    loadingState.value = LoadingState.loading;
    final response = await addressRepo.deleteAddress(addressId);
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    addresses.removeWhere((a) => a.addressId == addressId);
    loadingState.value = addresses.isEmpty
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
    CustomToasts(
      message: response.successMessage ?? 'AddressDeleted'.tr,
      type: CustomToastType.success,
    ).show();
  }

  Future setAddress(
    StatusLocation statusLocation, {
    AddressModel? address,
  }) async {
    final result = await Get.to(
      () => SelectLocationPage(
        statusLocation: statusLocation,
        initialPosition:
            (address?.latitude != null && address?.longitude != null)
            ? LatLng(address!.latitude, address.longitude)
            : null,
      ),
      arguments: address,
    );
    if (result != null && result is AddressModel) {
      if (statusLocation == StatusLocation.update) {
        updateAddress(
          result.addressId,
          AddressModel(
            addressId: result.addressId,
            customerId: result.customerId,
            address: result.address,
            city: result.city.split(',').last.trim(),
            latitude: result.latitude,
            longitude: result.longitude,
            floorNumber: result.floorNumber,
            addressName: result.addressName,
            details: result.details,
          ),
        );
      } else if (statusLocation == StatusLocation.add) {
        addAddress(
          AddressModel(
            addressId: 0,
            customerId: cacheService.getLoggedInUser().userId,
            address: result.address,
            city: result.city.split(',').last.trim(),
            latitude: result.latitude,
            longitude: result.longitude,
            floorNumber: result.floorNumber,
            addressName: result.addressName,
            details: result.details,
          ),
        );
      }
    }
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
