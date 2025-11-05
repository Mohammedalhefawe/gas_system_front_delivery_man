import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gas_delivery_app/data/repos/notification_repo.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/core/services/cache_service.dart';
import 'package:gas_delivery_app/data/repos/users_repo.dart';

// const homeTabIndex = 0;
const ordersTabIndex = 0;
const accountTabIndex = 1;

class MainController extends GetxController {
  NotificationRepo notificationRepo = Get.find<NotificationRepo>();
  final UsersRepo usersRepo = Get.find<UsersRepo>();
  final CacheService cacheService = Get.find<CacheService>();
  ScrollController scrollController = ScrollController();
  final showNavBar = true.obs;
  RxInt notificationsCount = 0.obs;

  PageController pageController = PageController(initialPage: ordersTabIndex);
  final pageIndex = ordersTabIndex.obs;

  void changePage(int newIndex) {
    pageIndex.value = newIndex;
    pageController.animateToPage(
      newIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  void _scrollListener() async {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      await (0.3).delay();
      // Scrolling down
      if (showNavBar.value) {
        showNavBar.value = false;
      }
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      await (0.3).delay();
      // Scrolling up
      if (!showNavBar.value) {
        showNavBar.value = true;
      }
    }
  }

  @override
  void onInit() async {
    await init();
    super.onInit();
  }

  Future<void> fetchNotificationsCount() async {
    final response = await notificationRepo.getUnreadNotificationsCount();
    if (!response.success || response.data == null) {
      notificationsCount.value = 0;
      return;
    }
    notificationsCount.value = response.data!;
  }

  Future<void> init() async {
    // usersRepo.checkUserLoggedInState();
    scrollController.addListener(_scrollListener);
    fetchNotificationsCount();
  }
}
