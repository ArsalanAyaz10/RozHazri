import 'package:get/get.dart' hide Worker;
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
    await Get.toNamed(Routes.addworkers);
    fetchWorkers();
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }

  void gotoEditWorker(int id) {
    Get.toNamed(Routes.editworkers, arguments: id);
  }
}
