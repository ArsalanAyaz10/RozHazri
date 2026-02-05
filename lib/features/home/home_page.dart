import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roz_hazri/app/routes/app_pages.dart';
import 'package:roz_hazri/core/constants/widgets/ActionCard.dart';
import 'package:roz_hazri/core/constants/widgets/StatCard.dart';
import 'package:roz_hazri/core/utils/colors.dart';
import 'package:roz_hazri/core/utils/fonts.dart';
import '../../app/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 253, 254, 253),
        elevation: 1, // Subtle shadow like the screenshot
        centerTitle: false, // Force left alignment
        titleSpacing: 15, // Padding from the left edge
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: Transform.scale(
                scale:
                    1.4, // Adjust this value until the green fills the circle
                child: Image.asset(
                  'assets/images/splash_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'RozHazri',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    height: 1.1, // Adjust line height for tighter spacing
                  ),
                ),
                Text(
                  'DASHBOARD',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5, // Spread letters like the image
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              radius: 18,
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
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
      backgroundColor: const Color.fromARGB(255, 246, 248, 246),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 15.0, left: 15, top: 15),
                child: Text(
                  "Hello, Admin!",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: AppFonts.outfit,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 25, left: 15),
                child: Text(
                  "Manage your workforce today",
                  style: TextStyle(
                    fontSize: 10,
                    backgroundColor: AppColors.lightGrey,
                    fontFamily: AppFonts.outfit,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Obx(
                  () => Row(
                    children: [
                      StatCard(
                        title: "Active Now",
                        value: "${controller.activeWorkers.value}",
                        subValue: "Workers",
                        valueColor: Colors.green.shade700,
                      ),
                      const SizedBox(width: 15),
                      StatCard(
                        title: "Today's Cost",
                        value: "\$${controller.todaysCost.value}",
                        valueColor: Theme.of(context).colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
              ),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                childAspectRatio: 1.1,
                children: [
                  ActionCard(
                    title: "Workers",
                    icon: Icons.group,
                    onTap: () => Get.toNamed(Routes.workers),
                  ),
                  ActionCard(
                    title: "Attendance",
                    icon: Icons.calendar_month,
                    onTap: () => Get.toNamed(Routes.wages),
                  ),
                  ActionCard(
                    title: "Wage Cycles",
                    icon: Icons.history,
                    onTap: () => Get.toNamed(Routes.wages),
                  ),
                  ActionCard(
                    title: "Payroll",
                    icon: Icons.money_outlined,
                    onTap: () => Get.toNamed(Routes.wages),
                  ),
                  ActionCard(
                    title: "Export/Import",
                    icon: Icons.compare_arrows_rounded,
                    onTap: () => Get.toNamed(Routes.wages),
                  ),
                  ActionCard(
                    title: "Settings",
                    icon: Icons.settings,
                    onTap: () => Get.toNamed(Routes.wages),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Generate Monthly Report",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "View detailed analytics of all site workers.",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Download PDF",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
