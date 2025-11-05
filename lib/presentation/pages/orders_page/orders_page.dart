import 'package:flutter/material.dart';
import 'package:gas_delivery_app/core/app_config/app_translation.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/order_model.dart';
import 'package:gas_delivery_app/presentation/pages/orders_page/orders_controller.dart';
import 'package:gas_delivery_app/presentation/pages/orders_page/widgets/content_data_orders_page_widget.dart';
import 'package:gas_delivery_app/presentation/pages/orders_page/widgets/content_empty_orders_page_widget.dart';
import 'package:gas_delivery_app/presentation/pages/orders_page/widgets/shimmer_orders_page_widget.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';

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
    if (state.value == LoadingState.loading) return ShimmerOrdersPageWidget();
    if (state.value == LoadingState.doneWithNoData) {
      return ContentEmptyOrdersPageWidget(prompt: emptyPrompt);
    }
    return ContentDataOrdersPageWidget(
      orders: orders,
      loadingMoreState: loadingMoreState,
      scrollController: scrollController,
    );
  }
}
