import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/models/product_model.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:gas_delivery_app/presentation/util/widgets/card_widget.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class PopularPacks extends StatelessWidget {
  final List<ProductModel> products;
  final Function(ProductModel) onAddToCart;
  final Function(ProductModel) onAddToReview;
  final bool isLoading;

  const PopularPacks({
    super.key,
    required this.products,
    required this.onAddToCart,
    required this.onAddToReview,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildShimmer(context);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p16,
            vertical: AppPadding.p12,
          ),
          child: Row(
            children: [
              Text(
                "products".tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: ColorManager.colorFontPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSize.s8),

        if (products.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppSize.s40),
              Icon(
                Icons.production_quantity_limits_rounded,
                size: AppSize.s60,
                color: ColorManager.colorDoveGray600,
              ),
              const SizedBox(height: AppSize.s16),
              Text(
                'NoProductsAvailable'.tr,
                style: TextStyle(
                  fontSize: FontSize.s18,
                  color: ColorManager.colorDoveGray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
              child: ProductTile(
                isExistInCart: false,
                data: products[index],
                onAddToCart: () => onAddToCart(products[index]),
                onAddToReview: () => onAddToReview(products[index]),
              ),
            );
          },
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSize.s12),
        ),
      ],
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p12,
      ),
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: AppPadding.p12),
            child: Shimmer.fromColors(
              baseColor: ColorManager.colorDoveGray100,
              highlightColor: ColorManager.colorWhite,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: ColorManager.colorDoveGray300,
                  borderRadius: BorderRadius.circular(AppSize.s12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final ProductModel data;
  final VoidCallback onAddToCart;
  final VoidCallback onAddToReview;
  final bool isExistInCart;

  const ProductTile({
    super.key,
    required this.data,
    required this.onAddToCart,
    required this.onAddToReview,
    required this.isExistInCart,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: AppSize.s100,
                        height: AppSize.s100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSize.s12),
                          color: ColorManager.colorGrey5,
                        ),
                        child:
                            data.imageUrl != null && data.imageUrl!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppSize.s12,
                                ),
                                child: Image.network(
                                  data.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildImagePlaceholder(),
                                ),
                              )
                            : _buildImagePlaceholder(),
                      ),
                      if (!data.isAvailable)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppPadding.p8,
                              vertical: AppPadding.p4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(AppSize.s8),
                                topRight: Radius.circular(AppSize.s8),
                              ),
                            ),
                            child: Text(
                              "OutOfStock".tr,
                              style: TextStyle(
                                color: ColorManager.colorWhite,
                                fontSize: FontSize.s12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: AppSize.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.productName,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: ColorManager.colorFontPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: FontSize.s16,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          semanticsLabel: data.productName,
                        ),
                        const SizedBox(height: AppSize.s8),
                        Text(
                          data.description,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: ColorManager.colorDoveGray600,
                                fontSize: FontSize.s12,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSize.s8),
                        Text(
                          '${data.price.toStringAsFixed(0)} ${'SP'.tr}',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: ColorManager.colorPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: FontSize.s18,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.s12),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onPressed: onAddToReview,
                      backgroundColor: ColorManager.colorBlack.withValues(
                        alpha: .6,
                      ),
                      text: "Review".tr,
                    ),
                  ),
                  const SizedBox(width: AppSize.s12),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      onPressed: data.isAvailable ? onAddToCart : null,
                      backgroundColor: data.isAvailable
                          ? ColorManager.colorPrimary.withValues(alpha: .8)
                          : ColorManager.colorGrey5,
                      text: data.isAvailable
                          ? (isExistInCart ? "AddedToCart".tr : "AddToCart".tr)
                          : "OutOfStock".tr,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Icon(
        Icons.gas_meter_rounded,
        size: AppSize.s34,
        color: ColorManager.colorDoveGray600,
      ),
    );
  }
}
