import 'package:get/get.dart' hide Worker;
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:roz_hazri/core/database/app_database.dart';
import 'package:roz_hazri/data/repositories/attendance_repository.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';
import 'package:roz_hazri/core/utils/colors.dart';

class AttendanceController extends GetxController {
  final AttendanceRepository _attendanceRepo = Get.find<AttendanceRepository>();
  final WorkerRepository _workerRepo = Get.find<WorkerRepository>();

  var selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ).obs;
  var workers = <Worker>[].obs;
  var isLoading = true.obs;
  var attendanceMap = <int, String>{}.obs;
  var calendarDates = <DateTime>[].obs;

  @override
  void onInit() {
    super.onInit();
    _generateCalendarDates();
    loadData();
  }

  void _generateCalendarDates() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    calendarDates.value = List.generate(
      7,
      (index) => today.subtract(Duration(days: 3 - index)),
    );
  }

  Future<void> loadData() async {
    try {
      isLoading(true);
      attendanceMap.clear();
      workers.value = await _workerRepo.getAllWorkers();

      final existingRecords = await _attendanceRepo.getAttendanceByDate(
        selectedDate.value,
      );

      for (var record in existingRecords) {
        attendanceMap[record.workerId] = record.status;
      }
    } finally {
      isLoading(false);
    }
  }

  void updateStatus(int workerId, String status) {
    attendanceMap[workerId] = status;
  }

  void onDateChange(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    if (selectedDate.value != normalizedDate) {
      selectedDate.value = normalizedDate;
      loadData();
    }
  }

  Future<void> saveAttendance() async {
    try {
      for (var entry in attendanceMap.entries) {
        await _attendanceRepo.addAttendance(
          AttendanceCompanion.insert(
            workerId: entry.key,
            date: selectedDate.value,
            status: entry.value,
            updatedAt: drift.Value(DateTime.now()),
          ),
        );
      }
      Get.snackbar(
        "Success",
        "Attendance saved for ${DateFormat('dd MMM').format(selectedDate.value)}",
        backgroundColor: AppColors.primaryGreen,
        colorText: AppColors.white,
      );
      await loadData(); // Ensure we reload after saving
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to save attendance: $e",
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    }
  }
}
