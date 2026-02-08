import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:roz_hazri/data/repositories/attendance_repository.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';
import 'package:roz_hazri/features/attendance/controllers/attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceController>(() => AttendanceController());
    Get.lazyPut(() => AttendanceRepository(Get.find()));
    Get.lazyPut(() => WorkerRepository(Get.find()));
  }
}
