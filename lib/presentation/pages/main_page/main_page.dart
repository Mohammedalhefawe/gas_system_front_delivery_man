import 'package:flutter/material.dart';
import 'package:gas_delivery_app/presentation/pages/account_page/account_page.dart';
import 'package:gas_delivery_app/presentation/pages/cart_page/cart_page_controller.dart';
import 'package:gas_delivery_app/presentation/pages/home_page/home_page.dart';
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
          children: const [HomePage(), DriverOrdersPage(), AccountPage()],
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
    final cartController = Get.find<CartController>();

    return Obx(() {
      int pageIndex = controller.pageIndex.value;
      if (pageIndex == homeTabIndex) {
        return AppBar(
          backgroundColor: ColorManager.colorBackground,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Text('home'.tr, style: Get.textTheme.titleLarge),
              const SizedBox(width: AppSize.s10),
              const Spacer(),
            ],
          ),
          actions: [
            SizedBox(width: AppSize.sWidth * 0.04),
            InkWell(
              onTap: () async {
                Get.toNamed(AppRoutes.cartRoute);
              },
              child: badges.Badge(
                showBadge: cartController.cartItems.isNotEmpty,
                position: badges.BadgePosition.topStart(),
                badgeContent: Text(
                  cartController.cartItems.length.toString(),
                  style: Get.textTheme.labelSmall!.copyWith(
                    color: ColorManager.colorWhite,
                  ),
                ),
                child: Assets.icons.cartIcon.svg(width: AppSize.sWidth * 0.07),
              ),
            ),
            SizedBox(width: AppSize.sWidth * 0.06),
            InkWell(
              onTap: () async {
                // if (await controller.usersRepo.checkLoggedInAndShowDialog()) {
                //   Get.toNamed(AppRoutes.notificationsRoute);
                // }
                Get.toNamed(AppRoutes.addressRoute);
              },
              child: Assets.icons.notificationIcon.svg(
                width: AppSize.sWidth * 0.065,
              ),
            ),
            SizedBox(width: AppSize.sWidth * 0.06),
          ],
        );
      }
      if (pageIndex == ordersTabIndex) {
        return AppBar(
          backgroundColor: ColorManager.colorBackground,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text('orders'.tr, style: Get.textTheme.titleLarge),

          actions: [
            SizedBox(width: AppSize.sWidth * 0.04),
            InkWell(
              onTap: () async {
                Get.toNamed(AppRoutes.cartRoute);
              },
              child: badges.Badge(
                showBadge: cartController.cartItems.isNotEmpty,
                position: badges.BadgePosition.topStart(),
                badgeContent: Text(
                  cartController.cartItems.length.toString(),
                  style: Get.textTheme.labelSmall!.copyWith(
                    color: ColorManager.colorWhite,
                  ),
                ),
                child: Assets.icons.cartIcon.svg(width: AppSize.sWidth * 0.07),
              ),
            ),
            SizedBox(width: AppSize.sWidth * 0.06),
            InkWell(
              onTap: () async {},
              child: Assets.icons.notificationIcon.svg(
                width: AppSize.sWidth * 0.065,
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
          /*title: Row(
            children: [
              Text('account'.tr, style: Get.textTheme.titleLarge),
              const Spacer(),
              if (controller.cacheService.isLoggedIn()) AccountModeSwitch(),
              const Spacer(),
            ],
          ),*/
          actions: [
            SizedBox(width: AppSize.sWidth * 0.035),
            InkWell(
              onTap: () async {
                if (controller.cacheService.isLoggedIn()) {
                  // Get.toNamed(AppRoutes.notificationsRoute);
                } else {
                  Get.toNamed(AppRoutes.loginRoute);
                }
              },
              child: Assets.icons.notificationIcon.svg(
                width: AppSize.sWidth * 0.065,
              ),
            ),
            SizedBox(width: AppSize.sWidth * 0.035),
            InkWell(
              onTap: () {},
              child: Assets.icons.supportIcon.svg(width: AppSize.sWidth * 0.06),
            ),
            SizedBox(width: AppSize.sWidth * 0.035),
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
                        NavBarItem('home'.tr, Assets.icons.homeIcon),
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

// class MainPageButton extends GetView<MainController> {
//   const MainPageButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return AnimatedSwitcher(
//         duration: const Duration(milliseconds: 120),
//         transitionBuilder: (child, animation) {
//           final curvedAnimation = CurvedAnimation(
//             parent: animation,
//             curve: Curves.easeInOut,
//           );
//           final inOffsetAnimation = Tween<Offset>(
//             begin: const Offset(0, 0.4),
//             end: Offset.zero,
//           ).animate(curvedAnimation);
//           final outOffsetAnimation = Tween<Offset>(
//             begin: Offset.zero,
//             end: const Offset(0, -0.4),
//           ).animate(curvedAnimation);
//           final offsetAnimation = animation.status == AnimationStatus.reverse
//               ? outOffsetAnimation
//               : inOffsetAnimation;

//           return SlideTransition(
//             position: offsetAnimation,
//             child: FadeTransition(opacity: animation, child: child),
//           );
//         },
//         child: controller.showNavBar.value
//             ? InkWell(
//                 key: const ValueKey('AddAdsButton'),
//                 onTap: () async {
//                   // if (await controller.usersRepo.checkLoggedInAndShowDialog()) {
//                   //   // Get.toNamed(AppRoutes.addAdsRoute);
//                   // }
//                 },
//                 child: Container(
//                   width: AppSize.sWidth * 0.155,
//                   padding: EdgeInsets.all(AppSize.sWidth * 0.035),
//                   decoration: BoxDecoration(
//                     color: ColorManager.colorPrimary,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Assets.icons.cameraAddIcon.svg(
//                     colorFilter: const ColorFilter.mode(
//                       ColorManager.colorWhite,
//                       BlendMode.srcIn,
//                     ),
//                     width: AppSize.sWidth * 0.067,
//                   ),
//                 ),
//               )
//             : Container(
//                 margin: EdgeInsets.only(bottom: AppSize.sHeight * 0.025),
//                 key: const ValueKey('AppButton'),
//                 width: Get.width * 0.5,
//                 child: AppButton(
//                   onPressed: () async {},
//                   text: "add_ads".tr,
//                   icon: Assets.icons.cameraAddIcon.svg(
//                     width: AppSize.s28,
//                     colorFilter: const ColorFilter.mode(
//                       ColorManager.colorWhite,
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                 ),
//               ),
//       );
//     });
//   }
// }

class NavBarItem {
  final String name;
  final SvgGenImage? icon;

  NavBarItem(this.name, this.icon);
}
