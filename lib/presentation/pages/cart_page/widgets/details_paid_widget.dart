import 'package:flutter/material.dart';
import 'package:gas_delivery_app/presentation/pages/cart_page/cart_page_controller.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';

class DetailsPaidWidget extends StatelessWidget {
  const DetailsPaidWidget({
    super.key,
    required this.controller,
    required this.btnWidget,
  });

  final CartController controller;

  final Widget btnWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: ColorManager.colorWhite,
        boxShadow: [
          BoxShadow(
            color: ColorManager.colorBlack.withValues(alpha: .03),
            blurRadius: 2,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NumberOfItems'.tr,
                style: TextStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.colorDoveGray600,
                ),
              ),
              Text(
                controller.totalItems.toString(),
                style: TextStyle(
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.colorFontPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSize.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TotalItems'.tr,
                style: TextStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.colorDoveGray600,
                ),
              ),
              Text(
                '${controller.totalPrice.toStringAsFixed(0)} ${'SP'.tr}',
                style: TextStyle(
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.colorFontPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSize.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FeeDelivery'.tr,
                style: TextStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.colorDoveGray600,
                ),
              ),
              Text(
                '${controller.deliveryFee.value.toStringAsFixed(0)} ${'SP'.tr}',
                style: TextStyle(
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.colorFontPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSize.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TotalPrice'.tr,
                style: TextStyle(
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.colorFontPrimary,
                ),
              ),
              Text(
                '${(controller.totalPrice + controller.deliveryFee.value).toStringAsFixed(0)} ${'SP'.tr}',
                style: TextStyle(
                  fontSize: FontSize.s18,
                  fontWeight: FontWeight.w700,
                  color: ColorManager.colorPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSize.s16),
          btnWidget,
          SizedBox(height: AppSize.s20),
        ],
      ),
    );
  }
}
