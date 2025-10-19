import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:gas_delivery_app/presentation/pages/splash_page/splash_page_controller.dart';
import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';

class SplashPage extends GetView<SplashPageController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          Assets.animations.splashAnimation.path,
          controller: controller.animationController,
          onLoaded: (composition) {
            controller.onAnimationLoaded(composition);
          },
          repeat: false,
          animate: true,
        ),
      ),
    );
  }
}
