// lib/app/controllers/home_controller.dart
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Reactive variables
  final RxInt activeWorkers = 12.obs;
  final RxString greeting = ''.obs;
  final RxString userName = 'Admin'.obs;
  final RxInt todaysCost = 1000.obs;
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _setGreeting();
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }

  void updateStats(int workers, int cost) {
    activeWorkers.value = workers;
    todaysCost.value = cost;
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'Good Morning';
    } else if (hour < 17) {
      greeting.value = 'Good Afternoon';
    } else {
      greeting.value = 'Good Evening';
    }
  }

  void navigateToSection(String section) {
    // Handle navigation to different sections
    Get.snackbar('Navigation', 'Opening $section section');
  }
}
