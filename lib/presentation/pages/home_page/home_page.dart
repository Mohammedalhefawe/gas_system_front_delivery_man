import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/product_model.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';
import 'package:gas_delivery_app/presentation/pages/home_page/home_page_controller.dart';
import 'package:gas_delivery_app/presentation/pages/home_page/widgets/ad_space_widget.dart';
import 'package:gas_delivery_app/presentation/pages/home_page/widgets/products_widget.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/navigation_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchProducts();
        await controller.fetchAds();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              if (controller.adsLoadingState.value == LoadingState.loading) {
                return const AdSpace(ads: [], isLoading: true);
              }
              if (controller.adsLoadingState.value == LoadingState.hasError) {
                return _buildErrorState(
                  context,
                  'FailedToLoadAds'.tr,
                  controller.fetchAds,
                );
              }
              return AdSpace(ads: controller.ads);
            }),
            Obx(() {
              if (controller.productsLoadingState.value ==
                  LoadingState.loading) {
                return const PopularPacks(
                  products: [],
                  onAddToCart: _emptyCallback,
                  onAddToReview: _emptyCallback,
                  isLoading: true,
                );
              }
              if (controller.productsLoadingState.value ==
                  LoadingState.hasError) {
                return _buildErrorState(
                  context,
                  'FailedToLoadProducts'.tr,
                  controller.fetchProducts,
                );
              }
              return PopularPacks(
                products: controller.products,
                onAddToCart: (product) {
                  if (product.isExistInCart) return;
                  controller.cartController.addToCart(product);
                },
                onAddToReview: (product) {
                  Get.toNamed(AppRoutes.addReviewRoute, arguments: product.id);
                },
              );
            }),

            SizedBox(height: AppSize.s16),
          ],
        ),
      ),
    );
  }

  static void _emptyCallback(ProductModel product) {}

  Widget _buildErrorState(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: FontSize.s16,
              color: ColorManager.colorDoveGray600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSize.s16),
          AppButton(
            onPressed: onRetry,
            text: 'Retry'.tr,
            backgroundColor: ColorManager.colorPrimary,
          ),
        ],
      ),
    );
  }
}
