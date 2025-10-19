import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/address_model.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_delivery_app/presentation/pages/address_page/address_page_controller.dart';
import 'package:gas_delivery_app/presentation/pages/address_page/select_location_page.dart';
import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AddressListPage extends GetView<AddressListController> {
  const AddressListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppBar(title: 'Addresses'.tr, backIcon: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          controller.setAddress(StatusLocation.add, address: null);
        },
        backgroundColor: ColorManager.colorPrimary,
        child: Assets.icons.locationIcon.svg(
          colorFilter: const ColorFilter.mode(
            ColorManager.colorWhite,
            BlendMode.srcIn,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.loadingState.value == LoadingState.loading) {
          return Column(
            children: [
              const SizedBox(height: AppSize.s8),
              Expanded(
                child: ListView.separated(
                  itemCount: 3, // Show 3 shimmer placeholders
                  itemBuilder: (context, index) => _buildShimmerAddressItem(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSize.s8),
                ),
              ),
            ],
          );
        }
        if (controller.loadingState.value == LoadingState.hasError) {
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
                  'FailedToLoadAddresses'.tr,
                  style: TextStyle(
                    fontSize: FontSize.s18,
                    color: ColorManager.colorDoveGray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSize.s12),
                GestureDetector(
                  onTap: controller.fetchAddresses,
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
        if (controller.addresses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off,
                  size: AppSize.s60,
                  color: ColorManager.colorDoveGray600,
                ),
                const SizedBox(height: AppSize.s16),
                Text(
                  'NoAddresses'.tr,
                  style: TextStyle(
                    fontSize: FontSize.s18,
                    color: ColorManager.colorDoveGray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSize.s8),
                GestureDetector(
                  onTap: () => controller.setAddress(StatusLocation.add),
                  child: Text(
                    'AddAddressPrompt'.tr,
                    style: TextStyle(
                      fontSize: FontSize.s14,
                      color: ColorManager.colorDoveGray600,
                    ),
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
              child: ListView.separated(
                itemCount: controller.addresses.length,
                itemBuilder: (context, index) {
                  final address = controller.addresses[index];
                  return _buildAddressItem(address, context);
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSize.s8),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAddressItem(AddressModel address, BuildContext context) {
    return Container(
      color: ColorManager.colorWhite,
      padding: const EdgeInsets.all(AppPadding.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with address name and type
          if (address.addressName != null)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppPadding.p4),
                  decoration: BoxDecoration(
                    color: ColorManager.colorBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSize.s8),
                  ),
                  child: Assets.icons.locationPin.svg(
                    width: AppSize.s18,
                    height: AppSize.s18,
                    colorFilter: const ColorFilter.mode(
                      ColorManager.colorBlue,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.s12),
                Expanded(
                  child: Text(
                    address.addressName ?? "",
                    style: TextStyle(
                      fontSize: FontSize.s18,
                      fontWeight: FontWeight.w700,
                      color: ColorManager.colorBlue,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

          const SizedBox(height: AppSize.s12),

          // Address details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.address,
                style: TextStyle(
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.w500,
                  color: ColorManager.colorFontPrimary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSize.s4),
              Row(
                children: [
                  Icon(
                    Icons.location_city_outlined,
                    size: AppSize.s16,
                    color: ColorManager.colorDoveGray600,
                  ),
                  const SizedBox(width: AppSize.s6),
                  Expanded(
                    child: Text(
                      address.city,
                      style: TextStyle(
                        fontSize: FontSize.s14,
                        color: ColorManager.colorDoveGray600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSize.s16),

          // Action buttons
          Container(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: AppSize.s12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Location action
              _buildActionButton(
                icon: Assets.icons.locationIcon.svg(
                  width: 18,
                  colorFilter: ColorFilter.mode(
                    ColorManager.colorBlue,
                    BlendMode.srcIn,
                  ),
                ),
                backgroundColor: ColorManager.colorBlue.withValues(alpha: .1),
                onPressed: () =>
                    controller.showLocationDialog(context, address),
                label: 'View Map',
              ),

              // Spacer
              Expanded(child: SizedBox()),

              // Edit and Delete actions
              Row(
                children: [
                  _buildActionButton(
                    icon: Assets.icons.editIcon.svg(
                      width: 18,
                      colorFilter: ColorFilter.mode(
                        ColorManager.colorGrey3,
                        BlendMode.srcIn,
                      ),
                    ),
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    onPressed: () async {
                      controller.setAddress(
                        StatusLocation.update,
                        address: address,
                      );
                    },
                    label: 'Edit',
                  ),
                  const SizedBox(width: AppSize.s8),
                  _buildActionButton(
                    icon: Assets.icons.deleteIcon.svg(
                      width: 18,
                      colorFilter: ColorFilter.mode(
                        ColorManager.colorError,
                        BlendMode.srcIn,
                      ),
                    ),
                    backgroundColor: ColorManager.colorError.withValues(
                      alpha: .08,
                    ),
                    onPressed: () =>
                        controller.deleteAddress(address.addressId),
                    label: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget for action buttons
  Widget _buildActionButton({
    required Widget icon,
    required Color backgroundColor,
    required VoidCallback onPressed,
    required String label,
  }) {
    return Tooltip(
      message: label,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: icon,
          onPressed: onPressed,
          splashRadius: 20,
        ),
      ),
    );
  }

  Widget _buildShimmerAddressItem() {
    return Shimmer.fromColors(
      baseColor: ColorManager.colorGrey2.withOpacity(0.3),
      highlightColor: ColorManager.colorGrey2.withOpacity(0.1),
      child: Container(
        color: ColorManager.colorWhite,
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with address name placeholder
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
              ],
            ),
            const SizedBox(height: AppSize.s12),
            // Address details placeholder
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.white,
                ),
                const SizedBox(height: AppSize.s4),
                Row(
                  children: [
                    Container(
                      width: AppSize.s16,
                      height: AppSize.s16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: AppSize.s6),
                    Container(width: 100, height: 14, color: Colors.white),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSize.s16),
            // Divider placeholder
            Container(height: 1, color: Colors.white),
            const SizedBox(height: AppSize.s12),
            // Action buttons placeholder
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const Expanded(child: SizedBox()),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSize.s8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
