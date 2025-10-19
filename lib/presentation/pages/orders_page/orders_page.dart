import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/order_model.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_delivery_app/presentation/pages/orders_page/orders_controller.dart';
import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class DriverOrdersPage extends GetView<DriverOrdersController> {
  const DriverOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DriverOrdersController());
    return Obx(() {
      if (controller.loadingState.value == LoadingState.loading) {
        return _buildShimmerList();
      }
      if (controller.loadingState.value == LoadingState.doneWithNoData) {
        return _buildEmptyState();
      }
      return _buildOrdersList();
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppSize.s120,
              height: AppSize.s120,
              decoration: BoxDecoration(
                color: ColorManager.colorPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delivery_dining,
                size: AppSize.s60,
                color: ColorManager.colorPrimary,
              ),
            ),
            const SizedBox(height: AppSize.s28),
            Text(
              'NoOrders'.tr,
              style: TextStyle(
                fontSize: FontSize.s24,
                fontWeight: FontWeight.w700,
                color: ColorManager.colorFontPrimary,
              ),
            ),
            const SizedBox(height: AppSize.s12),
            Text(
              'NoDriverOrdersPrompt'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FontSize.s16,
                color: ColorManager.colorDoveGray600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return Column(
      children: [
        const SizedBox(height: AppSize.s8),
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.fetchDriverOrders,
            color: ColorManager.colorPrimary,
            backgroundColor: ColorManager.colorWhite,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
              itemCount: controller.orders.length,
              itemBuilder: (context, index) {
                final order = controller.orders[index];
                return Column(
                  children: [
                    _buildOrderCard(context, order),
                    if (index == controller.orders.length - 1)
                      const SizedBox(height: AppSize.s8),
                  ],
                );
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSize.s8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    final totalAmount =
        (double.parse(order.totalAmount) + double.parse(order.deliveryFee))
            .toStringAsFixed(0);

    return InkWell(
      onTap: () {
        // Optional: Navigate to a detailed order view if needed
      },
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
            // Header Row
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
                        order.orderDate,
                        style: TextStyle(
                          fontSize: FontSize.s14,
                          color: ColorManager.colorDoveGray600,
                        ),
                      ),
                    ],
                  ),
                ),
                buildStatusBadge(order.orderStatus),
              ],
            ),
            const SizedBox(height: AppSize.s16),
            // Address Section
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
                    order.address.addressName ?? order.address.address,
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
            const SizedBox(height: AppSize.s16),
            // Divider
            Container(
              height: 1,
              color: ColorManager.colorGrey2.withValues(alpha: 0.1),
            ),
            const SizedBox(height: AppSize.s16),
            // Price Breakdown
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
            // Action Buttons
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
    if (order.orderStatus == 'pending') {
      buttons.addAll([
        Expanded(
          child: AppButton(
            onPressed: () => controller.acceptOrder(context, order.orderId),
            text: 'Accept'.tr,
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
    } else if (order.orderStatus == 'accepted') {
      buttons.add(
        Expanded(
          child: AppButton(
            onPressed: () => controller.startOrder(context, order.orderId),
            text: 'StartDelivery'.tr,
            backgroundColor: ColorManager.colorPrimary,
            fontColor: ColorManager.colorWhite,
          ),
        ),
      );
    } else if (order.orderStatus == 'on_the_way') {
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

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: ColorManager.colorGrey2.withOpacity(0.3),
      highlightColor: ColorManager.colorGrey2.withOpacity(0.1),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSize.s8),
            padding: const EdgeInsets.all(AppPadding.p20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSize.s16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 120, height: 18, color: Colors.white),
                        const SizedBox(height: AppSize.s6),
                        Container(width: 80, height: 14, color: Colors.white),
                      ],
                    ),
                    Container(width: 70, height: 28, color: Colors.white),
                  ],
                ),
                const SizedBox(height: AppSize.s16),
                Row(
                  children: [
                    Container(width: 20, height: 20, color: Colors.white),
                    const SizedBox(width: AppSize.s8),
                    Container(width: 200, height: 14, color: Colors.white),
                  ],
                ),
                const SizedBox(height: AppSize.s16),
                Container(height: 1, color: Colors.white),
                const SizedBox(height: AppSize.s16),
                Container(
                  width: double.infinity,
                  height: 14,
                  color: Colors.white,
                ),
                const SizedBox(height: AppSize.s8),
                Container(
                  width: double.infinity,
                  height: 14,
                  color: Colors.white,
                ),
                const SizedBox(height: AppSize.s8),
                Container(
                  width: double.infinity,
                  height: 14,
                  color: Colors.white,
                ),
                const SizedBox(height: AppSize.s16),
                Row(
                  children: [
                    Container(width: 100, height: 40, color: Colors.white),
                    const SizedBox(width: AppSize.s8),
                    Container(width: 100, height: 40, color: Colors.white),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Reused from orders_page.dart
Widget buildStatusBadge(String status) {
  final Map<String, Map<String, dynamic>> statusMap = {
    'pending': {'color': ColorManager.colorPrimary, 'icon': Icons.access_time},
    'accepted': {'color': Colors.blue, 'icon': Icons.thumb_up_outlined},
    'rejected': {'color': Colors.red, 'icon': Icons.block},
    'on_the_way': {'color': Colors.orange, 'icon': Icons.delivery_dining},
    'completed': {'color': Colors.green, 'icon': Icons.check_circle_outline},
    'cancelled': {'color': Colors.red, 'icon': Icons.cancel_outlined},
  };

  final statusData =
      statusMap[status] ?? {'color': Colors.grey, 'icon': Icons.info_outline};

  final Color color = statusData['color'];
  final IconData icon = statusData['icon'];

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppPadding.p12,
      vertical: AppPadding.p8,
    ),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(AppSize.s20),
      border: Border.all(color: color.withOpacity(0.3), width: 1),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSize.s14, color: color),
        const SizedBox(width: AppSize.s4),
        Text(
          status.tr,
          style: TextStyle(
            fontSize: FontSize.s12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    ),
  );
}
