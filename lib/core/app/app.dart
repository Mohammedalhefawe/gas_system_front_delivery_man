import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import "package:flutter_localizations/flutter_localizations.dart";
import 'package:get/get.dart';
import 'package:gas_delivery_app/core/app_config/app_translation.dart';
import 'package:gas_delivery_app/core/services/cache_service.dart';
import 'package:gas_delivery_app/presentation/util/resources/navigation_manager.dart';
import 'package:gas_delivery_app/presentation/util/resources/theme_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final cacheService = Get.find<CacheService>();
    return GetMaterialApp(
      translations: AppTranslations(),
      useInheritedMediaQuery: true,
      builder: DevicePreview.appBuilder,
      locale: Locale(cacheService.getLanguage()),
      theme: LightModeTheme().themeData,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      getPages: NavigationManager.getPages,
      initialRoute: AppRoutes.loginRoute,
      fallbackLocale: const Locale('ar'),
      supportedLocales: AppTranslations.supportedLocales,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
    );
  }
}
