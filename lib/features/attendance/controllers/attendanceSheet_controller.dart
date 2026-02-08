import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart' hide Worker;
import 'package:roz_hazri/core/database/app_database.dart';
import 'package:roz_hazri/data/repositories/attendance_repository.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';

class AttendanceSheetController extends GetxController {
  final AttendanceRepository _attendanceRepo = Get.find<AttendanceRepository>();
  final WorkerRepository _workerRepo = Get.find<WorkerRepository>();

  // Reactive variables
  var selectedDate = DateTime.now().obs;
  var workers = <Worker>[].obs;
  var attendanceList = <AttendanceData>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();

    ever(selectedDate, (_) => _bindAttendanceStream());
  }

  Future<void> _loadInitialData() async {
    try {
      isLoading(true);
      workers.value = await _workerRepo.getAllWorkers();
      _bindAttendanceStream();
    } finally {
      isLoading(false);
    }
  }

  void _bindAttendanceStream() {
    // Standardize date to ignore time
    final date = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
    );

    // Bind the stream from repository for the selected date
    attendanceList.bindStream(_attendanceRepo.watchAttendanceByDate(date));
  }

  void updateSelectedDate(DateTime date) => selectedDate.value = date;

  // Helper to get status for a specific worker from the current list
  String getWorkerStatus(int workerId) {
    final record = attendanceList.firstWhereOrNull(
      (a) => a.workerId == workerId,
    );
    if (record == null) return "Unmarked";
    switch (record.status) {
      case 'P':
        return "Present";
      case 'A':
        return "Absent";
      case 'H':
        return "Half-day";
      default:
        return "Unmarked";
    }
  }

  // Statistics for the header
  int get presentCount => attendanceList.where((e) => e.status == 'P').length;
  int get absentCount => attendanceList.where((e) => e.status == 'A').length;
  int get halfDayCount => attendanceList.where((e) => e.status == 'H').length;
}
