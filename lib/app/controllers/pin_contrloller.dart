import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinController extends GetxController {
  var pin = ''.obs;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  void onKeypadTap(String value) {
    if (pin.value.length < 4) {
      pin.value += value;
    }
  }

  void onDeleteTap() {
    if (pin.value.isNotEmpty) {
      pin.value = pin.value.substring(0, pin.value.length - 1);
    }
  }

  bool get isPinComplete => pin.value.length == 4;

  Future<void> submitPin() async {
    if (isPinComplete) {
      try {
        // Await the write operation so it finishes before navigating
        await _storage.write(key: 'user_pin', value: pin.value);

        Get.offNamed('/home');
      } catch (e) {
        print("Error saving pin: $e");
      }
    }
  }
}
