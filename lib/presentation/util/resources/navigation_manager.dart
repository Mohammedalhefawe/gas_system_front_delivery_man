import 'package:gas_delivery_app/presentation/pages/add_review_product_page/add_review_product_controller.dart';
import 'package:gas_delivery_app/presentation/pages/add_review_product_page/add_review_product_page.dart';
import 'package:gas_delivery_app/presentation/pages/address_page/address_page.dart';
import 'package:gas_delivery_app/presentation/pages/address_page/address_page_controller.dart';
import 'package:gas_delivery_app/presentation/pages/auth/login_page/login_page.dart';
import 'package:gas_delivery_app/presentation/pages/auth/login_page/login_page_controller.dart';
import 'package:gas_delivery_app/presentation/pages/cart_page/cart_page.dart';
import 'package:gas_delivery_app/presentation/pages/cart_page/cart_page_controller.dart';
import 'package:gas_delivery_app/presentation/pages/main_page/main_page.dart';
import 'package:gas_delivery_app/presentation/pages/main_page/main_page_controller.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/presentation/pages/splash_page/splash_page.dart';
import 'package:gas_delivery_app/presentation/pages/splash_page/splash_page_controller.dart';

abstract class NavigationManager {
  static final getPages = [
    // GetPage(
    //   name: AppRoutes.deepLinkMeal,
    //   page: () {
    //     int mealId = -1;
    //     Future.delayed(const Duration(milliseconds: 100), () {});
    //     if (Get.parameters['id'] != null) {
    //       mealId = int.parse(Get.parameters['id']!);
    //     }
    //     return SplashPage(
    //       deepLinkMeal: mealId,
    //       deepLinkPerson: -1,
    //     );
    //   },
    // ),
    GetPage(
      name: AppRoutes.splashRoute,
      page: () => SplashPage(),
      binding: BindingsBuilder.put(() => SplashPageController()),
    ),
    GetPage(
      name: AppRoutes.mainRoute,
      page: () => MainPage(),
      binding: BindingsBuilder.put(() => MainController()),
    ),
    GetPage(
      name: AppRoutes.loginRoute,
      page: () => LoginPage(),
      binding: BindingsBuilder.put(() => LoginPageController()),
    ),

    GetPage(
      name: AppRoutes.cartRoute,
      page: () => CartPage(),
      binding: BindingsBuilder.put(() => CartController()),
    ),

    GetPage(
      name: AppRoutes.addressRoute,
      page: () => AddressListPage(),
      binding: BindingsBuilder.put(() => AddressListController()),
    ),
    GetPage(
      name: AppRoutes.addReviewRoute,
      page: () => AddReviewPage(),
      binding: BindingsBuilder.put(() => AddReviewPageController()),
    ),
  ];
}

abstract class AppRoutes {
  static const String splashRoute = "/";
  static const String mainRoute = "/main";
  static const String homeRoute = "/home";
  static const String loginRoute = "/login";
  static const String cartRoute = "/cartRoute";
  static const String addressRoute = "/addressRoute";
  static const String addReviewRoute = "/addReviewRoute";
  static const String addOrderRoute = "/addOrderRoute";
  static const String myOrderRoute = "/myOrderRoute";
}
