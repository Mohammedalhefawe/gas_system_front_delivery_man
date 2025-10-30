import 'package:flutter/material.dart';
import 'package:gas_delivery_app/core/app_config/app_translation.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/order_model.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_delivery_app/presentation/pages/order_details_page/order_details_page.dart';
import 'package:gas_delivery_app/presentation/pages/orders_page/orders_controller.dart';
import 'package:gas_delivery_app/presentation/util/date_converter.dart';
import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class DriverOrdersPage extends StatefulWidget {
  const DriverOrdersPage({super.key});

  @override
  State<DriverOrdersPage> createState() => _DriverOrdersPageState();
}

class _DriverOrdersPageState extends State<DriverOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DriverOrdersController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(DriverOrdersController());

    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      controller.currentTab.value = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorManager.colorBackground,
          toolbarHeight: 0,
          bottom: TabBar(
            controller: _tabController,
            dividerColor: ColorManager.colorDoveGray100,
            labelColor: ColorManager.colorPrimary,
            unselectedLabelColor: ColorManager.colorDoveGray600,
            indicatorColor: ColorManager.colorPrimary,
            labelStyle: TextStyle(
              fontSize: FontSize.s14,
              fontWeight: FontWeight.w700,
              fontFamily: AppTranslations.appFontFamily,
            ),
            tabs: [
              Tab(text: 'MyOrders'.tr),
              Tab(text: 'NewOrders'.tr),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Obx(
              () => _buildOrdersByState(
                controller.myOrders,
                controller.myOrdersLoadingState,
                controller.myOrdersLoadingMoreState,
                controller.myOrdersScrollController,
                'NoDriverOrdersPrompt'.tr,
              ),
            ),
            Obx(
              () => _buildOrdersByState(
                controller.newOrders,
                controller.newOrdersLoadingState,
                controller.newOrdersLoadingMoreState,
                controller.newOrdersScrollController,
                'NoNewOrdersPrompt'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersByState(
    RxList<OrderModel> orders,
    Rx<LoadingState> state,
    Rx<LoadingState> loadingMoreState,
    ScrollController scrollController,
    String emptyPrompt,
  ) {
    if (state.value == LoadingState.loading) return _buildShimmerList();
    if (state.value == LoadingState.doneWithNoData) {
      return _buildEmptyState(emptyPrompt);
    }
    return _buildOrdersList(orders, loadingMoreState, scrollController);
  }

  Widget _buildEmptyState(String prompt) {
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
                color: ColorManager.colorPrimary.withValues(alpha: 0.1),
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
              prompt,
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

  Widget _buildOrdersList(
    RxList<OrderModel> orders,
    Rx<LoadingState> loadingMoreState,
    ScrollController scrollController,
  ) {
    return Column(
      children: [
        const SizedBox(height: AppSize.s8),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => controller.refreshOrders(),
            color: ColorManager.colorPrimary,
            backgroundColor: ColorManager.colorWhite,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverList.separated(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p12,
                      ),
                      child: _buildOrderCard(context, order),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSize.s8),
                ),
                if (loadingMoreState.value == LoadingState.loading)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSize.s10,
                      ),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: AppSize.s8)),
              ],
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
                buildStatusBadge(order.orderStatus),
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
                    order.address!.address,
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
    if (order.orderStatus == 'pending') {
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
    } else if (order.orderStatus == 'accepted') {
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
      baseColor: ColorManager.colorGrey2.withValues(alpha: 0.3),
      highlightColor: ColorManager.colorGrey2.withValues(alpha: 0.1),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: AppSize.s8)),
          SliverList.separated(
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
                child: Container(
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
                              Container(
                                width: 120,
                                height: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(height: AppSize.s6),
                              Container(
                                width: 80,
                                height: 14,
                                color: Colors.white,
                              ),
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
                          Container(
                            width: 200,
                            height: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.s16),
                      Row(
                        children: [
                          Container(width: 20, height: 20, color: Colors.white),
                          const SizedBox(width: AppSize.s8),
                          Container(
                            width: 200,
                            height: 14,
                            color: Colors.white,
                          ),
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
                          Container(
                            width: 100,
                            height: 40,
                            color: Colors.white,
                          ),
                          const SizedBox(width: AppSize.s8),
                          Container(
                            width: 100,
                            height: 40,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSize.s8),
          ),
        ],
      ),
    );
  }
}

// Reused status badge widget
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
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppSize.s20),
      border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
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
