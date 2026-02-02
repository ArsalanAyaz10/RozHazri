import 'package:get/get.dart';
import 'package:roz_hazri/app/controllers/home_controller.dart';
import 'package:roz_hazri/app/controllers/splash_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Register controllers here
    Get.put<SplashController>(SplashController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
