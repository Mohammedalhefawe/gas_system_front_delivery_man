import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/models/review_model.dart';
import 'package:gas_delivery_app/data/repos/home_repo.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';

class AddReviewPageController extends GetxController {
  final HomeRepo homeRepo = Get.find<HomeRepo>();
  final reviewController = TextEditingController();
  final rating = 0.obs;
  final loadingState = LoadingState.idle.obs;
  int? productId;

  @override
  void onInit() {
    productId = Get.arguments;
    super.onInit();
  }

  void setRating(int value) {
    rating.value = value;
  }

  Future<void> submitReview() async {
    if (loadingState.value == LoadingState.loading) return;

    if (rating.value < 1 || rating.value > 5) {
      CustomToasts(
        message: 'RatingRequired'.tr,
        type: CustomToastType.error,
      ).show();
      return;
    }

    final reviewText = reviewController.text.trim();
    if (reviewText.isEmpty) {
      CustomToasts(
        message: 'RequiredReview'.tr,
        type: CustomToastType.error,
      ).show();
      return;
    }
    loadingState.value = LoadingState.loading;

    final reviewModel = ReviewModel(
      productId: productId!,
      rating: rating.value,
      review: reviewText.trim(),
    );

    final response = await homeRepo.submitReview(reviewModel);

    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }

    loadingState.value = LoadingState.doneWithData;
    CustomToasts(
      message: response.successMessage ?? 'ReviewSubmitted'.tr,
      type: CustomToastType.success,
    ).show();
    Get.back();
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }
}
