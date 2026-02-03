import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(title: const Text('RozHazri')),
      body: Center(
        child: Obx(
          () => Text(
            'Pin: ${controller.pin.value.isEmpty ? "Not Set" : controller.pin.value}',
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
