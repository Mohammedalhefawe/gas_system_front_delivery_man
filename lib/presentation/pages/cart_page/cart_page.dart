import 'package:flutter/material.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/cart_item_model.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/normal_app_bar.dart';
import 'package:gas_delivery_app/presentation/pages/cart_page/cart_page_controller.dart';
import 'package:gas_delivery_app/presentation/pages/cart_page/widgets/details_paid_widget.dart';
import 'package:gas_delivery_app/presentation/util/resources/assets.gen.dart';
import 'package:gas_delivery_app/presentation/util/resources/color_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/navigation_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/values_manager.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/app_button.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppBar(title: "Cart".tr, backIcon: true),

      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: AppSize.s60,
                  color: ColorManager.colorDoveGray600,
                ),
                const SizedBox(height: AppSize.s16),
                Text(
                  'CartEmpty'.tr,
                  style: TextStyle(
                    fontSize: FontSize.s18,
                    color: ColorManager.colorDoveGray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSize.s8),
                Text(
                  'AddItemsToCart'.tr,
                  style: TextStyle(
                    fontSize: FontSize.s14,
                    color: ColorManager.colorDoveGray600,
                  ),
                ),
              ],
            ),
          );
        }
        return Column(
          children: [
            const SizedBox(height: AppSize.s8),
            Expanded(
              child: ListView.separated(
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return _buildCartItem(item, context);
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSize.s8),
              ),
            ),
            DetailsPaidWidget(
              controller: controller,
              btnWidget: AppButton(
                onPressed: () {
                  // Checkout functionality
                  if (controller.deliveryFeeState.value ==
                          LoadingState.loading ||
                      controller.deliveryFeeState.value ==
                          LoadingState.hasError) {
                    return;
                  }
                  Get.toNamed(AppRoutes.addOrderRoute);
                },
                text: 'OrderNow'.tr,
                backgroundColor: ColorManager.colorPrimary,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCartItem(CartItemModel item, BuildContext context) {
    final totalItemPrice = item.product.price * item.quantity;

    return Container(
      color: ColorManager.colorWhite,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            Row(
              children: [
                // Product Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s12),
                    color: ColorManager.colorGrey5,
                  ),
                  child:
                      item.product.imageUrl != null &&
                          item.product.imageUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(AppSize.s12),
                          child: Image.network(
                            item.product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildImagePlaceholder(),
                          ),
                        )
                      : _buildImagePlaceholder(),
                ),
                const SizedBox(width: AppSize.s12),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.productName,
                                style: TextStyle(
                                  fontSize: FontSize.s16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorManager.colorFontPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: AppSize.s4),
                              Text(
                                item.product.description,
                                style: TextStyle(
                                  fontSize: FontSize.s12,
                                  color: ColorManager.colorDoveGray600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          // Remove item button
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Assets.icons.deleteIcon.svg(width: 22),
                              onPressed: () =>
                                  controller.removeFromCart(item.product.id),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSize.s8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.product.price.toStringAsFixed(0)} ${'SP'.tr}',
                            style: TextStyle(
                              fontSize: FontSize.s14,
                              fontWeight: FontWeight.w600,
                              color: ColorManager.colorPrimary,
                            ),
                          ),
                          SizedBox(height: AppSize.s12),
                          // Quantity Controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Quantity controls with separated buttons
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Decrement button
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorManager.colorGrey4,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppSize.s6,
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(
                                          AppSize.s6,
                                        ),
                                        onTap: item.quantity > 1
                                            ? () => controller.updateQuantity(
                                                item.product.id,
                                                item.quantity - 1,
                                              )
                                            : null,
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                            AppPadding.p4,
                                          ),
                                          child: Icon(
                                            Icons.remove_rounded,
                                            size: AppSize.s18,
                                            color: item.quantity > 1
                                                ? ColorManager.colorFontPrimary
                                                : ColorManager.colorDoveGray600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Quantity display
                                  Container(
                                    width: 40,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${item.quantity}',
                                      style: TextStyle(
                                        fontSize: FontSize.s14,
                                        fontWeight: FontWeight.w600,
                                        color: ColorManager.colorFontPrimary,
                                      ),
                                    ),
                                  ),

                                  // Increment button
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorManager.colorGrey4,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppSize.s6,
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(
                                          AppSize.s6,
                                        ),
                                        onTap: () => controller.updateQuantity(
                                          item.product.id,
                                          item.quantity + 1,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                            AppPadding.p4,
                                          ),
                                          child: Icon(
                                            Icons.add_rounded,
                                            size: AppSize.s18,
                                            color:
                                                ColorManager.colorFontPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: AppSize.s12),

                              // Total price for this item
                              Text(
                                '${totalItemPrice.toStringAsFixed(0)} ${'SP'.tr}',
                                style: TextStyle(
                                  fontSize: FontSize.s12,
                                  fontWeight: FontWeight.w600,
                                  color: ColorManager.colorDoveGray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.colorGrey5,
        borderRadius: BorderRadius.circular(AppSize.s12),
      ),
      child: Center(
        child: Icon(
          Icons.gas_meter_rounded,
          size: AppSize.s34,
          color: ColorManager.colorDoveGray600,
        ),
      ),
    );
  }
}
