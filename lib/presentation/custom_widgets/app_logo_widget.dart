import 'package:flutter/material.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';

import '../util/resources/assets.gen.dart';
import '../util/resources/color_manager.dart';

class AppLogoWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const AppLogoWidget({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: ColorManager.colorBlack.withValues(alpha: 0.5),
            blurRadius: 15,
          ),
        ],
      ),
      child: Assets.images.quickSaleLogo.image(
        width: width ?? AppSize.s60,
        height: height ?? AppSize.s60,
        fit: BoxFit.contain,
      ),
    );
  }
}
