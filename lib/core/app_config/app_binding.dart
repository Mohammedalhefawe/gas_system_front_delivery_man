import 'package:gas_delivery_app/data/repos/address_repo.dart';
import 'package:gas_delivery_app/data/repos/delivery_fee_repo.dart';
import 'package:gas_delivery_app/data/repos/home_repo.dart';
import 'package:gas_delivery_app/data/repos/orders_repo.dart';
import 'package:gas_delivery_app/data/repos/users_repo.dart';
import 'package:gas_delivery_app/presentation/pages/cart_page/cart_page_controller.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/core/services/cache_service.dart';
import 'package:gas_delivery_app/core/services/network_service/remote_api_service.dart';
import 'package:gas_delivery_app/core/services/permission_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CacheService());
    Get.put(ApiService());
    // Get.put(DeepLinkService());
    Get.put(UsersRepo());
    Get.put(HomeRepo());
    Get.put(PermissionService());
    Get.put(DeliveryFeeRepo());
    Get.put(CartController());
    Get.put(AddressRepo());
    Get.put(OrderRepo());
  }
}
