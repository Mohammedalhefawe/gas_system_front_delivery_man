// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
// import 'package:gas_delivery_app/core/app_config/app_translation.dart';
// import 'package:gas_delivery_app/data/enums/type_user_enum.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/handle_state_view_widget.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/normal_app_bar.dart';
// import 'package:gas_delivery_app/presentation/pages/settings_page/settings_page_controller.dart';
// import 'package:gas_delivery_app/presentation/pages/settings_page/sub_pages/change_password_page/change_password_page.dart';
// import 'package:gas_delivery_app/presentation/pages/settings_page/sub_pages/report_problem_page/report_problem_page.dart';
// import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
// import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
// import 'package:gas_delivery_app/presentation/util/resources/navigation_manager.dart';
// import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
// import 'package:gas_delivery_app/presentation/util/widgets/card_widget.dart';

// class SettingsPage extends GetView<SettingsPageController> {
//   const SettingsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorManager.colorBackground,
//       appBar: NormalAppBar(title: "Settings".tr, backIcon: true),
//       body: Obx(() {
//         return SafeArea(
//           top: F,
//           child: SizedBox(
//             width: AppSize.sWidth,
//             height: AppSize.sHeight,
//             child: HandleStateViewWidget(
//               onTap: () {},
//               state: controller.loadingSettingsState.value,
//               dataWidget: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: AppSize.s16,
//                   vertical: AppSize.s12,
//                 ),
//                 child: ListView(
//                   children: [
//                     CardWidget(
//                       child: Column(
//                         children: [
//                           _buildSettingsItem(
//                             title: "Language".tr,
//                             subtitle: AppTranslations.isArabic
//                                 ? "Arabic".tr
//                                 : "English".tr,
//                             icon: Assets.icons.languageIcon,
//                             onTap: () {
//                               showChangeLanguage();
//                             },
//                           ),
//                           Divider(color: ColorManager.colorGrey1, height: 1),
//                           _buildSettingsItem(
//                             title: "AccountMode".tr,
//                             subtitle:
//                                 controller.currentAccountMode.value!.code.tr,
//                             icon: Assets.icons.editUserIcon,
//                             onTap: () {
//                               if (controller.cacheService.isLoggedIn()) {
//                                 showChangeTypeAccount();
//                               } else {
//                                 CustomToasts(
//                                   message: "YouAreInGuestMode".tr,
//                                   type: CustomToastType.warning,
//                                 ).show();
//                                 Get.toNamed(
//                                   AppRoutes.phoneNumberRegistrationRoute,
//                                 );
//                               }
//                             },
//                           ),
//                           Divider(color: ColorManager.colorGrey1, height: 1),
//                           _buildSettingsItem(
//                             title: "PrivacyPolicy".tr,
//                             icon: Assets.icons.passwordIconBlack,
//                             onTap: () {},
//                           ),
//                           Divider(color: ColorManager.colorGrey1, height: 1),
//                           _buildSettingsItem(
//                             title: "TermsofUse".tr,
//                             icon: Assets.icons.filePencil,
//                             onTap: () {},
//                           ),
//                           if (controller.cacheService.isLoggedIn()) ...[
//                             Divider(color: ColorManager.colorGrey1, height: 1),
//                             _buildSettingsItem(
//                               title: "ReportProblem".tr,
//                               icon: Assets.icons.supportIcon,
//                               onTap: () {
//                                 Get.to(() => const ReportProblemPage());
//                               },
//                             ),
//                           ],
//                           if (controller.cacheService.isLoggedIn()) ...[
//                             Divider(color: ColorManager.colorGrey1, height: 1),
//                             _buildSettingsItem(
//                               title: "TitleChangePassword".tr,
//                               icon: Assets.icons.passwordIconBlack,
//                               onTap: () {
//                                 Get.to(() => ChangePasswordPage());
//                               },
//                             ),
//                           ],
//                           if (controller.cacheService.isLoggedIn()) ...[
//                             Divider(color: ColorManager.colorGrey1, height: 1),
//                             _buildSettingsItem(
//                               title: "DeleteAccount".tr,
//                               icon: Assets.icons.deleteIcon,
//                               onTap: () {
//                                 if (controller.cacheService.isLoggedIn()) {
//                                   controller.deleteAccountDialog();
//                                 }
//                               },
//                             ),
//                           ],

//                           Divider(color: ColorManager.colorGrey1, height: 1),
//                           _buildSettingsItem(
//                             title: controller.cacheService.isLoggedIn()
//                                 ? "Logout".tr
//                                 : "Login".tr,
//                             icon: controller.cacheService.isLoggedIn()
//                                 ? Assets.icons.logoutIcon
//                                 : Assets.icons.loginIcon,
//                             onTap: () {
//                               if (controller.cacheService.isLoggedIn()) {
//                                 controller.logout();
//                               } else {
//                                 Get.toNamed(
//                                   AppRoutes.phoneNumberRegistrationRoute,
//                                 );
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildSettingsItem({
//     required String title,
//     String? subtitle,
//     required VoidCallback onTap,
//     required SvgGenImage icon,
//   }) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(horizontal: AppSize.s16),
//       onTap: onTap,
//       leading: icon.svg(
//         width: AppSize.s24,
//         colorFilter: ColorFilter.mode(ColorManager.colorBlack, BlendMode.srcIn),
//       ),
//       title: Row(
//         children: [
//           Text(title, style: Get.textTheme.bodyLarge),
//           if (subtitle != null)
//             Text(" ($subtitle)", style: Get.textTheme.bodyLarge),
//         ],
//       ),
//       trailing: Transform.rotate(
//         angle: AppTranslations.isArabic ? 0 : 3.14,
//         child: Assets.icons.arrowBackIcon.svg(
//           width: AppSize.s20,
//           colorFilter: ColorFilter.mode(
//             ColorManager.colorBlack,
//             BlendMode.srcIn,
//           ),
//         ),
//       ),
//     );
//   }
// }

// void showChangeLanguage() {
//   showModalBottomSheet(
//     context: Get.context!,
//     isScrollControlled: true,
//     backgroundColor: ColorManager.colorBackground,
//     builder: (context) {
//       return SafeArea(
//         top: false,
//         child: DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.3,
//           minChildSize: 0.3,
//           maxChildSize: 0.4,
//           builder: (context, scrollController) {
//             return LanguageSelectionWidget(scrollController);
//           },
//         ),
//       );
//     },
//   );
// }

// class LanguageSelectionWidget extends GetView<SettingsPageController> {
//   final ScrollController scrollController;

//   const LanguageSelectionWidget(this.scrollController, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(AppSize.s16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Expanded(
//             child: ListView(
//               controller: scrollController,
//               children: [
//                 Obx(
//                   () => Container(
//                     decoration: BoxDecoration(
//                       color: ColorManager.colorWhite,
//                       borderRadius: BorderRadius.circular(AppSize.s8),
//                       border: controller.selectedLanguage.value == 'ar'
//                           ? Border.all(
//                               color: ColorManager.colorPrimary,
//                               width: 1.5,
//                             )
//                           : null,
//                     ),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: AppSize.s16,
//                       ),
//                       title: Text("Arabic".tr, style: Get.textTheme.bodyLarge),
//                       onTap: () {
//                         controller.selectedLanguage.value = 'ar';
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: AppSize.s8),
//                 Obx(
//                   () => Container(
//                     decoration: BoxDecoration(
//                       color: ColorManager.colorWhite,
//                       borderRadius: BorderRadius.circular(AppSize.s8),
//                       border: controller.selectedLanguage.value == 'en'
//                           ? Border.all(
//                               color: ColorManager.colorPrimary,
//                               width: 1.5,
//                             )
//                           : null,
//                     ),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: AppSize.s16,
//                       ),
//                       title: Text("English".tr, style: Get.textTheme.bodyLarge),
//                       onTap: () {
//                         controller.selectedLanguage.value = 'en';
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: AppSize.s16),
//           AppButton(
//             backgroundColor: ColorManager.colorPrimary,
//             text: "Save".tr,
//             onPressed: () {
//               AppTranslations.changeLocale(controller.selectedLanguage.value);
//               Get.back();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// void showChangeTypeAccount() {
//   showModalBottomSheet(
//     context: Get.context!,
//     isScrollControlled: true,
//     backgroundColor: ColorManager.colorBackground,
//     builder: (context) {
//       return SafeArea(
//         top: false,
//         child: DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.3,
//           minChildSize: 0.3,
//           maxChildSize: 0.4,
//           builder: (context, scrollController) {
//             return TypeAccountSelectionWidget(scrollController);
//           },
//         ),
//       );
//     },
//   );
// }

// class TypeAccountSelectionWidget extends GetView<SettingsPageController> {
//   final ScrollController scrollController;

//   const TypeAccountSelectionWidget(this.scrollController, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(AppSize.s16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Expanded(
//             child: ListView(
//               controller: scrollController,
//               children: [
//                 Obx(
//                   () => Container(
//                     decoration: BoxDecoration(
//                       color: ColorManager.colorWhite,
//                       borderRadius: BorderRadius.circular(AppSize.s8),
//                       border:
//                           controller.selectedAccountMode.value == UserType.user
//                           ? Border.all(
//                               color: ColorManager.colorPrimary,
//                               width: 1.5,
//                             )
//                           : null,
//                     ),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: AppSize.s16,
//                       ),
//                       title: Text("User".tr, style: Get.textTheme.bodyLarge),
//                       onTap: () {
//                         controller.selectedAccountMode.value = UserType.user;
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: AppSize.s8),
//                 Obx(
//                   () => Container(
//                     decoration: BoxDecoration(
//                       color: ColorManager.colorWhite,
//                       borderRadius: BorderRadius.circular(AppSize.s8),
//                       border:
//                           controller.selectedAccountMode.value == UserType.store
//                           ? Border.all(
//                               color: ColorManager.colorPrimary,
//                               width: 1.5,
//                             )
//                           : null,
//                     ),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: AppSize.s16,
//                       ),
//                       title: Text("Store".tr, style: Get.textTheme.bodyLarge),
//                       onTap: () {
//                         if (controller.user.value.isStore) {
//                           controller.selectedAccountMode.value = UserType.store;
//                         } else {
//                           Get.toNamed(AppRoutes.addStoreRoute);
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: AppSize.s16),
//           AppButton(
//             backgroundColor: ColorManager.colorPrimary,
//             text: "Save".tr,
//             onPressed: () {
//               controller.changeAccountMode(
//                 controller.selectedAccountMode.value!,
//               );
//               Get.back();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
