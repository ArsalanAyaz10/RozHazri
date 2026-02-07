import 'package:get/get.dart';
import 'package:roz_hazri/core/database/app_database.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';
import 'package:roz_hazri/features/splash/controllers/splash_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Register controllers here
    Get.put<SplashController>(SplashController());

    final db = AppDatabase();
    Get.put(db, permanent: true);

    Get.lazyPut(() => WorkerRepository(Get.find<AppDatabase>()));
  }
}
