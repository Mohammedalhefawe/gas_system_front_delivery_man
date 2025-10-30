import 'dart:convert';
import 'package:gas_delivery_app/core/services/network_service/api.dart';
import 'package:gas_delivery_app/data/dto/login_response_dto.dart';
import 'package:gas_delivery_app/data/models/app_response.dart';
import 'package:gas_delivery_app/data/models/user_model.dart';
import 'package:gas_delivery_app/presentation/util/resources/navigation_manager.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/core/services/cache_service.dart';
import 'package:gas_delivery_app/core/services/network_service/error_handler.dart';
import 'package:gas_delivery_app/core/services/network_service/remote_api_service.dart';

class UsersRepo extends GetxService {
  ApiService apiService = Get.find<ApiService>();
  CacheService cacheService = Get.find<CacheService>();

  var userLoggedIn = false.obs;
  var loggedInUser = Rx<UserModel>(UserModel.emptyUser());
  Future clearApp() async {
    await cacheService.clearCache();
    Get.offAllNamed(AppRoutes.loginRoute);
  }

  void checkUserLoggedInState() {
    userLoggedIn.value = cacheService.isLoggedIn();
    if (userLoggedIn.value) {
      loggedInUser.value = cacheService.getLoggedInUser();
    } else {
      loggedInUser.value = UserModel.emptyUser();
    }
  }

  bool isMe(UserModel userModel) {
    return userModel == loggedInUser.value;
  }

  UserModel getLoggedInUser() => cacheService.getLoggedInUser();

  Future<AppResponse<LoginResponseDto>> login({
    required String phoneNumber,
    required String password,
  }) async {
    AppResponse<LoginResponseDto> appResponse = AppResponse(success: false);

    var data = jsonEncode({"phone_number": phoneNumber, "password": password});

    try {
      final response = await apiService.request(
        url: Api.login,
        method: Method.post,
        params: data,
        requiredToken: false,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.data = LoginResponseDto.fromJson(response.data);
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<void>> logout() async {
    AppResponse<void> appResponse = AppResponse(success: false);

    try {
      final response = await apiService.request(
        url: Api.logout,
        method: Method.post,
        requiredToken: true,
        withLogging: true,
      );
      appResponse.success = true;
      appResponse.successMessage = response.data['message'];
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    if (appResponse.success) {
      cacheService.clearCache();
      userLoggedIn.value = false;
      loggedInUser.value = UserModel.emptyUser();
    }
    return appResponse;
  }
}
