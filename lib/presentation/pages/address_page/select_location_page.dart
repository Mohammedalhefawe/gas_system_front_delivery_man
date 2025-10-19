import 'package:flutter/material.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_text_field.dart';
import 'package:gas_delivery_app/presentation/pages/address_page/select_location_page_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';

enum StatusLocation { update, add }

class SelectLocationPage extends GetView<AddressPageController> {
  final StatusLocation statusLocation;
  final LatLng? initialPosition;

  const SelectLocationPage({
    super.key,
    required this.statusLocation,
    this.initialPosition,
  });

  void _onMapCreated(GoogleMapController googleMapController) {
    controller.mapController = googleMapController;
    ever(controller.currentPosition, (LatLng position) {
      googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(position, 14),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AddressPageController(initialPosition: initialPosition));
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: NormalAppBar(
          title: statusLocation == StatusLocation.add
              ? "AddAddress".tr
              : "EditAddress".tr,
          backIcon: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: Obx(
                  () => GoogleMap(
                    padding: const EdgeInsets.only(bottom: 120),
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
                    onTap: controller.onMapTap,
                    initialCameraPosition: CameraPosition(
                      target: controller.currentPosition.value,
                      zoom: 14,
                    ),
                    markers: controller.markers.value,
                  ),
                ),
              ),
              Container(
                color: ColorManager.colorWhite,
                padding: const EdgeInsets.all(AppPadding.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextField(
                      requiredField: true,
                      title: "AddressName".tr,
                      hint: "EnterAddressName".tr,
                      icon: Assets.icons.locationIcon.svg(width: AppSize.s28),
                      textEditingController: controller.addressNameController,
                      textInputType: TextInputType.text,
                      fillColor: ColorManager.colorWhite,
                      borderRadius: AppSize.s8,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: AppSize.s16),
                    CustomTextField(
                      requiredField: true,
                      title: "Address".tr,
                      hint: "EnterAddress".tr,
                      icon: Assets.icons.locationPin.svg(width: AppSize.s28),
                      textEditingController: controller.addressController,
                      textInputType: TextInputType.streetAddress,
                      fillColor: ColorManager.colorWhite,
                      borderRadius: AppSize.s8,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "RequiredAddress".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSize.s16),
                    CustomTextField(
                      requiredField: true,
                      title: "City".tr,
                      hint: "EnterCity".tr,
                      icon: Assets.icons.locationPin.svg(width: AppSize.s28),
                      textEditingController: controller.cityController,
                      textInputType: TextInputType.text,
                      fillColor: ColorManager.colorWhite,
                      borderRadius: AppSize.s8,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "RequiredCity".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSize.s16),
                    CustomTextField(
                      requiredField: false,
                      title: "FloorNumber".tr,
                      hint: "EnterFloorNumber".tr,
                      icon: Assets.icons.buildingIcon.svg(width: AppSize.s28),
                      textEditingController: controller.floorNumberController,
                      textInputType: TextInputType.text,
                      fillColor: ColorManager.colorWhite,
                      borderRadius: AppSize.s8,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                    ),

                    const SizedBox(height: AppSize.s16),
                    CustomTextField(
                      requiredField: false,
                      title: "Details".tr,
                      hint: "EnterDetails".tr,
                      // icon: Assets.icons.detailsIcon.svg(width: AppSize.s28),
                      textEditingController: controller.detailsController,
                      textInputType: TextInputType.text,
                      fillColor: ColorManager.colorWhite,
                      borderRadius: AppSize.s8,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 3,
                      minLines: 3,
                    ),
                    const SizedBox(height: AppSize.s16),
                    Obx(
                      () => AppButton(
                        loadingMode:
                            controller.loadingState.value ==
                            LoadingState.loading,
                        onPressed: controller.saveSelectedLocation,
                        text: statusLocation == StatusLocation.add
                            ? "AddAddress".tr
                            : "UpdateAddress".tr,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
