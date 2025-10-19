// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:gas_delivery_app/core/services/cache_service.dart';
// import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
// import 'package:gas_delivery_app/data/repos/report_repo.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';
// import 'package:gas_delivery_app/presentation/util/utils.dart';

// class ReportProblemPageController extends GetxController {
//   final ReportRepo reportRepo = Get.find<ReportRepo>();
//   final CacheService cacheService = Get.find<CacheService>();

//   final TextEditingController commentController = TextEditingController();
//   final Rx<LoadingState> reportLoadingState = LoadingState.idle.obs;
//   final Rx<File?> selectedImage = Rx<File?>(null);

//   @override
//   void onClose() {
//     commentController.dispose();
//     super.onClose();
//   }

//   Future<void> pickImage() async {
//     try {
//       final pickedFile = await Utils.imagePicker(ImageSource.gallery);
//       if (pickedFile != null) {
//         selectedImage.value = File(pickedFile.path);
//       }
//     } catch (e) {
//       CustomToasts(
//         message: "ErrorPickingImage".tr,
//         type: CustomToastType.error,
//       ).show();
//     }
//   }

//   void removeImage() {
//     selectedImage.value = null;
//   }

//   Future<void> submitReport() async {
//     if (commentController.text.trim().isEmpty) {
//       CustomToasts(
//         message: "PleaseEnterComment".tr,
//         type: CustomToastType.warning,
//       ).show();
//       return;
//     }

//     if (reportLoadingState.value == LoadingState.loading) return;

//     reportLoadingState.value = LoadingState.loading;

//     try {
//       final response = await reportRepo.reportProblem(
//         comment: commentController.text.trim(),
//         image: selectedImage.value,
//       );

//       if (response.success) {
//         CustomToasts(
//           message: response.successMessage ?? "ReportSubmittedSuccessfully".tr,
//           type: CustomToastType.success,
//         ).show();

//         // Clear data
//         clearData();

//         // Go back to settings page
//         Get.back();

//         reportLoadingState.value = LoadingState.doneWithData;
//       } else {
//         CustomToasts(
//           message:
//               response.networkFailure?.message ?? "ErrorSubmittingReport".tr,
//           type: CustomToastType.error,
//         ).show();
//         reportLoadingState.value = LoadingState.hasError;
//       }
//     } catch (e) {
//       CustomToasts(
//         message: "ErrorSubmittingReport".tr,
//         type: CustomToastType.error,
//       ).show();
//       reportLoadingState.value = LoadingState.hasError;
//     }
//   }

//   void clearData() {
//     commentController.clear();
//     selectedImage.value = null;
//   }
// }
