import 'package:gas_delivery_app/core/services/network_service/api.dart';
import 'package:gas_delivery_app/core/services/network_service/error_handler.dart';
import 'package:gas_delivery_app/core/services/network_service/remote_api_service.dart';
import 'package:gas_delivery_app/data/models/app_response.dart';
import 'package:gas_delivery_app/data/models/delivery_fee_model.dart';
import 'package:get/get.dart';

class DeliveryFeeRepo extends GetxService {
  final ApiService apiService = Get.find<ApiService>();

  Future<AppResponse<DeliveryFeeModel>> getDeliveryFee() async {
    AppResponse<DeliveryFeeModel> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: Api.deliveryFee,
        method: Method.get,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.data = DeliveryFeeModel.fromJson(
        response.data['data']['delivery_fee'],
      );
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }
}
