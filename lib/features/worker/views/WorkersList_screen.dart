import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roz_hazri/features/worker/controllers/workerlist_controller.dart';
import 'package:roz_hazri/core/widgets/WorkerCard.dart';
import 'package:roz_hazri/core/utils/colors.dart';
import 'package:roz_hazri/core/utils/fonts.dart';
import 'package:roz_hazri/core/database/app_database.dart';

class WorkerslistScreen extends GetView<WorkerlistController> {
  const WorkerslistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Worker List',
          style: TextStyle(
            fontFamily: AppFonts.outfit,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          iconSize: 22,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => controller.fetchWorkers(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 246, 248, 246),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTabIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: Colors.green.shade700,
          unselectedItemColor: Colors.grey.shade500,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              label: 'HISTORY',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              label: 'REPORTS',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ACCOUNT'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 4,
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: AppColors.white),
        onPressed: () => controller.gotoAddWorker(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: SearchBar(
                onChanged: (value) => controller.searchWorker(value),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
                elevation: const WidgetStatePropertyAll(0.5),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                leading: const Icon(Icons.search, color: AppColors.grey),
                hintText: 'Search workers by name...',
                hintStyle: const WidgetStatePropertyAll(
                  TextStyle(
                    fontFamily: AppFonts.outfit,
                    fontSize: 13,
                    color: AppColors.grey,
                  ),
                ),
                backgroundColor: const WidgetStatePropertyAll(
                  AppColors.background,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.allWorkers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "No workers found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10,
                  ),
                  itemCount: controller.allWorkers.length,
                  itemBuilder: (context, index) {
                    final worker = controller.allWorkers[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: WorkerCard(
                        name: worker.name,
                        type: worker.paymentType,
                        status:
                            "Added on ${worker.createdAt.day}/${worker.createdAt.month}/${worker.createdAt.year}",
                        rate: worker.rate.toStringAsFixed(0),
                        onTap: () => controller.gotoEditWorker(worker.id),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
