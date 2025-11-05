import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/order_model.dart';
import 'package:gas_delivery_app/presentation/pages/orders_page/orders_controller.dart';
import 'package:gas_delivery_app/presentation/pages/orders_page/widgets/order_card_widget.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';

class ContentDataOrdersPageWidget extends GetView<DriverOrdersController> {
  final RxList<OrderModel> orders;
  final Rx<LoadingState> loadingMoreState;
  final ScrollController scrollController;
  const ContentDataOrdersPageWidget({
    super.key,
    required this.orders,
    required this.loadingMoreState,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
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
                      child: OrderCardWidget(order: order),
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
}
