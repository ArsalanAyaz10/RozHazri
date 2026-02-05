import 'package:get/get.dart';
import 'package:roz_hazri/app/bindings/UnlockPin_bindings.dart';
import 'package:roz_hazri/app/bindings/fingerprint_binding.dart';
import 'package:roz_hazri/app/bindings/pin_binding.dart';
import 'package:roz_hazri/app/bindings/splash_binding.dart';
import 'package:roz_hazri/features/auth/UnlockPin_screen.dart';
import 'package:roz_hazri/features/auth/fingerprint_screen.dart';
import 'package:roz_hazri/features/auth/setPin_screen.dart';
import 'package:roz_hazri/features/home/home_page.dart';
import 'package:roz_hazri/features/splash/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  // ignore: constant_identifier_names
  static const INITIAL = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(name: Routes.home, page: () => const HomePage()),
    GetPage(name: Routes.pin, page: () => PinScreen(), binding: PinBinding()),
    GetPage(
      name: Routes.matchpin,
      page: () => const UnlockPinScreen(),
      binding: UnlockPinBinding(),
    ),
    GetPage(
      name: Routes.fingerprint,
      page: () => FingerprintScreen(),
      binding: FingerprintBinding(),
    ),
  ];
}
