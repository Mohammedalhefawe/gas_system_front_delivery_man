import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gas_delivery_app/core/app/app.dart';
import 'package:gas_delivery_app/core/app_config/app_binding.dart';
import 'package:gas_delivery_app/core/app_config/app_translation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  AppBinding().dependencies();
  await AppTranslations.init();

  runApp(
    DevicePreview(
      builder: (context) => MyApp(),
      enabled: F, // enable if u want to test devices
    ),
  );
}
