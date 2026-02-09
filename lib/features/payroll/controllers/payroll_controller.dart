import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roz_hazri/core/database/app_database.dart' as db;
import 'package:roz_hazri/core/services/export_engine.dart';
import 'package:roz_hazri/core/services/payroll_engine.dart';
import 'package:roz_hazri/data/repositories/payrollPeriod_repository.dart';
import 'package:roz_hazri/data/repositories/payrollPeriodWorkers_repository.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';

class PayrollController extends GetxController {
  final PayrollEngine _engine = Get.find<PayrollEngine>();
  final PayrollExportEngine _exportEngine = Get.find<PayrollExportEngine>();
  final PayrollperiodRepository _periodRepo = Get.find<PayrollperiodRepository>();
  final PayrollPeriodWorkersRepository _periodWorkerRepo = Get.find<PayrollPeriodWorkersRepository>();
  final WorkerRepository _workerRepo = Get.find<WorkerRepository>();

  var currentPeriod = Rxn<db.PayrollperiodTableData>();
  var payrollResults = <PayrollResult>[].obs;
  var closedPeriods = <db.PayrollperiodTableData>[].obs;
  var allWorkers = <db.Worker>[].obs;
  var selectedWorkerIds = <int>{}.obs; // UI state for selection
  var isLoading = false.obs;

  // Shipment Progress
  var shipmentProgress = "".obs;
  var shipmentDayCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    refreshDashboard();
    fetchWorkers();
    loadHistory();
  }

  Future<void> fetchWorkers() async {
    allWorkers.value = await _workerRepo.getAllWorkers();
  }

  void toggleWorkerSelection(int workerId) {
    if (selectedWorkerIds.contains(workerId)) {
      selectedWorkerIds.remove(workerId);
    } else {
      selectedWorkerIds.add(workerId);
    }
    selectedWorkerIds.refresh();
  }

  Future<void> refreshDashboard() async {
    isLoading(true);
    // 1. Get existing period
    currentPeriod.value = await _periodRepo.getCurrentPeriod();

    // 2. If period exists, calculate real-time totals and progress
    if (currentPeriod.value != null) {
      payrollResults.value = await _engine.calculateCurrentPeriod();

      // Calculate progress (Day X of 15)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final startDate = currentPeriod.value!.startDate;
      
      final difference = today.difference(startDate).inDays + 1;
      shipmentDayCount.value = difference > 15 ? 15 : (difference < 1 ? 1 : difference);
      shipmentProgress.value = "Day ${shipmentDayCount.value} of 15";
    } else {
      shipmentProgress.value = "No Active Shipment";
      shipmentDayCount.value = 0;
    }
    isLoading(false);
  }

  Future<void> loadHistory() async {
    closedPeriods.value = await _periodRepo.getPeriodHistory();
  }

  Future<void> startNewPeriod(int cycleId) async {
    if (selectedWorkerIds.isEmpty) {
      Get.snackbar("Error", "Please select at least one worker.");
      return;
    }

    isLoading(true);
    // 1. Generate Period
    final newPeriod = await _engine.generateNextPeriod(cycleId: cycleId);

    // 2. Map workers to this period
    await _periodWorkerRepo.addWorkersToPeriod(
      newPeriod.id,
      selectedWorkerIds.toList(),
    );

    // 3. Reset selection and refresh
    selectedWorkerIds.clear();
    await refreshDashboard();
    isLoading(false);
  }

  Future<void> finalizePayroll() async {
    if (currentPeriod.value == null) return;

    isLoading(true);
    // 1. Validate Attendance
    final errors = await _engine.validateAttendance();
    if (errors.isNotEmpty) {
      isLoading(false);
      Get.dialog(
        AlertDialog(
          title: const Text("Missing Attendance"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: errors.map((e) => Text("• $e")).toList(),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("Fix Now")),
          ],
        ),
      );
      return;
    }

    // 2. Export the Excel first for safety
    await exportToExcel();
    
    // 3. Close the period (this now saves snapshots)
    await _engine.closeCurrentPeriod();
    
    // 4. Update UI
    currentPeriod.value = null;
    payrollResults.clear();
    await loadHistory();
    isLoading(false);
    Get.snackbar("Success", "Payroll Closed and Saved to Excel");
  }

  Future<void> exportToExcel() async {
    if (currentPeriod.value == null) return;
    final file = await _exportEngine.exportPayrollExcel(currentPeriod.value!.id);
    // Use a plugin like 'open_file' or 'share_plus' here
    Get.snackbar("Exported", "File saved at ${file.path}");
  }
}