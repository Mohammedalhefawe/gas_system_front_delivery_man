import 'package:flutter/material.dart';
import 'package:gas_delivery_app/core/app_config/app_translation.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/user_model.dart';
import 'package:gas_delivery_app/data/repos/users_repo.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/navigation_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountController extends GetxController {
  final UsersRepo userRepo = Get.find<UsersRepo>();
  final user = Rxn<UserModel>();
  final loadingState = LoadingState.idle.obs;
  final selectedLanguage = AppTranslations.isArabic ? 'ar'.obs : 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    loadingState.value = LoadingState.loading;
    final response = userRepo.getLoggedInUser();
    user.value = response;
    loadingState.value = user.value == null
        ? LoadingState.doneWithNoData
        : LoadingState.doneWithData;
  }

  void showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        title: Text(
          'change_language'.tr,
          style: TextStyle(
            fontSize: FontSize.s16,
            fontWeight: FontWeight.w600,
            color: ColorManager.colorFontPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, 'English', 'en'),
            const SizedBox(height: AppSize.s8),
            _buildLanguageOption(context, 'العربية', 'ar'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'cancel'.tr,
              style: TextStyle(
                fontSize: FontSize.s14,
                color: ColorManager.colorDoveGray600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String language,
    String locale,
  ) {
    return InkWell(
      onTap: () {
        selectedLanguage.value = locale;
        AppTranslations.changeLocale(selectedLanguage.value);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.p8,
          horizontal: AppPadding.p12,
        ),
        decoration: BoxDecoration(
          border: selectedLanguage.value == locale
              ? Border.all(color: ColorManager.colorPrimary)
              : null,
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: TextStyle(
                fontSize: FontSize.s14,
                color: ColorManager.colorFontPrimary,
              ),
            ),
            if (selectedLanguage.value == locale)
              Icon(
                Icons.check,
                size: AppSize.s20,
                color: ColorManager.colorPrimary,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      CustomToasts(
        message: 'cannot_open_url'.tr,
        type: CustomToastType.error,
      ).show();
    }
  }

  Future<void> logout() async {
    loadingState.value = LoadingState.loading;
    final response = await userRepo.logout();
    if (!response.success) {
      loadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    user.value = null;
    loadingState.value = LoadingState.doneWithNoData;
    CustomToasts(message: 'LoggedOut'.tr, type: CustomToastType.success).show();
    Get.offAllNamed(AppRoutes.loginRoute);
  }

  void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8),
        ),
        title: Text(
          'logout'.tr,
          style: TextStyle(
            fontSize: FontSize.s16,
            fontWeight: FontWeight.w600,
            color: ColorManager.colorFontPrimary,
          ),
        ),
        content: Text(
          'LogoutPrompt'.tr,
          style: TextStyle(
            fontSize: FontSize.s14,
            color: ColorManager.colorDoveGray600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No'.tr,
              style: TextStyle(
                fontSize: FontSize.s14,
                color: ColorManager.colorDoveGray600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await logout();
            },
            child: Text(
              'Yes'.tr,
              style: TextStyle(fontSize: FontSize.s14, color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
