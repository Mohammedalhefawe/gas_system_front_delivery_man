import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_text_field.dart';
import 'package:gas_delivery_app/presentation/pages/auth/widgets/auth_app_bar.dart';
import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:gas_delivery_app/presentation/util/widgets/phone_number_widget.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'login_page_controller.dart';

class LoginPage extends GetView<LoginPageController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorManager.colorBackground,
        body: SingleChildScrollView(
          child: Column(
            children: [
              AuthAppBar(
                title: "TitleLogin".tr,
                subTitle: "SubtitleLogin".tr,
                withIconBack: F,
              ),
              Padding(
                padding: const EdgeInsets.all(AppPadding.p16),
                child: Column(
                  children: [
                    InputLogin(),
                    SizedBox(height: AppSize.s24),
                    Obx(() {
                      return AppButton(
                        loadingMode:
                            controller.loginLoadingState.value ==
                            LoadingState.loading,
                        onPressed: controller.login,
                        backgroundColor: ColorManager.colorPrimary,
                        text: 'login'.tr,
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputLogin extends GetView<LoginPageController> {
  const InputLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Container(
        padding: EdgeInsets.all(AppPadding.p14),
        width: AppSize.sWidth,
        decoration: BoxDecoration(
          color: ColorManager.colorWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: ColorManager.colorBlack.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhoneNumberInput(
              title: "numberPhone".tr,
              borderRadius: AppSize.s8,
              textEditingController: controller.phoneNumberController,
              hintText: "${"type".tr} ${"numberPhone".tr}",
              readOnly: false,
              onChanged: (String number) {
                controller.selectPhoneNumber(number);
              },
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.isEmpty ||
                    !GetUtils.isPhoneNumber(value.trim().replaceAll(" ", ""))) {
                  return "RequiredPhoneNumber".tr;
                }
                return null;
              },
            ),
            SizedBox(height: AppSize.s14),
            Obx(
              () => CustomTextField(
                requiredField: true,
                title: "password".tr,
                hint: "enterPassword".tr,
                icon: Assets.icons.passwordIcon.svg(width: AppSize.s28),
                textEditingController: controller.passwordController,
                obscureText: !controller.isPassword.value,
                suffixIcon: GestureDetector(
                  onTap: () {
                    controller.isPassword.value = !controller.isPassword.value;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p8,
                    ),
                    child: controller.isPassword.value
                        ? Assets.icons.eyeOpenIcon.svg()
                        : Assets.icons.eyeClosedIcon.svg(),
                  ),
                ),
                textInputType: TextInputType.visiblePassword,
                fillColor: ColorManager.colorWhite,
                borderRadius: AppSize.s8,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "RequiredPassword".tr;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
