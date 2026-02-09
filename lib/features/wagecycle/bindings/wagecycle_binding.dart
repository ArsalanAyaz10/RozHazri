import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:roz_hazri/core/database/app_database.dart';
import 'package:roz_hazri/core/services/export_engine.dart';
import 'package:roz_hazri/core/services/payroll_engine.dart';
import 'package:roz_hazri/data/repositories/payrollPeriod_repository.dart';
import 'package:roz_hazri/data/repositories/payrollPeriodWorkers_repository.dart';
import 'package:roz_hazri/data/repositories/payrollSummary_repository.dart';
import 'package:roz_hazri/data/repositories/wageCycle_repository.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';
import 'package:roz_hazri/features/payroll/controllers/payroll_controller.dart';
import 'package:roz_hazri/features/wagecycle/controllers/wagecycle_controller.dart';

class WageCycleBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Repositories
    Get.lazyPut(() => PayrollperiodRepository(Get.find<AppDatabase>()));
    Get.lazyPut(() => PayrollcycleRepository(Get.find<AppDatabase>()));
    Get.lazyPut(() => WorkerRepository(Get.find<AppDatabase>()));
    Get.lazyPut(() => PayrollSummaryRepository(Get.find<AppDatabase>()));
    Get.lazyPut(() => PayrollPeriodWorkersRepository(Get.find<AppDatabase>()));

    // 2. Engines
    Get.lazyPut(
      () => PayrollEngine(
        db: Get.find<AppDatabase>(),
        workerRepo: Get.find<WorkerRepository>(),
        periodRepo: Get.find<PayrollperiodRepository>(),
        cycleRepo: Get.find<PayrollcycleRepository>(),
        summaryRepo: Get.find<PayrollSummaryRepository>(),
        periodWorkerRepo: Get.find<PayrollPeriodWorkersRepository>(),
      ),
    );

    Get.lazyPut(
      () => PayrollExportEngine(
        db: Get.find<AppDatabase>(),
        workerRepo: Get.find<WorkerRepository>(),
        periodRepo: Get.find<PayrollperiodRepository>(),
        summaryRepo: Get.find<PayrollSummaryRepository>(),
      ),
    );

    // 3. Controllers
    Get.lazyPut(() => WageCycleController());
    Get.lazyPut(() => PayrollController());
  }
}
