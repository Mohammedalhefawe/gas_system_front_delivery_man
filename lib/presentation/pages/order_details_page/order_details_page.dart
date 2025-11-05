import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_delivery_app/presentation/pages/order_details_page/order_details_controller.dart';
import 'package:gas_delivery_app/presentation/pages/order_details_page/widgets/content_data_details_order_page_widget.dart';
import 'package:gas_delivery_app/presentation/pages/order_details_page/widgets/content_error_details_order_page_widget.dart';
import 'package:gas_delivery_app/presentation/pages/order_details_page/widgets/shimmer_details_order_page_widget.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:get/get.dart';

class DriverOrderDetailsPage extends GetView<DriverOrderDetailsController> {
  const DriverOrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DriverOrderDetailsController());
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorManager.colorGrey0,
        appBar: NormalAppBar(title: 'OrderDetails'.tr, backIcon: true),
        body: Obx(() {
          if (controller.loadingState.value == LoadingState.loading) {
            return ShimmerDetailsOrderPageWidget();
          }
          if (controller.loadingState.value == LoadingState.doneWithNoData) {
            return ContentErrorDetailsOrderPageWidget();
          }
          return ContentDataDetailsOrderPageWidget();
        }),
      ),
    );
  }
}
