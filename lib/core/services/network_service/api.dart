abstract class Api {
  static const String imageBaseUrl = "http://165.227.133.66/storage/";

  /// Authentication
  static const String register = "auth/register/customer";
  static const String login = "auth/login";
  static const String logout = "auth/logout";
  static const String verify = "auth/customer/verify";
  static const String resendPin = "auth/customer/resend-pin";
  static const String forgetPassword = 'auth/customer/forgot-password';
  static const String verifyResetPin = 'auth/customer/verify-reset-pin';
  static const String resetPassword = 'auth/customer/reset-password';

  /// Products
  static const String products = "products";

  /// Ads
  static const String ads = "ads";

  /// Addresses
  static const String addresses = "addresses";

  ///Product Reviews
  static const String productReviews = "product-reviews";

  ///Orders
  static const String orders = "driver/orders";
  static const String myOrders = "driver/my-orders";
  static const String driverOrders = "driver";
  static const String newOrders = "orders?status=pending";

  ///Delivery Fees
  static const String deliveryFee = "delivery-fee";

  ///notifications
  static const String notifications = "notifications";
}
