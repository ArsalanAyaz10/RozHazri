import 'package:get/get.dart' hide Worker;
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:roz_hazri/core/database/app_database.dart';
import 'package:roz_hazri/data/repositories/attendance_repository.dart';
import 'package:roz_hazri/data/repositories/payrollPeriodWorkers_repository.dart';
import 'package:roz_hazri/data/repositories/payrollPeriod_repository.dart';
import 'package:roz_hazri/core/utils/colors.dart';

class AttendanceController extends GetxController {
  final AttendanceRepository _attendanceRepo = Get.find<AttendanceRepository>();
  final PayrollPeriodWorkersRepository _periodWorkerRepo = Get.find<PayrollPeriodWorkersRepository>();
  final PayrollperiodRepository _periodRepo = Get.find<PayrollperiodRepository>();

  var selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ).obs;
  var workers = <Worker>[].obs;
  var isLoading = true.obs;
  var attendanceMap = <int, String>{}.obs;
  var calendarDates = <DateTime>[].obs;
  var activePeriod = Rxn<PayrollperiodTableData>(); 

  @override
  void onInit() {
    super.onInit();
    _generateCalendarDates();
    loadData();
  }

  void _generateCalendarDates() {
    final centerDate = selectedDate.value;
    calendarDates.value = List.generate(
      7,
      (index) => centerDate.subtract(Duration(days: 3 - index)),
    );
  }

  Future<void> loadData() async {
    try {
      isLoading(true);
      attendanceMap.clear();

      activePeriod.value = await _periodRepo.getPeriodByDate(selectedDate.value);

      if (activePeriod.value == null) {
        workers.clear(); 
        return;
      }

      workers.value = await _periodWorkerRepo.getWorkersForPeriod(activePeriod.value!.id);

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
      _generateCalendarDates();
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
      await loadData();
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
