import 'package:gas_delivery_app/core/services/network_service/api.dart';
import 'package:gas_delivery_app/core/services/network_service/error_handler.dart';
import 'package:gas_delivery_app/core/services/network_service/remote_api_service.dart';
import 'package:gas_delivery_app/data/models/app_response.dart';
import 'package:gas_delivery_app/data/models/order_model.dart';
import 'package:gas_delivery_app/data/models/paginated_model.dart';
import 'package:get/get.dart';

class OrderRepo extends GetxService {
  final ApiService apiService = Get.find<ApiService>();

  Future<AppResponse<OrderModel>> getOrderById(int orderId) async {
    AppResponse<OrderModel> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: '${Api.orders}/$orderId',
        method: Method.get,
        requiredToken: true,
        withLogging: true,
      );

      appResponse.success = true;
      appResponse.data = OrderModel.fromJson(
        response.data?['data']?['order'] ?? {},
      );
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }

    return appResponse;
  }

  Future<AppResponse<PaginatedModel<OrderModel>>> getOrders({
    required int page,
    int pageSize = 10,
  }) async {
    AppResponse<PaginatedModel<OrderModel>> appResponse = AppResponse(
      success: false,
    );

    try {
      final response = await apiService.request(
        url: Api.myOrders,
        method: Method.get,
        requiredToken: true,
        withLogging: true,
        queryParameters: {'page': page, 'per_page': pageSize},
      );
      appResponse.success = true;
      appResponse.data = PaginatedModel<OrderModel>.fromJson(
        response.data ?? {},
        (e) => OrderModel.fromJson(e),
      );
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<PaginatedModel<OrderModel>>> getNewOrders({
    required int page,
    int pageSize = 10,
  }) async {
    AppResponse<PaginatedModel<OrderModel>> appResponse = AppResponse(
      success: false,
    );

    try {
      final response = await apiService.request(
        url: Api.newOrders,
        method: Method.get,
        requiredToken: false,
        withLogging: true,
        queryParameters: {'page': page, 'per_page': pageSize},
      );
      appResponse.success = true;
      appResponse.data = PaginatedModel<OrderModel>.fromJson(
        response.data ?? {},
        (e) => OrderModel.fromJson(e),
      );
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<void>> acceptOrder(int orderId) async {
    AppResponse<void> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: '${Api.driverOrders}/accept/$orderId',
        method: Method.post,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage =
          response.data['message'] ?? 'Order accepted successfully';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<void>> rejectOrder(int orderId) async {
    AppResponse<void> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: '${Api.driverOrders}/reject/$orderId',
        method: Method.post,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage =
          response.data['message'] ?? 'Order rejected successfully';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<void>> startOrder(int orderId) async {
    AppResponse<void> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: '${Api.driverOrders}/start/$orderId',
        method: Method.post,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage =
          response.data['message'] ?? 'Order started successfully';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<void>> completeOrder(int orderId) async {
    AppResponse<void> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: '${Api.driverOrders}/complete/$orderId',
        method: Method.post,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage =
          response.data['message'] ?? 'Order completed successfully';
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }
}
