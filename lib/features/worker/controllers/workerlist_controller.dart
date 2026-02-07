import 'package:get/get.dart' hide Worker;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:roz_hazri/app/routes/app_pages.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';
import 'package:roz_hazri/core/database/app_database.dart';

class WorkerlistController extends GetxController {
  final WorkerRepository _repository = Get.find<WorkerRepository>();
  var allWorkers = <Worker>[].obs;
  var currentIndex = 0.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchWorkers();
    super.onInit();
  }



  void fetchWorkers() async {
    isLoading(true);
    final results = await _repository.getAllWorkers();
    allWorkers.assignAll(results as Iterable<Worker>);
    isLoading(false);
  }

  void searchWorker(String name) async {
    if (name.isEmpty) {
      fetchWorkers();
      return;
    }
    final results = await _repository.searchWorkers(name);
    allWorkers.assignAll(results as Iterable<Worker>);
  }

  void gotoAddWorker() async {
    var result = await Get.toNamed(Routes.addworkers);
    fetchWorkers();
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }

  void gotoEditWorker(int id) {
    print("ID: $id");
    Get.toNamed(Routes.editworkers, arguments: id);
  }
}
