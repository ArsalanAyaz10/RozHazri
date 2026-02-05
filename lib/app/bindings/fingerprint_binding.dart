import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:roz_hazri/app/controllers/fingerprint_controller.dart';

class FingerprintBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FingerprintController>(() => FingerprintController());
  }
}