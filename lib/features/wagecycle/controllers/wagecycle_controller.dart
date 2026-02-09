import 'package:drift/drift.dart' as drift;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:roz_hazri/core/database/app_database.dart';
import 'package:roz_hazri/core/database/tables/wagecycle_table.dart';
import 'package:roz_hazri/data/repositories/payrollPeriod_repository.dart';
import 'package:roz_hazri/data/repositories/payrollPeriodWorkers_repository.dart';
import 'package:roz_hazri/data/repositories/wageCycle_repository.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';

class WageCycleController extends GetxController {
  final PayrollcycleRepository _cycleRepo = Get.find<PayrollcycleRepository>();
  final PayrollperiodRepository _periodRepo = Get.find<PayrollperiodRepository>();
  final WorkerRepository _workerRepo = Get.find<WorkerRepository>();
  final PayrollPeriodWorkersRepository _periodWorkerRepo = Get.find<PayrollPeriodWorkersRepository>();

  var currentCycle = Rxn<WagecycleTableData>();
  var isLoading = false.obs;
  var selectedCycle = CycleType.monthly.obs;
  var cycleLength = 15.obs; // Default to 15 for shipments
  var payDay = 1.obs;
  var startDate = DateTime.now().obs;
  var autoAdjust = true.obs;

  // Worker selection
  var allWorkers = <Worker>[].obs;
  var selectedWorkerIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadExistingConfig();
    _loadWorkers();
  }

  Future<void> _loadWorkers() async {
    allWorkers.value = await _workerRepo.getAllWorkers();
  }

  void toggleWorkerSelection(int workerId) {
    if (selectedWorkerIds.contains(workerId)) {
      selectedWorkerIds.remove(workerId);
    } else {
      selectedWorkerIds.add(workerId);
    }
  }

  void toggleSelectAll() {
    if (selectedWorkerIds.length == allWorkers.length) {
      selectedWorkerIds.clear();
    } else {
      selectedWorkerIds.assignAll(allWorkers.map((w) => w.id));
    }
  }

  Future<void> _loadExistingConfig() async {
    isLoading(true);
    currentCycle.value = await _cycleRepo.getCycleConfig();
    if (currentCycle.value != null) {
      selectedCycle.value = currentCycle.value!.cycleType;
      cycleLength.value = currentCycle.value!.cycleLengthDays;
      payDay.value = currentCycle.value!.payDay;
      startDate.value = currentCycle.value!.startFromDate;
      autoAdjust.value = currentCycle.value!.autoAdjustMonthEnd;
    }
    isLoading(false);
  }

  Future<void> saveSettings() async {
    if (selectedWorkerIds.isEmpty) {
      Get.snackbar("Error", "Please select at least one worker");
      return;
    }

    isLoading(true);
    try {
      final companion = WagecycleTableCompanion.insert(
        cycleType: selectedCycle.value,
        cycleLengthDays: 15, // Force 15 days for shipment
        payDay: 1, // Placeholder as we're focusing on 15-day periods
        startFromDate: startDate.value,
        autoAdjustMonthEnd: const drift.Value(true),
      );

      // 1. Save Cycle Configuration
      final cycleId = await _cycleRepo.saveCycleConfig(companion);

      // 2. Automatically generate the first active shipment
      final period = await _periodRepo.generateNextPeriod(cycleId: cycleId);

      // 3. Assign SELECTED workers to this shipment
      await _periodWorkerRepo.addWorkersToPeriod(
        period.id,
        selectedWorkerIds.toList(),
      );

      Get.back();
      Get.snackbar("Success", "Shipment configuration saved with ${selectedWorkerIds.length} workers");
    } catch (e) {
      Get.snackbar("Error", "Setup failed: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }
}
