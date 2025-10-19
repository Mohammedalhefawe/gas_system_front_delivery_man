// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart' as dio;
// import 'package:app_set_id/app_set_id.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:gas_delivery_app/core/services/cache_service.dart';
// import 'package:gas_delivery_app/core/services/deep_link_service.dart';
// import 'package:gas_delivery_app/core/services/network_service/error_handler.dart';
// import 'package:gas_delivery_app/core/services/network_service/remote_api_service.dart';
// import 'package:gas_delivery_app/data/models/app_response.dart';
// import 'package:gas_delivery_app/data/repos/users_repo.dart';
// import 'package:gas_delivery_app/core/services/network_service/api.dart';
// import 'package:gas_delivery_app/data/dto/get_notifications_dto.dart';
// import 'package:gas_delivery_app/data/models/notification_model.dart';
// import 'package:gas_delivery_app/data/models/paginated_model.dart';
// //import 'package:huawei_push/huawei_push.dart' as huawei_push;

// Future<void> onBackgroundMessageReceived(RemoteMessage message) async {
//   debugPrint("Title: ${message.notification?.title}");
//   debugPrint("Body: ${message.notification?.body}");
//   debugPrint("Payload: ${message.data}");
// }

// class NotificationRepo {
//   ApiService apiService = Get.find<ApiService>();
//   CacheService cacheService = Get.find<CacheService>();
//   UsersRepo usersRepo = Get.find<UsersRepo>();
//   DeepLinkService deepLinkService = Get.find<DeepLinkService>();

//   final _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initialize() async {
//     final response = await _firebaseMessaging.requestPermission();
//     final status = response.authorizationStatus;
//     final fCMToken = cacheService.getFCMToken();
//     if (status == AuthorizationStatus.authorized && fCMToken == null) {
//       final fCMToken = await _firebaseMessaging.getToken();

//       debugPrint("FCM ==========> $fCMToken");

//       //Register to all topics
//       _firebaseMessaging.subscribeToTopic("all");

//       debugPrint("saving fcm in cache");
//       cacheService.storeFCMToken(fCMToken!);
//       cacheService.storePushNotification(true);

//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         debugPrint('Message data: ${message.data}');

//         if (message.notification != null) {
//           _showLocalizedNotification(message);
//         }
//       });
//       FirebaseMessaging.onBackgroundMessage(onBackgroundMessageReceived);
//       FirebaseMessaging.onMessageOpenedApp.listen((event) {
//         handleNotificationClick(event);
//       });

//       debugPrint("${usersRepo.userLoggedIn.value}");

//       if (usersRepo.userLoggedIn.value) {
//         debugPrint("Sending FCM to server:========");
//         //sendFCMForUser();

//         //Check if the app opened from FCM
//         var terminatedMessage = await FirebaseMessaging.instance
//             .getInitialMessage();
//         if (terminatedMessage != null) {
//           await Future.delayed(const Duration(seconds: 3));
//           handleNotificationClick(terminatedMessage);
//         }
//       }
//       setupLocalNotification();

//       //setupHuaweiPushKit();
//     }
//   }

//   /*String pushKitToken = "";

//   void setupHuaweiPushKit() {
//     huawei_push.Push.getTokenStream.listen((event) {
//       // This function gets called when we receive the token successfully
//       pushKitToken = event;
//       print('Push Token: $pushKitToken');
//       huawei_push.Push.showToast(event);
//     }, onError: (error) {
//       pushKitToken = error;

//       huawei_push.Push.showToast(error);
//     });
//     huawei_push.Push.getToken("");
//   }*/

//   void handleNotificationClick(dynamic message) async {
//     debugPrint("handle notification click");
//     debugPrint(message);

//     String route = message.data['payload_route'];

//     debugPrint("Extracted route: $route");

//     if ( /*route == null || */ route.isEmpty) {
//       deepLinkService.handleDeepLink('');
//       return;
//     }
//     deepLinkService.handleDeepLink(route);
//   }

//   final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   Future<void> setupLocalNotification() async {
//     const androidInitializationSetting = AndroidInitializationSettings(
//       '@mipmap/launcher_icon',
//     );
//     const iosInitializationSetting = DarwinInitializationSettings();
//     const initSettings = InitializationSettings(
//       android: androidInitializationSetting,
//       iOS: iosInitializationSetting,
//     );
//     await _flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: handleLocalNotificationClick,
//     );
//   }

//   void handleLocalNotificationClick(NotificationResponse response) {
//     debugPrint('Local notification clicked with payload: ${response.payload}');
//     if (response.payload == null) {
//       handleNotificationClick({});
//       return;
//     }
//     handleNotificationClick(response.payload);
//   }

//   void _showLocalizedNotification(RemoteMessage message) async {
//     final language = cacheService.getLanguage();
//     String title = message.notification?.title ?? "New notification";
//     String body =
//         message.notification?.body ?? "Cannot show notification content";

//     title = message.data['title_$language'];
//     body = message.data['body_$language'];

//     showNotification(title, body, message.data);
//   }

//   void showNotification(String title, String body, var payload) async {
//     var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
//       '0',
//       'general',
//       importance: Importance.max,
//       playSound: true,
//       //sound: AndroidNotificationSound,
//       showProgress: true,
//       priority: Priority.high,
//     );

//     var iOSChannelSpecifics = const DarwinNotificationDetails();
//     var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSChannelSpecifics,
//     );
//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: jsonEncode(payload),
//     );
//   }

//   Future<AppResponse> sendFCMForUser() async {
//     AppResponse appResponse = AppResponse(success: false);
//     String? fcmToken = cacheService.getFCMToken();

//     if (fcmToken == null) {
//       debugPrint("No FCM token");
//       fcmToken = await _firebaseMessaging.getToken();

//       debugPrint("FCM ==========> $fcmToken");

//       debugPrint("saving fcm in cache");
//       cacheService.storeFCMToken(fcmToken!);
//     } else {
//       debugPrint("FCM token found");
//     }

//     try {
//       String? deviceId = await AppSetId().getIdentifier();
//       String platform = Platform.isAndroid ? "android" : "ios";

//       Map<String, dynamic> requestData = {
//         "token": fcmToken,
//         "device_id": deviceId,
//         "platform": platform,
//       };

//       try {
//         await apiService.request(
//           url: "notifications/device-tokens",
//           method: Method.post,
//           params: requestData,
//           requiredToken: true,
//         );
//         appResponse.success = true;
//         debugPrint("FCM token sent successfully");
//       } catch (e) {
//         debugPrint("Error sending FCM token: ${e.toString()}");
//         appResponse.success = false;
//         appResponse.networkFailure = ErrorHandler.handle(e).failure;
//       }
//     } catch (e) {
//       print("fhdgsfgdfdsdsf: ${e.toString()}");
//     }
//     return appResponse;
//   }

//   Future<AppResponse> removeFCM() async {
//     String? fcmToken = cacheService.getFCMToken();

//     AppResponse appResponse = AppResponse(success: false);

//     if (fcmToken == null) {
//       debugPrint("No FCM token to remove");
//       appResponse.success = true;
//       return appResponse;
//     }

//     Map<String, dynamic> requestData = {"token": fcmToken};

//     try {
//       await apiService.request(
//         url: "notifications/device-tokens",
//         method: Method.delete,
//         params: requestData,
//         requiredToken: true,
//       );
//       appResponse.success = true;
//       debugPrint("FCM token removed successfully");
//     } catch (e) {
//       debugPrint("Error removing FCM token: ${e.toString()}");
//       appResponse.success = false;
//       appResponse.networkFailure = ErrorHandler.handle(e).failure;
//     }
//     return appResponse;
//   }

//   Future<AppResponse<PaginatedModel<NotificationModel>>> getNotifications(
//     GetNotificationsDto dto,
//   ) async {
//     AppResponse<PaginatedModel<NotificationModel>> appResponse = AppResponse(
//       success: false,
//     );

//     try {
//       dio.Response response = await apiService.request(
//         url: Api.notifications,
//         method: Method.get,
//         requiredToken: true,
//         withLogging: true,
//         queryParameters: dto.toQueryParams(),
//       );

//       appResponse.success = true;
//       appResponse.data = PaginatedModel<NotificationModel>.fromJson(
//         response.data,
//         (json) => NotificationModel.fromJson(json),
//       );
//     } catch (e) {
//       appResponse.success = false;
//       appResponse.networkFailure = ErrorHandler.handle(e).failure;
//     }

//     return appResponse;
//   }
// }
