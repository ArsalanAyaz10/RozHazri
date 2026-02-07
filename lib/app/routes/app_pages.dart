import 'package:get/get.dart';
import 'package:roz_hazri/features/Pin/bindings/UnlockPin_bindings.dart';
import 'package:roz_hazri/features/fingerprint/bindings/fingerprint_binding.dart';
import 'package:roz_hazri/features/Pin/bindings/pin_binding.dart';
import 'package:roz_hazri/features/home/bindings/home_binding.dart';
import 'package:roz_hazri/features/splash/bindings/splash_binding.dart';
import 'package:roz_hazri/features/worker/bindings/addworker_binding.dart';
import 'package:roz_hazri/features/Pin/views/UnlockPin_screen.dart';
import 'package:roz_hazri/features/fingerprint/views/fingerprint_screen.dart';
import 'package:roz_hazri/features/Pin/views/setPin_screen.dart';
import 'package:roz_hazri/features/home/home_page.dart';
import 'package:roz_hazri/features/splash/views/splash_screen.dart';
import 'package:roz_hazri/features/worker/bindings/editworker_binding.dart';
import 'package:roz_hazri/features/worker/bindings/workerlist_binding.dart';
import 'package:roz_hazri/features/worker/views/AddWorker_screen.dart';
import 'package:roz_hazri/features/worker/views/WorkersList_screen.dart';
import 'package:roz_hazri/features/worker/views/editWorker_screen.dart';

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
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
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
    GetPage(
      name: Routes.workers,
      page: () => WorkerslistScreen(),
      binding: WorkerListBinding(),
    ),
    GetPage(
      name: Routes.addworkers,
      page: () => AddworkerScreen(),
      binding: AddWorkerBinding(),
    ),
    GetPage(
      name: Routes.editworkers,
      page: () => EditworkerScreen(),
      binding: EditworkerBinding(),
    ),
    //   GetPage(name: Routes.attendance,page: ()=> AttendanceScreen()),
    //   GetPage(name: Routes.reports,page: ()=> ReportsScreen()),
    //   GetPage(name: Routes.account,page:()=> AccountScreen()),
    //   GetPage(name: Routes.wagecycles,page:()=> WageCyclesScreen()),
    //   GetPage(name: Routes.payroll,page:()=> PayrollScreen()),
    //   GetPage(name: Routes.export,page:()=> ExportScreen()),
    //   GetPage(name: Routes.settings,page:()=> SettingsScreen()),
    //
  ];
}
