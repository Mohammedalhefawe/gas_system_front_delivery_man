import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/core/services/cache_service.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/repos/users_repo.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:gas_delivery_app/presentation/util/resources/navigation_manager.dart';

class LoginPageController extends GetxController {
  CacheService cacheService = Get.find<CacheService>();
  UsersRepo usersRepo = Get.find<UsersRepo>();

  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final countryCode = "+963".obs;
  final formattedMobileNumber = ''.obs;
  final loginLoadingState = LoadingState.idle.obs;
  final isPassword = false.obs;

  String get fullNumber =>
      "${countryCode.value}${sanitizePhoneNumber(formattedMobileNumber.value)}";

  Future login() async {
    if (!formKey.currentState!.validate()) return;

    if (!GetUtils.isPhoneNumber(fullNumber)) {
      CustomToasts(
        message: "RequiredPhoneNumber".tr,
        type: CustomToastType.warning,
      ).show();
      return;
    }

    if (loginLoadingState.value == LoadingState.loading) return;
    loginLoadingState.value = LoadingState.loading;

    final response = await usersRepo.login(
      phoneNumber: fullNumber.replaceAll(RegExp(r'[^0-9+]'), ''),
      password: passwordController.text,
    );

    if (!response.success ||
        (response.success && response.data?.user.role != "driver")) {
      loginLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }

    // Update cache with user data and token
    final userModel = response.data!.user;
    cacheService.storeLoggedInUserAndToken(userModel, response.data!.token);
    usersRepo.userLoggedIn.value = true;
    usersRepo.loggedInUser.value = userModel;

    CustomToasts(
      message: response.successMessage ?? "LoginSuccess".tr,
      type: CustomToastType.success,
    ).show();

    Get.offAllNamed(AppRoutes.mainRoute);

    loginLoadingState.value = LoadingState.doneWithData;
  }

  void selectPhoneNumber(String number) {
    formattedMobileNumber.value = number;
    debugPrint(fullNumber);
  }

  String sanitizePhoneNumber(String number) {
    if (countryCode.value == "+963" && number.startsWith("0")) {
      return number.substring(1);
    }
    return number;
  }
}
