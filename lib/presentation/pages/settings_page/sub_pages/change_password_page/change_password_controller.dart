// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gas_delivery_app/core/services/cache_service.dart';
// import 'package:gas_delivery_app/data/dto/otp_dto.dart';

// import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
// import 'package:gas_delivery_app/data/models/app_response.dart';
// import 'package:gas_delivery_app/data/repos/users_repo.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';

// class ChangePasswordController extends GetxController {
//   final formKey = GlobalKey<FormState>();
//   UsersRepo usersRepo = Get.find<UsersRepo>();
//   CacheService cacheService = Get.find<CacheService>();

//   OtpDto? otpDto = Get.arguments;

//   final loginLoadingState = LoadingState.idle.obs;
//   final isOldPassword = true.obs;
//   final isPassword = true.obs;
//   final isConfirmPassword = true.obs;
//   final TextEditingController confirmPassword = TextEditingController();
//   final TextEditingController password = TextEditingController();
//   final TextEditingController oldPassword = TextEditingController();

//   next() async {
//     if (formKey.currentState!.validate()) {
//       if (loginLoadingState.value == LoadingState.loading) return;
//       loginLoadingState.value = LoadingState.loading;
//       AppResponse response = await usersRepo.changePassword(
//         oldPassword: oldPassword.text,
//         password: password.text,
//         passwordConfirmation: confirmPassword.text,
//       );
//       log(response.data.toString());
//       if (response.success) {
//         loginLoadingState.value = LoadingState.doneWithData;
//         CustomToasts(
//           message: response.successMessage!,
//           type: CustomToastType.success,
//         ).show();
//         Get.back();
//       } else {
//         loginLoadingState.value = LoadingState.hasError;
//         CustomToasts(
//           message: response.getErrorMessage(),
//           type: CustomToastType.error,
//         ).show();
//       }
//     } else {}
//   }
// }
