import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:roz_hazri/features/splash/controllers/splash_controller.dart';
import 'package:roz_hazri/app/routes/app_pages.dart';
import 'package:roz_hazri/core/widgets/BackgroundCircle.dart';
import 'package:roz_hazri/core/utils/colors.dart';
import 'package:roz_hazri/core/utils/fonts.dart';
import 'package:roz_hazri/features/Pin/views/setPin_screen.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          BackgroundCircle(top: -0.3, left: -0.2),
          BackgroundCircle(bottom: -0.3, right: -0.2),

          PageView(
            controller: pageController,
            onPageChanged: (index) {
              if (index == 1) {
                controller.navigateToPinSetup();
              }
            },
            children: [
              // PAGE 1: The Splash Content
              SafeArea(
                child: Column(
                  children: [
                    const Spacer(),
                    Center(
                      child: Image.asset(
                        'assets/images/splash_logo.png',
                        height: 80,
                        width: 80,
                      ),
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'RozHazri',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 40,
                            color: AppColors.primaryGreen,
                            fontFamily: AppFonts.outfit,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        'Simple worker and payroll management',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.grey,
                          fontFamily: AppFonts.outfit,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Column(
                        children: [
                          // Progress Bar
                          Container(
                            width: 120,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.5, // Represents Page 1 of 2
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'VERSION 1.0.10',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontFamily: AppFonts.outfit,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // PAGE 2
              SafeArea(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.navigateToPinSetup();
                    },
                    child: const Text('Continue'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
