// lib/app/bindings/unlock_pin_binding.dart
import 'package:get/get.dart';
import 'package:roz_hazri/app/controllers/UnlockPin_controller.dart';

class UnlockPinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UnlockPinController>(() => UnlockPinController());
  }
}