import 'package:flutter/material.dart';
import 'package:gas_delivery_app/presentation/pages/account_page/account_page.dart';
import 'package:gas_delivery_app/presentation/pages/orders_page/orders_page.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/presentation/pages/main_page/main_page_controller.dart';
import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/navigation_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:badges/badges.dart' as badges;

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorManager.colorBackground,
        appBar: MainPageAppBar(),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (pageIndex) {
            controller.pageIndex.value = pageIndex;
          },
          controller: controller.pageController,
          children: const [DriverOrdersPage(), AccountPage()],
        ),
        bottomNavigationBar: MainPageNavBar(),
        // floatingActionButton: MainPageButton(),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class MainPageAppBar extends GetView<MainController>
    implements PreferredSizeWidget {
  const MainPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int pageIndex = controller.pageIndex.value;

      if (pageIndex == ordersTabIndex) {
        return AppBar(
          backgroundColor: ColorManager.colorBackground,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text('orders'.tr, style: Get.textTheme.titleLarge),

          actions: [
            SizedBox(width: AppSize.sWidth * 0.06),
            InkWell(
              onTap: () async {
                Get.toNamed(AppRoutes.notificationRoute);
              },
              child: badges.Badge(
                showBadge: controller.notificationsCount.value != 0,
                position: badges.BadgePosition.topStart(),
                badgeContent: Text(
                  controller.notificationsCount.value.toString(),
                  style: Get.textTheme.labelSmall!.copyWith(
                    color: ColorManager.colorWhite,
                  ),
                ),
                child: Assets.icons.notificationIcon.svg(
                  width: AppSize.sWidth * 0.065,
                ),
              ),
            ),
            SizedBox(width: AppSize.sWidth * 0.06),
          ],
        );
      }
      if (pageIndex == accountTabIndex) {
        return AppBar(
          backgroundColor: ColorManager.colorBackground,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text('account'.tr, style: Get.textTheme.titleLarge),
          actions: [
            SizedBox(width: AppSize.sWidth * 0.06),
            InkWell(
              onTap: () async {
                Get.toNamed(AppRoutes.notificationRoute);
              },
              child: badges.Badge(
                showBadge: controller.notificationsCount.value != 0,
                position: badges.BadgePosition.topStart(),
                badgeContent: Text(
                  controller.notificationsCount.value.toString(),
                  style: Get.textTheme.labelSmall!.copyWith(
                    color: ColorManager.colorWhite,
                  ),
                ),
                child: Assets.icons.notificationIcon.svg(
                  width: AppSize.sWidth * 0.065,
                ),
              ),
            ),
            SizedBox(width: AppSize.sWidth * 0.06),
          ],
        );
      }

      return SizedBox();
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MainPageNavBar extends GetView<MainController> {
  const MainPageNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final navBarHeight = height * 0.087;

    return Obx(() {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0,
            child: child,
          );
        },
        child: controller.showNavBar.value
            ? Container(
                key: const ValueKey("NavBar"),
                height: navBarHeight,
                decoration: const BoxDecoration(color: ColorManager.colorWhite),
                child: BottomNavigationBar(
                  currentIndex: controller.pageIndex.value,
                  onTap: (index) async {
                    controller.changePage(index);
                  },
                  items:
                      [
                        // NavBarItem('home'.tr, Assets.icons.homeIcon),
                        NavBarItem('orders'.tr, Assets.icons.adsIcon),
                        NavBarItem('account'.tr, Assets.icons.userAccountIcon),
                      ].asMap().entries.map((item) {
                        return BottomNavigationBarItem(
                          icon: Padding(
                            padding: EdgeInsets.only(bottom: height * 0.003),
                            child:
                                item.value.icon?.svg(
                                  width: AppSize.sWidth * 0.058,
                                  colorFilter: ColorFilter.mode(
                                    controller.pageIndex.value == item.key
                                        ? ColorManager.colorSecondary
                                        : ColorManager.colorBlack,
                                    BlendMode.srcIn,
                                  ),
                                ) ??
                                SizedBox(height: height * 0.025),
                          ),
                          label: item.value.name,
                        );
                      }).toList(),
                ),
              )
            : SizedBox.shrink(),
      );
    });
  }
}

class NavBarItem {
  final String name;
  final SvgGenImage? icon;

  NavBarItem(this.name, this.icon);
}
