import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get/get.dart' hide Worker;
import 'package:roz_hazri/core/database/app_database.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';

class EditworkerController extends GetxController {
  final WorkerRepository _repository = Get.find<WorkerRepository>();

  final List<String> wageTypes = ['Daily', 'Hourly', 'Fixed'];

  var currentIndex = 0.obs;
  var isLoading = true.obs;
  late int workerId;
  late Worker originalWorker;
  var selectedWageType = 'Daily'.obs;

  // Form Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final rateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    workerId = Get.arguments as int;
    _loadWorkerData();
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
              Get.back(); // close dialog
              Get.back(result: true); // go back to list
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
