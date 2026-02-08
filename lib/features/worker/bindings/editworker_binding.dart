import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:roz_hazri/data/repositories/attendance_repository.dart';
import 'package:roz_hazri/features/worker/controllers/editworker_controller.dart';

class EditworkerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AttendanceRepository(Get.find()));
    Get.lazyPut<EditworkerController>(() => EditworkerController());
  }
}
