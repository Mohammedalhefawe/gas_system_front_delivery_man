import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/presentation/pages/account_page/account_controller.dart';
import 'package:gas_delivery_app/presentation/pages/account_page/widgets/content_data_account_page_widget.dart';
import 'package:gas_delivery_app/presentation/pages/account_page/widgets/content_empty_account_page_widget.dart';
import 'package:gas_delivery_app/presentation/pages/account_page/widgets/shimmer_account_page_widget.dart';
import 'package:get/get.dart';

class AccountPage extends GetView<AccountController> {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController());
    return Obx(() {
      if (controller.loadingState.value == LoadingState.loading) {
        return ShimmerAccountPageWidget();
      }
      if (controller.loadingState.value == LoadingState.doneWithNoData) {
        return ContentEmptyAccountWidget();
      }
      return ContentDataAccountPageWidget();
    });
  }
}
