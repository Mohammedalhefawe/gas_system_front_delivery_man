import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:app_set_id/app_set_id.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gas_delivery_app/data/models/paginated_model.dart';
import 'package:gas_delivery_app/presentation/pages/order_details_page/order_details_page.dart';
import 'package:get/get.dart';
import 'package:gas_delivery_app/core/services/cache_service.dart';
import 'package:gas_delivery_app/core/services/network_service/error_handler.dart';
import 'package:gas_delivery_app/core/services/network_service/remote_api_service.dart';
import 'package:gas_delivery_app/data/models/app_response.dart';
import 'package:gas_delivery_app/data/repos/users_repo.dart';
import 'package:gas_delivery_app/core/services/network_service/api.dart';
import 'package:gas_delivery_app/data/models/notification_model.dart';

Future<void> onBackgroundMessageReceived(RemoteMessage message) async {
  debugPrint("Background message: ${message.messageId}");
  debugPrint("Title: ${message.notification?.title}");
  debugPrint("Body: ${message.notification?.body}");
  debugPrint("Payload: ${message.data}");
}

class NotificationRepo {
  ApiService apiService = Get.find<ApiService>();
  CacheService cacheService = Get.find<CacheService>();
  UsersRepo usersRepo = Get.find<UsersRepo>();

  final _firebaseMessaging = FirebaseMessaging.instance;
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    final response = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final status = response.authorizationStatus;

    if (status == AuthorizationStatus.authorized) {
      String? fcmToken = cacheService.getFCMToken();
      if (fcmToken == null) {
        fcmToken = await _firebaseMessaging.getToken();
        debugPrint("FCM Token: $fcmToken");
        if (fcmToken != null) {
          cacheService.storeFCMToken(fcmToken);
          await _firebaseMessaging.subscribeToTopic("drivers");
          print("=====subscribed in drivers=====");
        }
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Foreground message: ${message.data}');
        if (message.notification != null) {
          _showLocalizedNotification(message);
        }
      });

      FirebaseMessaging.onBackgroundMessage(onBackgroundMessageReceived);

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        handleNotificationClick(message);
      });

      final terminatedMessage = await _firebaseMessaging.getInitialMessage();
      if (terminatedMessage != null) {
        await Future.delayed(const Duration(seconds: 3));
        handleNotificationClick(terminatedMessage);
      }

      if (usersRepo.userLoggedIn.value) {
        await sendFCMForUser();
      }

      await setupLocalNotification();
    }
  }

  Future<void> setupLocalNotification() async {
    const androidInitializationSetting = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosInitializationSetting = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidInitializationSetting,
      iOS: iosInitializationSetting,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: handleLocalNotificationClick,
    );
  }

  void handleNotificationClick(RemoteMessage message) {
    print("mohhef......${message.data}");
    debugPrint("Handling notification click: ${message.data}");
    final route = message.data['payload_route'] ?? '/notifications';
    Get.toNamed(route);
  }

  void handleLocalNotificationClick(NotificationResponse response) {
    debugPrint('Local notification clicked with payload: ${response.payload}');
    if (response.payload != null) {
      final payload = jsonDecode(response.payload!);
      Get.to(
        DriverOrderDetailsPage(),
        arguments: int.parse(payload['order_id']),
      );
    }
  }

  void _showLocalizedNotification(RemoteMessage message) async {
    final language = cacheService.getLanguage();
    String title = message.notification?.title ?? "New Notification";
    String body =
        message.notification?.body ?? "Cannot show notification content";

    title = message.data['title_$language'] ?? title;
    body = message.data['body_$language'] ?? body;

    showNotification(title, body, message.data);
  }

  void showNotification(
    String title,
    String body,
    Map<String, dynamic> payload,
  ) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'general_channel',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      channelShowBadge: true,
    );

    const iOSChannelSpecifics = DarwinNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode(payload),
    );
  }

  Future<AppResponse> sendFCMForUser() async {
    AppResponse appResponse = AppResponse(success: false);
    String? fcmToken = cacheService.getFCMToken();

    if (fcmToken == null) {
      fcmToken = await _firebaseMessaging.getToken();
      debugPrint("FCM Token: $fcmToken");
      if (fcmToken != null) {
        cacheService.storeFCMToken(fcmToken);
      } else {
        debugPrint("Failed to get FCM token");
        return appResponse;
      }
    }

    try {
      String? deviceId = await AppSetId().getIdentifier();
      String platform = Platform.isAndroid ? "android" : "ios";

      Map<String, dynamic> requestData = {
        "token": fcmToken,
        "device_id": deviceId ?? "unknown",
        "platform": platform,
        "app_version": "1.0.0",
      };

      await apiService.request(
        url: "notifications/device-tokens",
        method: Method.post,
        params: requestData,
        requiredToken: true,
      );
      appResponse.success = true;
      debugPrint("FCM token sent successfully");
    } catch (e) {
      debugPrint("Error sending FCM token: ${e.toString()}");
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse> removeFCM() async {
    AppResponse appResponse = AppResponse(success: false);
    String? fcmToken = cacheService.getFCMToken();

    if (fcmToken == null) {
      debugPrint("No FCM token to remove");
      appResponse.success = true;
      return appResponse;
    }

    try {
      Map<String, dynamic> requestData = {"token": fcmToken};

      await apiService.request(
        url: "notifications/device-tokens",
        method: Method.delete,
        params: requestData,
        requiredToken: true,
      );
      appResponse.success = true;
      cacheService.storeFCMToken(fcmToken);
      debugPrint("FCM token removed successfully");
    } catch (e) {
      debugPrint("Error removing FCM token: ${e.toString()}");
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }
    return appResponse;
  }

  Future<AppResponse<PaginatedModel<NotificationModel>>> getNotifications({
    required int page,
    int pageSize = 10,
  }) async {
    AppResponse<PaginatedModel<NotificationModel>> appResponse = AppResponse(
      success: false,
    );

    try {
      dio.Response response = await apiService.request(
        url: Api.notifications,
        method: Method.get,
        requiredToken: true,
        withLogging: true,
        queryParameters: {'page': page, 'per_page': pageSize},
      );

      appResponse.success = true;
      appResponse.data = PaginatedModel<NotificationModel>.fromJson(
        response.data ?? {},
        (e) => NotificationModel.fromJson(e),
      );
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
    }

    return appResponse;
  }

  Future<AppResponse> markNotificationAsRead(int notificationId) async {
    AppResponse appResponse = AppResponse(success: false);

    try {
      await apiService.request(
        url: "${Api.notifications}/$notificationId/mark-read",
        method: Method.post,
        requiredToken: true,
        withLogging: true,
      );

      appResponse.success = true;
      appResponse.successMessage = "Notification marked as read";
    } catch (e) {
      appResponse.success = false;
      appResponse.networkFailure = ErrorHandler.handle(e).failure;
      debugPrint("Error marking notification as read: ${e.toString()}");
    }

    return appResponse;
  }
}
