import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart' hide Worker;
import 'package:roz_hazri/core/database/app_database.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';
import 'package:roz_hazri/data/repositories/attendance_repository.dart';

class EditworkerController extends GetxController {
  final WorkerRepository _repository = Get.find<WorkerRepository>();
  final AttendanceRepository _attendanceRepo = Get.find<AttendanceRepository>();

  var attendanceRecords = <AttendanceData>[].obs;
  var presentCount = 0.obs;
  var absentCount = 0.obs;
  var halfDayCount = 0.obs;

  final List<String> wageTypes = ['Daily', 'Hourly', 'Fixed'];

  var currentIndex = 0.obs;
  var isLoading = true.obs;
  late int workerId;
  late Worker originalWorker;
  var selectedWageType = 'Daily'.obs;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final rateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    workerId = Get.arguments as int;
    _loadWorkerData();
    _loadAttendanceHistory();
  }

  void _loadAttendanceHistory() {
    final now = DateTime.now();

    attendanceRecords.bindStream(
      _attendanceRepo.watchAttendance(workerId).map((allHistory) {
        final currentMonthRecords = allHistory.where((rec) {
          // Robust comparison handling potential non-normalized legacy data
          return rec.date.month == now.month && rec.date.year == now.year;
        }).toList();

        // Update counters inside stream
        presentCount.value = currentMonthRecords
            .where((e) => e.status == 'P')
            .length;

        absentCount.value = currentMonthRecords
            .where((e) => e.status == 'A')
            .length;

        halfDayCount.value = currentMonthRecords
            .where((e) => e.status == 'H')
            .length;

        attendanceRecords.refresh(); // Force GetX to update viewers
        return currentMonthRecords;
      }),
    );
  }

  String? getStatusForDate(DateTime date) {
    
    final record = attendanceRecords.firstWhereOrNull((e) {
      return e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day;
    });

    return record?.status;
  }

  Future<void> _loadWorkerData() async {
    try {
      isLoading(true);
      final workers = await _repository.getAllWorkers();
      originalWorker = workers.firstWhere((w) => w.id == workerId);

      nameController.text = originalWorker.name;
      phoneController.text = originalWorker.phone ?? "";
      rateController.text = originalWorker.rate.toStringAsFixed(0);
      selectedWageType.value = originalWorker.paymentType.capitalizeFirst!;
    } catch (e) {
      Get.snackbar("Error", "Could not load worker data");
    } finally {
      isLoading(false);
    }
  }

  void setWageType(String type) => selectedWageType.value = type;

  Future<void> updateWorker() async {
    try {
      final updatedWorker = originalWorker.copyWith(
        name: nameController.text.trim(),
        phone: drift.Value<String?>(phoneController.text.trim()),
        paymentType: selectedWageType.value.toUpperCase(),
        rate: double.tryParse(rateController.text) ?? 0.0,
      );

      await _repository.updateWorker(updatedWorker);
      Get.back(result: true);
      Get.snackbar("Success", "Worker details updated");
    } catch (e) {
      Get.snackbar("Error", "Update failed: $e");
    }
  }

  Future<void> deleteWorker() async {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Worker"),
        content: const Text("Are you sure you want to remove this worker?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await _repository.deleteWorker(workerId);
              Get.back();
              Get.back(result: true);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void changeTabIndex(int index) => currentIndex.value = index;

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    rateController.dispose();
    super.onClose();
  }
}
