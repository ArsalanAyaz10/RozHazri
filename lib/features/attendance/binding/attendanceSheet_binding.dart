import 'package:get/get.dart';
import 'package:roz_hazri/data/repositories/attendance_repository.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';
import 'package:roz_hazri/features/attendance/controllers/attendanceSheet_controller.dart';

class ViewAttendanceBinding extends Bindings {
  @override
  void dependencies() { 
        Get.lazyPut(() => AttendanceRepository(Get.find()));
    Get.lazyPut(() => WorkerRepository(Get.find()));
    Get.lazyPut<AttendanceSheetController>(() => AttendanceSheetController());
  }
}