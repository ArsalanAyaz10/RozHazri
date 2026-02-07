import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roz_hazri/app/bindings/initial_bindings.dart';
import 'package:roz_hazri/app/routes/app_pages.dart';
import 'package:roz_hazri/core/themes/app_theme.dart';

class RozHazriApp extends StatelessWidget {
  const RozHazriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RozHazri',
      initialBinding: InitialBindings(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
    );
  }
}
