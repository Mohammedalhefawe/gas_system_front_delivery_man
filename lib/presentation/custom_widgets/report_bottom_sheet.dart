import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_text_field.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';

import 'custom_toasts.dart';

class ReportBottomSheet {
  static void show({
    required BuildContext context,
    required String title,
    required String description,
    required Rx<LoadingState> loadingState,
    required Function(String comment) onReport,
  }) {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: ColorManager.colorWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(AppPadding.p16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: ColorManager.colorGrey2.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.s16),

                  // Title
                  Text(
                    title,
                    style: Get.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorManager.colorBlack,
                    ),
                  ),
                  const SizedBox(height: AppSize.s8),

                  // Description
                  Text(
                    description,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: ColorManager.colorGrey2,
                    ),
                  ),
                  const SizedBox(height: AppSize.s16),

                  // Comment field
                  CustomTextField(
                    title: "Comment".tr,
                    hint: "EnterComment".tr,
                    textEditingController: commentController,
                    textInputType: TextInputType.multiline,
                    maxLines: 4,
                    minLines: 3,
                    fillColor: ColorManager.colorTextFieldFill,
                    requiredField: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "RequiredField".tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSize.s20),

                  // Submit button
                  Obx(() {
                    return AppButton(
                      text: "Report".tr,
                      onPressed: () {
                        if (commentController.text.trim().isEmpty) {
                          CustomToasts(
                            message: "RequiredField".tr,
                            type: CustomToastType.error,
                          ).show();
                          return;
                        }
                        onReport(commentController.text.trim());
                      },
                      loadingMode: loadingState.value == LoadingState.loading,
                      enabled: loadingState.value != LoadingState.loading,
                    );
                  }),
                  const SizedBox(height: AppSize.s8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
