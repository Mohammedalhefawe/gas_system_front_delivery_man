import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_text_field.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_delivery_app/presentation/pages/add_review_product_page/add_review_product_controller.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AddReviewPage extends GetView<AddReviewPageController> {
  const AddReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: NormalAppBar(title: 'AddReview'.tr, backIcon: true),
        body: Obx(() {
          if (controller.loadingState.value == LoadingState.loading) {
            return _buildShimmerForm();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('RateProduct'.tr, style: Get.textTheme.titleMedium),
                  const SizedBox(height: AppSize.s8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => controller.setRating(index + 1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p4,
                          ),
                          child: Icon(
                            controller.rating.value >= index + 1
                                ? Icons.star
                                : Icons.star_border,
                            color: ColorManager.colorPrimary,
                            size: AppSize.s40,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: AppSize.s16),
                  CustomTextField(
                    requiredField: true,
                    title: 'Review'.tr,
                    hint: 'EnterReview'.tr,
                    textEditingController: controller.reviewController,
                    textInputType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 3,
                    fillColor: ColorManager.colorWhite,
                    borderRadius: AppSize.s8,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'RequiredReview'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSize.s16),
                  AppButton(
                    loadingMode:
                        controller.loadingState.value == LoadingState.loading,
                    onPressed: controller.submitReview,
                    text: 'SubmitReview'.tr,
                    backgroundColor: ColorManager.colorPrimary,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildShimmerForm() {
    return Shimmer.fromColors(
      baseColor: ColorManager.colorGrey2.withOpacity(0.3),
      highlightColor: ColorManager.colorGrey2.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 100, height: 16, color: Colors.white),
            const SizedBox(height: AppSize.s12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p4,
                  ),
                  child: Container(
                    width: AppSize.s28,
                    height: AppSize.s28,
                    color: Colors.white,
                  ),
                );
              }),
            ),
            const SizedBox(height: AppSize.s16),
            Container(width: double.infinity, height: 100, color: Colors.white),
            const SizedBox(height: AppSize.s16),
            Container(width: double.infinity, height: 48, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
