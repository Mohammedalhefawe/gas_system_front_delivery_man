import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';

class AuthAppBar extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool withIconBack;

  const AuthAppBar({
    super.key,
    required this.title,
    required this.subTitle,
    this.withIconBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.colorWhite,
      width: AppSize.sWidth,
      padding: EdgeInsets.only(
        left: AppPadding.p14,
        right: AppPadding.p14,
        top: AppPadding.p14 + MediaQuery.of(context).padding.top,
        bottom: AppPadding.p14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSize.s12),
              Text(title, style: Get.textTheme.headlineLarge),
              SizedBox(height: AppSize.s8),
              Text(subTitle, style: Get.textTheme.headlineSmall),
              SizedBox(height: AppSize.s12),
            ],
          ),
          Spacer(),
          withIconBack
              ? Column(
                  children: [
                    SizedBox(height: AppSize.s12),

                    GestureDetector(
                      child: Transform.rotate(
                        angle: 3.14,
                        child: Assets.icons.arrowBackIcon.svg(
                          width: AppSize.s28,
                          matchTextDirection: true,
                        ),
                      ),
                      onTap: () {
                        Get.back();
                      },
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
