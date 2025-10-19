import 'package:gas_delivery_app/presentation/pages/cart_page/cart_page_controller.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/data/enums/loading_state_enum.dart';
import 'package:gas_delivery_app/data/models/ad_model.dart';
import 'package:gas_delivery_app/data/models/product_model.dart';
import 'package:gas_delivery_app/data/repos/home_repo.dart';
import 'package:gas_delivery_app/presentation/custom_widgets/custom_toasts.dart';

class HomePageController extends GetxController {
  final HomeRepo homeRepo = Get.find<HomeRepo>();
  final CartController cartController = Get.find<CartController>();

  final products = <ProductModel>[].obs;
  final ads = <AdModel>[].obs;
  final productsLoadingState = LoadingState.idle.obs;
  final adsLoadingState = LoadingState.idle.obs;
  final reviewLoadingState = LoadingState.idle.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchAds();
  }

  Future<void> fetchProducts() async {
    productsLoadingState.value = LoadingState.loading;

    final response = await homeRepo.getProducts();

    if (!response.success) {
      productsLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }

    products.value = response.data ?? [];
    for (int i = 0; i < products.length; i++) {
      products[i] = products[i].copyWith(
        isExistInCart: cartController.isProductInCart(products[i].id),
      );
    }
    productsLoadingState.value = LoadingState.doneWithData;
  }

  Future<void> fetchAds() async {
    adsLoadingState.value = LoadingState.loading;

    final response = await homeRepo.getAds();

    if (!response.success) {
      adsLoadingState.value = LoadingState.hasError;
      CustomToasts(
        message: response.getErrorMessage(),
        type: CustomToastType.error,
      ).show();
      return;
    }

    ads.value = response.data ?? [];
    adsLoadingState.value = LoadingState.doneWithData;
  }
}
