import 'package:get/get.dart';
import 'package:roz_hazri/core/services/export_engine.dart';
import 'package:roz_hazri/core/services/payroll_engine.dart';
import 'package:roz_hazri/data/repositories/payrollSummary_repository.dart';
import 'package:roz_hazri/data/repositories/payrollPeriodWorkers_repository.dart';
import 'package:roz_hazri/features/payroll/controllers/payroll_controller.dart';

class PayrollBinding extends Bindings {
  @override
  void dependencies() {
    // Inject Repositories
    Get.lazyPut(() => PayrollSummaryRepository(Get.find()));
    Get.lazyPut(() => PayrollPeriodWorkersRepository(Get.find()));

    // Inject Engines first
    Get.lazyPut(
      () => PayrollEngine(
        db: Get.find(),
        workerRepo: Get.find(),
        periodRepo: Get.find(),
        cycleRepo: Get.find(),
        summaryRepo: Get.find(),
        periodWorkerRepo: Get.find(),
      ),
    );
    Get.lazyPut(
      () => PayrollExportEngine(
        db: Get.find(),
        workerRepo: Get.find(),
        periodRepo: Get.find(),
        summaryRepo: Get.find(),
      ),
    );
    // Inject Controller
    Get.lazyPut(() => PayrollController());
  }
}
