import 'package:gas_delivery_app/core/services/network_service/api.dart';
import 'package:gas_delivery_app/data/models/ad_model.dart';
import 'package:gas_delivery_app/data/models/app_response.dart';
import 'package:gas_delivery_app/data/models/product_model.dart';
import 'package:gas_delivery_app/data/models/review_model.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/core/services/cache_service.dart';
import 'package:gas_delivery_app/core/services/network_service/error_handler.dart';
import 'package:gas_delivery_app/core/services/network_service/remote_api_service.dart';

class HomeRepo extends GetxService {
  ApiService apiService = Get.find<ApiService>();
  CacheService cacheService = Get.find<CacheService>();

  Future<AppResponse<List<ProductModel>>> getProducts() async {
    AppResponse<List<ProductModel>> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: Api.products,
        method: Method.get,
        requiredToken: false,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.data = (response.data?['data']?['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();

      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<List<AdModel>>> getAds() async {
    AppResponse<List<AdModel>> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: Api.ads,
        method: Method.get,
        requiredToken: false,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.data = (response.data?['data']?['ads'] as List<dynamic>?)
          ?.map((e) => AdModel.fromJson(e as Map<String, dynamic>))
          .toList();

      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<void>> submitReview(ReviewModel review) async {
    AppResponse<void> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: Api.productReviews,
        method: Method.post,
        requiredToken: true,
        withLogging: true,
        params: review.toJson(),
      );
      appResponse.success = true;
      appResponse.successMessage =
          response.data['message'] ?? 'Review submitted successfully';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }
}
