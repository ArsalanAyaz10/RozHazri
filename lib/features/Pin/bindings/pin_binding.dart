import 'package:get/get.dart';
import 'package:roz_hazri/features/Pin/controllers/pin_contrloller.dart';

class PinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinController>(() => PinController());
  
  }
}