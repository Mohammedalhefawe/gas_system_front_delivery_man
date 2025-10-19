// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gas_delivery_app/core/app_config/app_translation.dart';
// import 'package:gas_delivery_app/core/services/cache_service.dart';
// import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
// import 'package:gas_delivery_app/data/enums/type_user_enum.dart';
// import 'package:gas_delivery_app/data/models/user_model.dart';
// import 'package:gas_delivery_app/data/repos/notification_repo.dart';
// import 'package:gas_delivery_app/data/repos/users_repo.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';
// import 'package:gas_delivery_app/presentation/pages/chat_page/pusher_controller.dart';
// import 'package:gas_delivery_app/presentation/pages/main_page/main_page_controller.dart';
// import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
// import 'package:gas_delivery_app/presentation/util/resources/navigation_manager.dart';

// class SettingsPageController extends GetxController {
//   final CacheService cacheService = Get.find<CacheService>();
//   final UsersRepo usersRepo = Get.find<UsersRepo>();
//   final NotificationRepo notificationRepo = Get.find<NotificationRepo>();
//   final Rx<UserModel> user = UserModel().obs;

//   final RxString selectedLanguage = AppTranslations.isArabic
//       ? 'ar'.obs
//       : 'en'.obs;
//   final Rxn<UserType> selectedAccountMode = Rxn<UserType>(UserType.user);
//   final Rxn<UserType> currentAccountMode = Rxn<UserType>(UserType.guest);
//   final loadingSettingsState = LoadingState.doneWithData.obs;

//   @override
//   void onInit() {
//     if (cacheService.isLoggedIn()) {
//       if (!Get.isRegistered<PusherController>()) {
//         Get.put(PusherController());
//       }
//       user.value = cacheService.getLoggedInUser();
//       selectedAccountMode.value = UserType.fromCode(
//         cacheService.getCurrentMode(),
//       );
//       currentAccountMode.value = UserType.fromCode(
//         cacheService.getCurrentMode(),
//       );
//     } else {
//       currentAccountMode.value = UserType.guest;
//     }

//     super.onInit();
//   }

//   void changeAccountMode(UserType mode) {
//     if (!cacheService.isLoggedIn()) {
//       CustomToasts(
//         message: "YouAreInGuestMode".tr,
//         type: CustomToastType.warning,
//       ).show();
//       Get.toNamed(AppRoutes.phoneNumberRegistrationRoute);
//       return;
//     }
//     if (mode == currentAccountMode.value) return;
//     selectedAccountMode.value = mode;
//     currentAccountMode.value = mode;
//     cacheService.storeAccountMode(mode);
//     Get.find<PusherController>().closePusher();
//     CustomToasts(
//       message: 'AccountModeChangedSuccessfully'.tr,
//       type: CustomToastType.success,
//     ).show();
//     Get.offAllNamed(AppRoutes.mainRoute);
//     Get.find<PusherController>().initPusher();
//   }

//   Future<void> logout() async {
//     if (cacheService.isLoggedIn()) {
//       if (loadingSettingsState.value == LoadingState.loading) return;
//       loadingSettingsState.value = LoadingState.loading;

//       await notificationRepo.removeFCM();

//       final response = await usersRepo.logout();

//       if (!response.success) {
//         loadingSettingsState.value = LoadingState.hasError;
//         return;
//       }
//       loadingSettingsState.value = LoadingState.doneWithData;
//       cacheService.clearCache();
//       Get.find<PusherController>().closePusher();
//       // Get.find<MainController>().changePage(homeTabIndex);
//       Get.find<MainController>().init();
//       Get.offAllNamed(AppRoutes.mainRoute);
//     }
//   }

//   Future deleteAccountDialog() async {
//     Get.defaultDialog(
//       title: "DialogTitleDelAd".tr,
//       titleStyle: Get.textTheme.bodyLarge!.copyWith(
//         color: ColorManager.colorError200,
//       ),
//       middleText: "DialogQDelAccount".tr,
//       buttonColor: ColorManager.colorError200,

//       confirmTextColor: Colors.white,
//       onConfirm: () async {
//         deleteAccount();
//       },
//       confirm: TextButton(
//         onPressed: () {
//           Get.back();
//         },
//         style: TextButton.styleFrom(
//           foregroundColor: Colors.black,
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           backgroundColor: ColorManager.colorError200,
//         ),
//         child: Text(
//           "DeleteAccount".tr,
//           style: Get.textTheme.bodyLarge!.copyWith(
//             color: ColorManager.colorWhite,
//           ),
//         ),
//       ),
//       cancel: TextButton(
//         onPressed: () {
//           Get.back();
//         },
//         style: TextButton.styleFrom(
//           foregroundColor: Colors.black,
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           backgroundColor: ColorManager.colorDivider,
//         ),
//         child: Text("Undo".tr, style: Get.textTheme.bodyLarge!.copyWith()),
//       ),
//     );
//   }

//   Future<void> deleteAccount() async {
//     if (cacheService.isLoggedIn()) {
//       if (loadingSettingsState.value == LoadingState.loading) return;
//       loadingSettingsState.value = LoadingState.loading;

//       await notificationRepo.removeFCM();

//       final response = await usersRepo.deleteAccount();

//       if (!response.success) {
//         loadingSettingsState.value = LoadingState.hasError;
//         CustomToasts(
//           message: response.getErrorMessage(),
//           type: CustomToastType.error,
//         ).show();
//         return;
//       }
//       loadingSettingsState.value = LoadingState.doneWithData;
//       CustomToasts(
//         message: response.successMessage!,
//         type: CustomToastType.success,
//       ).show();
//       cacheService.clearCache();
//       Get.find<PusherController>().closePusher();
//       // Get.find<MainController>().changePage(homeTabIndex);
//       Get.find<MainController>().init();
//       Get.offAllNamed(AppRoutes.mainRoute);
//     }
//   }
// }
