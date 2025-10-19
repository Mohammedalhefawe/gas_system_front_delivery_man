// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
// import 'package:gas_delivery_app/presentation/pages/auth/widgets/auth_app_bar.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/custom_text_field.dart';
// import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
// import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
// import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
// import 'change_password_controller.dart';

// class ChangePasswordPage extends GetView<ChangePasswordController> {
//   const ChangePasswordPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.put(ChangePasswordController());
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: ColorManager.colorBackground,
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               AuthAppBar(title: "TitleChangePassword".tr, subTitle: "".tr),
//               Padding(
//                 padding: const EdgeInsets.all(AppPadding.p14),
//                 child: Column(
//                   children: [
//                     InputForgotPassword(),
//                     SizedBox(height: AppSize.s24),
//                     Obx(
//                       () => AppButton(
//                         loadingMode:
//                             controller.loginLoadingState.value ==
//                             LoadingState.loading,
//                         onPressed: controller.next,
//                         // enabled: F,
//                         backgroundColor: ColorManager.colorPrimary,
//                         text: 'Change'.tr,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class InputForgotPassword extends GetView<ChangePasswordController> {
//   const InputForgotPassword({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: controller.formKey,
//       child: Container(
//         padding: EdgeInsets.all(AppPadding.p12),
//         width: AppSize.sWidth,
//         color: ColorManager.colorWhite,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Obx(
//               () => CustomTextField(
//                 title: "oldPassword".tr,
//                 hint: "enterPassword".tr,
//                 icon: Assets.icons.passwordIcon.svg(width: AppSize.s28),
//                 textEditingController: controller.oldPassword,
//                 obscureText: controller.isOldPassword.value,

//                 suffixIcon: GestureDetector(
//                   onTap: () {
//                     controller.isOldPassword.value =
//                         !controller.isOldPassword.value;
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: AppPadding.p8,
//                     ),
//                     child: Assets.icons.eyeIcon.svg(),
//                   ),
//                 ),
//                 textInputType: TextInputType.visiblePassword,
//                 fillColor: ColorManager.colorWhite,
//                 borderRadius: AppSize.s8,
//                 autoValidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return "NullPasswordInput".tr;
//                   }
//                   if (value.length < 8) {
//                     return "ValdationPasswordUp8".tr;
//                   }
//                   return null;
//                 },
//               ),
//             ),
//             Obx(
//               () => CustomTextField(
//                 title: "password".tr,
//                 hint: "enterPassword".tr,
//                 icon: Assets.icons.passwordIcon.svg(width: AppSize.s28),
//                 textEditingController: controller.password,
//                 obscureText: controller.isPassword.value,

//                 suffixIcon: GestureDetector(
//                   onTap: () {
//                     controller.isPassword.value = !controller.isPassword.value;
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: AppPadding.p8,
//                     ),
//                     child: Assets.icons.eyeIcon.svg(),
//                   ),
//                 ),
//                 textInputType: TextInputType.visiblePassword,
//                 fillColor: ColorManager.colorWhite,
//                 borderRadius: AppSize.s8,
//                 autoValidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return "NullPasswordInput".tr;
//                   }
//                   if (value.length < 8) {
//                     return "ValdationPasswordUp8".tr;
//                   }
//                   return null;
//                 },
//               ),
//             ),
//             Obx(
//               () => CustomTextField(
//                 title: "confirmPassword".tr,
//                 hint: "enterconfirmPassword".tr,
//                 icon: Assets.icons.passwordIcon.svg(width: AppSize.s28),
//                 textEditingController: controller.confirmPassword,
//                 obscureText: controller.isConfirmPassword.value,

//                 suffixIcon: GestureDetector(
//                   onTap: () {
//                     controller.isConfirmPassword.value =
//                         !controller.isConfirmPassword.value;
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: AppPadding.p8,
//                     ),
//                     child: Assets.icons.eyeIcon.svg(),
//                   ),
//                 ),
//                 textInputType: TextInputType.visiblePassword,
//                 fillColor: ColorManager.colorWhite,
//                 borderRadius: AppSize.s8,
//                 autoValidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return "NullPasswordInput".tr;
//                   }
//                   if (value.length < 8) {
//                     return "ValdationPasswordUp8".tr;
//                   }
//                   if (controller.password.text.trim() != value) {
//                     return "PasswordConfirmationMismatch".tr;
//                   }
//                   return null;
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
