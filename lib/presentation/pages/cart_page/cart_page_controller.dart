import 'package:gas_delivery_app/core/services/cache_service.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/repos/delivery_fee_repo.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/data/models/cart_item_model.dart';
import 'package:gas_delivery_app/data/models/product_model.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';

class CartController extends GetxController {
  final CacheService cacheService = Get.find<CacheService>();
  final DeliveryFeeRepo deliveryFeeRepo = Get.find<DeliveryFeeRepo>();
  final cartItems = <CartItemModel>[].obs;
  final deliveryFeeState = LoadingState.idle.obs;

  RxInt deliveryFee = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    Future.delayed(Duration(seconds: 1), () => loadCart());
    fetchDeliveryFee();
  }

  Future<void> fetchDeliveryFee() async {
    final response = await deliveryFeeRepo.getDeliveryFee();

    if (!response.success) {
      deliveryFeeState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }
    deliveryFee.value = response.data?.fee != null
        ? double.parse(response.data!.fee).toInt()
        : 0;

    deliveryFeeState.value = LoadingState.doneWithData;
  }

  void loadCart() {
    cartItems.value = cacheService.getCartItems();
  }

  bool isProductInCart(int productId) {
    return cartItems.any((item) => item.product.id == productId);
  }

  void addToCart(ProductModel product, {int quantity = 1}) {
    if (!product.isAvailable) {
      CustomToasts(
        message: 'ProductOutOfStock'.tr,
        type: CustomToastType.error,
      ).show();
      return;
    }
    final cartItem = CartItemModel(product: product, quantity: quantity);
    cacheService.addToCart(cartItem);
    loadCart();
    CustomToasts(
      message: 'AddedToCart'.trParams({'': product.productName}),
      type: CustomToastType.success,
    ).show();
  }

  void removeFromCart(int productId) {
    cacheService.removeFromCart(productId);
    loadCart();
    CustomToasts(
      message: 'RemovedFromCart'.tr,
      type: CustomToastType.success,
    ).show();
  }

  void updateQuantity(int productId, int quantity) {
    cacheService.updateCartItemQuantity(productId, quantity);
    loadCart();
    CustomToasts(
      message: 'CartUpdated'.tr,
      type: CustomToastType.success,
    ).show();
  }

  void clearCart() {
    cacheService.clearCart();
    loadCart();
    CustomToasts(
      message: 'CartCleared'.tr,
      type: CustomToastType.success,
    ).show();
  }

  double get totalPrice {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}
