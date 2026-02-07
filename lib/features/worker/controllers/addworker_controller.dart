import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drift/drift.dart' as drift;
import 'package:roz_hazri/core/database/app_database.dart';
import 'package:roz_hazri/data/repositories/worker_repository.dart';

class AddworkerController extends GetxController {
  final WorkerRepository _repository = Get.find<WorkerRepository>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final rateController = TextEditingController();

  var selectedWageType = 'Daily'.obs;
  final List<String> wageTypes = ['Daily', 'Hourly', 'Fixed'];

  var isSaving = false.obs;

  void setWageType(String type) => selectedWageType.value = type;

  Future<void> saveWorker() async {
    if (nameController.text.isEmpty || rateController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill name and rate",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
      );
      return;
    }

    try {
      isSaving(true);

      final companion = WorkersCompanion(
        name: drift.Value(nameController.text.trim()),
        phone: drift.Value(phoneController.text.trim()),
        paymentType: drift.Value(selectedWageType.value.toUpperCase()),
        rate: drift.Value(double.tryParse(rateController.text) ?? 0.0),
      );

      await _repository.addWorker(companion);

      Get.back();
      Get.snackbar(
        "Success",
        "Worker added successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to save: $e");
      print("Error saving worker: $e");
    } finally {
      isSaving(false);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    rateController.dispose();
    super.onClose();
  }
}
