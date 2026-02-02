import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lazily put controller if not already exists
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(title: const Text('RozHazri')),
      body: Center(
        child: Obx(() => Text(
              'Clicks: ${controller.count}',
              style: const TextStyle(fontSize: 24),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
