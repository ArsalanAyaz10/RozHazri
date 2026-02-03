import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class HomeController extends GetxController {
  var pin = ''.obs;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    getPin(); 
  }

  void getPin() async {
    final value = await _storage.read(key: 'user_pin');
    pin.value = value ?? '';
    
    if (kDebugMode) {
      print("Pin retrieved in Home: ${pin.value}");
    }
  }
}