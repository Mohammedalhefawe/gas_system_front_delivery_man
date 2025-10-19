// import 'package:flutter/material.dart';
// import 'package:gas_delivery_app/data/models/product_model.dart';
// import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';
// import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
// import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
// import 'package:gas_delivery_app/presentation/util/widgets/card_widget.dart';
// import 'package:get/get.dart';

// class PopularPacks extends StatelessWidget {
//   final List<ProductModel> products;
//   final Function(ProductModel) onAddToCart;
//   final Function(ProductModel) onAddToReview;

//   const PopularPacks({
//     super.key,
//     required this.products,
//     required this.onAddToCart,
//     required this.onAddToReview,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Section Header
//         Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: AppPadding.p16,
//             vertical: AppPadding.p12,
//           ),
//           child: Row(
//             children: [
//               Text(
//                 "products".tr,
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.w700,
//                   color: ColorManager.colorFontPrimary,
//                 ),
//               ),
//               const Spacer(),
//             ],
//           ),
//         ),
//         SizedBox(height: AppSize.s8),
//         // Products List
//         ListView.separated(
//           scrollDirection: Axis.vertical,
//           itemCount: products.length,
//           physics: NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemBuilder: (context, index) {
//             return ProductTile(
//               data: products[index],
//               onAddToCart: () => onAddToCart(products[index]),
//               onAddToReview: () => onAddToReview(products[index]),
//             );
//           },
//           separatorBuilder: (context, index) {
//             return const SizedBox(height: AppSize.s12);
//           },
//         ),
//       ],
//     );
//   }
// }

// class ProductTile extends StatelessWidget {
//   final ProductModel data;
//   final VoidCallback onAddToCart;
//   final VoidCallback onAddToReview;

//   const ProductTile({
//     super.key,
//     required this.data,
//     required this.onAddToCart,
//     required this.onAddToReview,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: AppPadding.p16),
//       child: CardWidget(
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 // Product Image
//                 data.imageUrl != null
//                     ? Image.network(
//                         data.imageUrl!,
//                         width: AppSize.s100,
//                         height: AppSize.s100,
//                         fit: BoxFit.fill,
//                         errorBuilder: (context, error, stackTrace) =>
//                             _buildImagePlaceholder(),
//                       )
//                     : _buildImagePlaceholder(),

//                 // Product Details
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Product Name
//                       Text(
//                         data.productName,
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           color: ColorManager.colorFontPrimary,
//                           fontWeight: FontWeight.w600,
//                           fontSize: FontSize.s16,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: AppSize.s8),

//                       // Description
//                       Text(
//                         data.description,
//                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: ColorManager.colorDoveGray600,
//                           fontSize: FontSize.s12,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),

//                       const SizedBox(height: AppSize.s8),
//                       Text(
//                         '${data.price} ${'SP'.tr}',
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           color: ColorManager.colorPrimary,
//                           fontWeight: FontWeight.w700,
//                           fontSize: FontSize.s18,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: AppSize.s12),
//             Row(
//               children: [
//                 Expanded(
//                   child: AppButton(
//                     onPressed: onAddToReview,
//                     backgroundColor: ColorManager.colorBlack.withValues(
//                       alpha: 0.6,
//                     ),
//                     text: "Review".tr,
//                   ),
//                 ),
//                 SizedBox(width: AppSize.s12),
//                 Expanded(
//                   flex: 2,
//                   child: AppButton(
//                     onPressed: onAddToCart,
//                     backgroundColor: ColorManager.colorPrimary.withValues(
//                       alpha: 0.8,
//                     ),
//                     text: "AddToCart".tr,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /*  // Add to Cart Button
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: data.isAvailable ? onAddToCart : null,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: data.isAvailable
//                                   ? ColorManager.colorPrimary
//                                   : ColorManager.colorGrey5,
//                               foregroundColor: data.isAvailable
//                                   ? Colors.white
//                                   : ColorManager.colorDoveGray600,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(
//                                   AppSize.s12,
//                                 ),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: AppPadding.p10,
//                               ),
//                               elevation: 0,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.shopping_cart_rounded,
//                                   size: AppSize.s16,
//                                 ),
//                                 const SizedBox(width: AppSize.s6),
//                                 Text(
//                                   data.isAvailable
//                                       ? "AddToCart".tr
//                                       : "OutOfStock".tr,
//                                   style: TextStyle(
//                                     fontSize: FontSize.s14,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ), */

//   Widget _buildImagePlaceholder() {
//     return Center(
//       child: Icon(
//         Icons.gas_meter_rounded,
//         size: AppSize.s34,
//         color: ColorManager.colorDoveGray600,
//       ),
//     );
//   }
// }

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
    if (products.isEmpty) {
      return _buildEmptyProducts(context);
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
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Navigate to full products page
                },
                child: Text("SeeAll".tr),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSize.s8),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
              child: ProductTile(
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

  Widget _buildEmptyProducts(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p12,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p16),
        decoration: BoxDecoration(
          color: ColorManager.colorGrey5,
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
        child: Text(
          "NoProductsAvailable".tr,
          style: TextStyle(
            fontSize: FontSize.s16,
            color: ColorManager.colorDoveGray600,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final ProductModel data;
  final VoidCallback onAddToCart;
  final VoidCallback onAddToReview;

  const ProductTile({
    super.key,
    required this.data,
    required this.onAddToCart,
    required this.onAddToReview,
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
                          '${data.price.toStringAsFixed(2)} ${'SP'.tr}',
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
                      backgroundColor: ColorManager.colorBlack.withOpacity(0.6),
                      text: "Review".tr,
                    ),
                  ),
                  const SizedBox(width: AppSize.s12),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      onPressed: data.isAvailable ? onAddToCart : null,
                      backgroundColor: data.isAvailable
                          ? ColorManager.colorPrimary.withOpacity(0.8)
                          : ColorManager.colorGrey5,
                      text: data.isAvailable ? "AddToCart".tr : "OutOfStock".tr,
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
