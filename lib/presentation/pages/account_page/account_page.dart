import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/user_model.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_delivery_app/presentation/pages/account_page/account_controller.dart';
import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/navigation_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AccountPage extends GetView<AccountController> {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController());
    return Obx(() {
      if (controller.loadingState.value == LoadingState.loading) {
        return _buildShimmer();
      }
      if (controller.loadingState.value == LoadingState.doneWithNoData) {
        return _buildEmptyState();
      }
      return _buildAccountContent();
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppPadding.p28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppSize.s120,
              height: AppSize.s120,
              decoration: BoxDecoration(
                color: ColorManager.colorPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                size: AppSize.s60,
                color: ColorManager.colorPrimary,
              ),
            ),
            const SizedBox(height: AppSize.s24),
            Text(
              'NoAccount'.tr,
              style: TextStyle(
                fontSize: FontSize.s24,
                fontWeight: FontWeight.w700,
                color: ColorManager.colorFontPrimary,
              ),
            ),
            const SizedBox(height: AppSize.s12),
            Text(
              'NoAccountPrompt'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FontSize.s16,
                color: ColorManager.colorDoveGray600,
                height: 1.5,
              ),
            ),
            SizedBox(height: AppSize.s30),
            AppButton(
              onPressed: () => Get.offAllNamed(AppRoutes.loginRoute),
              text: 'Login'.tr,
              backgroundColor: ColorManager.colorPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountContent() {
    final user = controller.user.value!;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: AppSize.s16),
              _buildProfileCard(user),
              const SizedBox(height: AppSize.s20),
              _buildOptionsSection(),
              const SizedBox(height: AppSize.s20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(UserModel user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      padding: const EdgeInsets.all(AppPadding.p24),
      decoration: BoxDecoration(
        color: ColorManager.colorWhite,
        borderRadius: BorderRadius.circular(AppSize.s20),
        boxShadow: [
          BoxShadow(
            color: ColorManager.colorBlack.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Header
          Row(
            children: [
              Container(
                width: AppSize.s60,
                height: AppSize.s60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorManager.colorDoveGray100,
                  border: Border.all(
                    color: ColorManager.colorDoveGray300,
                    width: 2,
                  ),
                ),
                child: Assets.images.user.image(),
              ),
              const SizedBox(width: AppSize.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: TextStyle(
                        fontSize: FontSize.s18,
                        fontWeight: FontWeight.w700,
                        color: ColorManager.colorFontPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSize.s4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p8,
                        vertical: AppPadding.p4,
                      ),
                      decoration: BoxDecoration(
                        color: user.isVerified
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSize.s12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            user.isVerified ? Icons.verified : Icons.pending,
                            size: AppSize.s12,
                            color: user.isVerified
                                ? Colors.green
                                : Colors.orange,
                          ),
                          const SizedBox(width: AppSize.s4),
                          Text(
                            user.isVerified ? 'Verified'.tr : 'Verified'.tr,
                            style: TextStyle(
                              fontSize: FontSize.s12,
                              fontWeight: FontWeight.w600,
                              color: user.isVerified
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSize.s20),

          // Divider
          Container(height: 1, color: ColorManager.colorGrey2.withOpacity(0.3)),

          const SizedBox(height: AppSize.s16),

          // Phone Number
          _buildProfileDetailRow(
            icon: Icons.phone_android_outlined,
            label: 'phone'.tr,
            value: user.phoneNumber,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: AppSize.s20, color: ColorManager.colorDoveGray600),
        const SizedBox(width: AppSize.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,

                style: TextStyle(
                  fontSize: FontSize.s12,
                  color: ColorManager.colorDoveGray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppSize.s4),
              Text(
                value,
                textDirection: TextDirection.ltr,

                style: TextStyle(
                  fontSize: FontSize.s14,
                  color: ColorManager.colorFontPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      decoration: BoxDecoration(
        color: ColorManager.colorWhite,
        borderRadius: BorderRadius.circular(AppSize.s20),
        boxShadow: [
          BoxShadow(
            color: ColorManager.colorBlack.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildOptionItem(
            icon: Assets.icons.languageIcon,
            text: 'change_language'.tr,
            description: 'ChangeAppLanguage'.tr,
            onTap: () => controller.showLanguageDialog(Get.context!),
          ),
          _buildDivider(),

          _buildOptionItem(
            icon: Assets.icons.helpIcon,
            text: 'privacy_policy'.tr,
            description: 'ReadOurPrivacyPolicy'.tr,
            onTap: () => controller.openUrl('https://example.com/privacy'),
          ),
          _buildDivider(),
          _buildOptionItem(
            icon: Assets.icons.summaryIcon,
            text: 'terms_conditions'.tr,
            description: 'ReadTermsConditions'.tr,
            onTap: () => controller.openUrl('https://example.com/terms'),
          ),
          _buildDivider(),
          _buildOptionItem(
            icon: Assets.icons.logoutIcon,
            text: 'logout'.tr,
            description: 'SignOutFromAccount'.tr,
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () => controller.showLogoutConfirmation(Get.context!),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required SvgGenImage icon,
    required String text,
    required String description,
    Color textColor = Colors.black,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.s12),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Row(
          children: [
            Container(
              width: AppSize.s40,
              height: AppSize.s40,
              decoration: BoxDecoration(
                color: textColor == Colors.red
                    ? Colors.red.withOpacity(0.1)
                    : ColorManager.colorPrimary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: icon.svg(
                  width: AppSize.s20,
                  colorFilter: ColorFilter.mode(
                    textColor == Colors.red
                        ? Colors.red
                        : ColorManager.colorPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSize.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: FontSize.s16,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSize.s4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: FontSize.s13,
                      color: ColorManager.colorDoveGray600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: AppSize.s16,
              color: ColorManager.colorDoveGray600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
      child: Divider(
        height: 1,
        color: ColorManager.colorGrey2.withOpacity(0.3),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: ColorManager.colorGrey2.withOpacity(0.3),
      highlightColor: ColorManager.colorGrey2.withOpacity(0.1),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: AppSize.s16),
                // Profile Card Shimmer
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p16,
                  ),
                  padding: const EdgeInsets.all(AppPadding.p24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSize.s20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: AppSize.s60,
                            height: AppSize.s60,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: AppSize.s16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120,
                                  height: 18,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: AppSize.s8),
                                Container(
                                  width: 80,
                                  height: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.s20),
                      Container(height: 1, color: Colors.white),
                      const SizedBox(height: AppSize.s16),
                      Container(
                        width: double.infinity,
                        height: 40,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSize.s20),
                // Options Section Shimmer
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSize.s20),
                  ),
                  child: Column(
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: const EdgeInsets.all(AppPadding.p20),
                        child: Row(
                          children: [
                            Container(
                              width: AppSize.s40,
                              height: AppSize.s40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: AppSize.s16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: AppSize.s4),
                                  Container(
                                    width: 80,
                                    height: 12,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: AppSize.s16,
                              height: AppSize.s16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
