import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';
import 'package:roz_hazri/features/worker/controllers/workerlist_controller.dart';

class WorkerListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkerRepository>(() => WorkerRepository(Get.find()));
    Get.lazyPut<WorkerlistController>(() => WorkerlistController());
  }
}
