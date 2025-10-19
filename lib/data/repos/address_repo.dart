import 'package:gas_delivery_app/core/services/network_service/api.dart';
import 'package:gas_delivery_app/core/services/network_service/error_handler.dart';
import 'package:gas_delivery_app/core/services/network_service/remote_api_service.dart';
import 'package:gas_delivery_app/data/models/address_model.dart';
import 'package:gas_delivery_app/data/models/app_response.dart';
import 'package:get/get.dart';

class AddressRepo extends GetxService {
  final ApiService apiService = Get.find<ApiService>();

  Future<AppResponse<List<AddressModel>>> getAddresses() async {
    AppResponse<List<AddressModel>> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: Api.addresses,
        method: Method.get,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.data =
          (response.data?['data']?['addresses'] as List<dynamic>?)
              ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
              .toList();
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<AddressModel>> addAddress(AddressModel address) async {
    AppResponse<AddressModel> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: Api.addresses,
        method: Method.post,
        requiredToken: true,
        withLogging: true,
        params: address.toJson(),
      );
      appResponse.success = true;
      appResponse.data = AddressModel.fromJson(
        response.data['data']['address'],
      );
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<AddressModel>> updateAddress(
    int addressId,
    AddressModel address,
  ) async {
    AppResponse<AddressModel> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: '${Api.addresses}/$addressId',
        method: Method.put,
        requiredToken: true,
        withLogging: true,
        params: address.toJson(),
      );
      appResponse.success = true;
      appResponse.data = AddressModel.fromJson(
        response.data['data']['address'],
      );
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse> deleteAddress(int addressId) async {
    AppResponse<void> appResponse = AppResponse(success: false);

    try {
      apiService.request(
        url: '${Api.addresses}/$addressId',
        method: Method.delete,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage = "Address deleted successfully";
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }
}
