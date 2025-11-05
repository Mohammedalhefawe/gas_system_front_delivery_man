import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/enums/order_status_enum.dart';
import 'package:gas_delivery_app/data/models/order_model.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_delivery_app/presentation/pages/order_details_page/order_details_page.dart';
import 'package:gas_delivery_app/presentation/pages/orders_page/orders_controller.dart';
import 'package:gas_delivery_app/presentation/pages/orders_page/widgets/status_order_badge_widget.dart';
import 'package:gas_delivery_app/presentation/util/date_converter.dart';
import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';

class OrderCardWidget extends GetView<DriverOrdersController> {
  final OrderModel order;
  const OrderCardWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final totalAmount =
        (double.parse(order.totalAmount) + double.parse(order.deliveryFee))
            .toStringAsFixed(0);

    return InkWell(
      onTap: () => Get.to(
        () => const DriverOrderDetailsPage(),
        arguments: order.orderId,
      ),
      borderRadius: BorderRadius.circular(AppSize.s16),
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.colorWhite,
          borderRadius: BorderRadius.circular(AppSize.s16),
        ),
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.orderId}',
                        style: TextStyle(
                          fontSize: FontSize.s18,
                          fontWeight: FontWeight.w700,
                          color: ColorManager.colorFontPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSize.s4),
                      Text(
                        order.immediate == 1
                            ? 'ImmediateDelivery'.tr
                            : "ScheduledDelivery".tr,
                        style: TextStyle(
                          fontSize: FontSize.s14,
                          color: ColorManager.colorDoveGray600,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusOrderBadgeWidget(status: order.orderStatus),
              ],
            ),
            const SizedBox(height: AppSize.s16),
            Row(
              children: [
                Assets.icons.locationIcon.svg(
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    ColorManager.colorDoveGray600,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppSize.s8),
                Expanded(
                  child: Text(
                    order.address?.address ?? "",
                    style: TextStyle(
                      fontSize: FontSize.s14,
                      color: ColorManager.colorDoveGray600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (order.immediate != 1) ...[
              const SizedBox(height: AppSize.s16),
              Row(
                children: [
                  Assets.icons.dateIcon.svg(
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      ColorManager.colorDoveGray600,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: AppSize.s8),
                  Expanded(
                    child: Text(
                      "${DateConverter.formatDateOnly(order.deliveryDate!)} ^^ ${DateConverter.formatTimeOnly(order.deliveryTime!)}",
                      style: TextStyle(
                        fontSize: FontSize.s14,
                        color: ColorManager.colorDoveGray600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSize.s16),
            Container(
              height: 1,
              color: ColorManager.colorGrey2.withValues(alpha: 0.1),
            ),
            const SizedBox(height: AppSize.s16),
            _buildPriceRow(
              'Subtotal',
              '${double.parse(order.totalAmount).toStringAsFixed(0)} ${'SP'.tr}',
            ),
            const SizedBox(height: AppSize.s8),
            _buildPriceRow(
              'DeliveryFee',
              '${double.parse(order.deliveryFee).toStringAsFixed(0)} ${'SP'.tr}',
            ),
            const SizedBox(height: AppSize.s8),
            _buildPriceRow('Total', '$totalAmount ${'SP'.tr}', isTotal: true),
            const SizedBox(height: AppSize.s16),
            _buildActionButtons(context, order),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.tr,
          style: TextStyle(
            fontSize: FontSize.s14,
            color: ColorManager.colorDoveGray600,
            fontWeight: isTotal ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: FontSize.s14,
            color: isTotal
                ? ColorManager.colorFontPrimary
                : ColorManager.colorDoveGray600,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, OrderModel order) {
    List<Widget> buttons = [];
    if (order.orderStatus == OrderStatus.pending) {
      buttons.add(
        Expanded(
          child: AppButton(
            onPressed: () => controller.acceptOrder(context, order.orderId),
            text: 'Accept'.tr,
            backgroundColor: ColorManager.colorPrimary,
            fontColor: ColorManager.colorWhite,
          ),
        ),
      );
    } else if (order.orderStatus == OrderStatus.accepted) {
      buttons.addAll([
        Expanded(
          child: AppButton(
            onPressed: () => controller.startOrder(context, order.orderId),
            text: 'StartDelivery'.tr,
            backgroundColor: ColorManager.colorPrimary,
            fontColor: ColorManager.colorWhite,
          ),
        ),
        const SizedBox(width: AppSize.s8),
        Expanded(
          child: AppButton(
            onPressed: () => controller.rejectOrder(context, order.orderId),
            text: 'Reject'.tr,
            backgroundColor: ColorManager.colorWhite,
            border: Border.all(width: 1, color: ColorManager.colorSecondaryRed),
            fontColor: ColorManager.colorSecondaryRed,
          ),
        ),
      ]);
    } else if (order.orderStatus == OrderStatus.onTheWay) {
      buttons.add(
        Expanded(
          child: AppButton(
            onPressed: () => controller.completeOrder(context, order.orderId),
            text: 'CompleteDelivery'.tr,
            backgroundColor: ColorManager.colorPrimary,
            fontColor: ColorManager.colorWhite,
          ),
        ),
      );
    }
    return Row(children: buttons);
  }
}
