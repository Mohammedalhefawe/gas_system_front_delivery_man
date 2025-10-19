import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gas_delivery_app/data/models/user_model.dart';
import 'package:gas_delivery_app/data/models/cart_item_model.dart';

const kUserLoginModelKey = "kUserLoginModelKey";
const kUserTokenKey = "kUserTokenKey";
const kStoreIdKey = "kStoreIdKey";
const kRefreshTokenKey = "kRefreshTokenKey";
const kFCMTokenKey = "kFCMTokenKey";
const kPushNotification = "kPushNotificationKey";
const kLanguageCode = "kLanguageCode";
const kCurrentAccountModeCode = "kCurrentAccountModeCode";
const kCartItemsKey = "kCartItemsKey";

class CacheService extends GetxService {
  late GetStorage _getStorage;

  CacheService() {
    _getStorage = GetStorage();
  }

  Future<void> saveLanguage(String languageCode) async {
    await _getStorage.write(kLanguageCode, languageCode);
  }

  String getLanguage() => _getStorage.read(kLanguageCode) ?? 'ar';

  bool isLoggedIn() => _getStorage.hasData(kUserLoginModelKey);

  int? getStoreId() => _getStorage.read(kStoreIdKey);

  void deleteCurrentUserAndToken() {
    _getStorage.remove(kUserLoginModelKey);
    _getStorage.remove(kUserTokenKey);
    _getStorage.remove(kStoreIdKey);
    _getStorage.remove(kCartItemsKey);
  }

  Future updateUserInfo(UserModel user) async {
    await _getStorage.write(kUserLoginModelKey, user.toRawJson());
  }

  Future storeLoggedInUserAndToken(UserModel user, String token) async {
    await _getStorage.write(kUserLoginModelKey, user.toRawJson());
    await _getStorage.write(kUserTokenKey, token);
  }

  UserModel getLoggedInUser() {
    final result = _getStorage.read(kUserLoginModelKey);
    if (result == null) {
      return UserModel.emptyUser();
    }
    return UserModel.fromRawJson(result);
  }

  Future storeUserToken(String token) async {
    await _getStorage.write(kUserTokenKey, token);
  }

  Future<String> getUserToken() async {
    String? token = _getStorage.read(kUserTokenKey);
    return token ?? "";
  }

  Future storeUserRefreshToken(String refreshToken) async {
    await _getStorage.write(kRefreshTokenKey, refreshToken);
  }

  Future<String> getUserRefreshToken() async {
    String? refreshToken = _getStorage.read(kRefreshTokenKey);
    return refreshToken ?? "";
  }

  void storeFCMToken(String fCMToken) {
    _getStorage.write(kFCMTokenKey, fCMToken);
  }

  String? getFCMToken() {
    return _getStorage.read(kFCMTokenKey);
  }

  void storePushNotification(bool pushNotification) {
    _getStorage.write(kPushNotification, pushNotification);
  }

  bool? getPushNotification() {
    return _getStorage.read(kPushNotification);
  }

  Future clearCache() async {
    await _getStorage.erase();
  }

  // Cart Management
  Future<void> saveCartItems(List<CartItemModel> cartItems) async {
    await _getStorage.write(
      kCartItemsKey,
      cartItems.map((item) => item.toRawJson()).toList(),
    );
  }

  List<CartItemModel> getCartItems() {
    final List<dynamic>? items = _getStorage.read(kCartItemsKey);
    if (items == null) return [];
    print("items: $items");
    return items.map((item) => CartItemModel.fromRawJson(item)).toList();
  }

  Future<void> addToCart(CartItemModel cartItem) async {
    final cartItems = getCartItems();
    final existingItemIndex = cartItems.indexWhere(
      (item) => item.product.id == cartItem.product.id,
    );
    if (existingItemIndex >= 0) {
      cartItems[existingItemIndex] = CartItemModel(
        product: cartItems[existingItemIndex].product,
        quantity: cartItems[existingItemIndex].quantity + cartItem.quantity,
      );
    } else {
      cartItems.add(cartItem);
    }
    await saveCartItems(cartItems);
  }

  Future<void> removeFromCart(int productId) async {
    final cartItems = getCartItems();
    cartItems.removeWhere((item) => item.product.id == productId);
    await saveCartItems(cartItems);
  }

  Future<void> updateCartItemQuantity(int productId, int quantity) async {
    final cartItems = getCartItems();
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0 && quantity > 0) {
      cartItems[index] = CartItemModel(
        product: cartItems[index].product,
        quantity: quantity,
      );
      await saveCartItems(cartItems);
    } else if (index >= 0 && quantity <= 0) {
      await removeFromCart(productId);
    }
  }

  Future<void> clearCart() async {
    await _getStorage.remove(kCartItemsKey);
  }
}
