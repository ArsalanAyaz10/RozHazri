import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:roz_hazri/app/routes/app_pages.dart';

class SplashController extends GetxController {
  var pin = ''.obs;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    getPin();
  }

  @override
  void onReady() {
    super.onReady();
    precacheImage(
      const AssetImage('assets/images/splash_logo.png'),
      Get.context!,
    );
  }

  void navigateToPinSetup() {
    Get.offNamed('/pin');
  }

  void getPin() async {
    final value = await _storage.read(key: 'user_pin');
    pin.value = value ?? '';
    if (pin.value.isEmpty) {
      navigateToPinSetup();
    } else {
      Get.offNamed(Routes.matchpin);
    }
    if (kDebugMode) {
      print("Pin retrieved in Home: ${pin.value}");
    }
  }
}
