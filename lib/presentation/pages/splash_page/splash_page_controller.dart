import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:gas_delivery_app/data/repos/users_repo.dart';
import 'package:gas_delivery_app/presentation/util/resources/navigation_manager.dart';

class SplashPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  UsersRepo usersRepo = Get.find<UsersRepo>();
  // DeepLinkService deepLinkService = Get.find<DeepLinkService>();

  late AnimationController animationController;

  void onAnimationLoaded(LottieComposition composition) {
    animationController.duration = composition.duration;
    animationController.forward();
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        openNextPage();
      }
    });
  }

  @override
  void onInit() {
    animationController = AnimationController(vsync: this);
    // usersRepo.checkUserLoggedInState();
    super.onInit();
  }

  Future<void> openNextPage() async {
    Get.offAllNamed(AppRoutes.loginRoute);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
