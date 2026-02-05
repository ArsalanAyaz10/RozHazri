import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:roz_hazri/app/controllers/fingerprint_controller.dart';
import 'package:roz_hazri/core/constants/widgets/BackgroundCircle.dart';
import 'package:roz_hazri/core/utils/colors.dart';
import 'package:roz_hazri/core/utils/fonts.dart';

class FingerprintScreen extends GetView<FingerprintController> {
  const FingerprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Circles
            const BackgroundCircle(top: -0.3, left: -0.2),
            const BackgroundCircle(bottom: -0.3, right: -0.2),

            // Main Content
            Column(
              children: [
                // App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                        onPressed: () => Get.back(),
                        color: AppColors.textColorDark,
                      ),
                      const Spacer(),
                      RichText(
                        text: TextSpan(
                          text: 'Roz',
                          style: TextStyle(
                            fontFamily: AppFonts.outfit,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColorDark,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Hazri',
                              style: TextStyle(
                                fontFamily: AppFonts.outfit,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48), // Balance the layout
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          'Scan your finger to unlock',
                          style: TextStyle(
                            fontFamily: AppFonts.outfit,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColorDark,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        // Subtitle
                        Text(
                          'Confirm your identity to continue',
                          style: TextStyle(
                            fontFamily: AppFonts.outfit,
                            fontSize: 16,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 60),

                        // Animated Fingerprint
                        _buildAnimatedFingerprint(),

                        const SizedBox(height: 60),

                        // Status Message
                        Obx(
                          () => Text(
                            controller.statusMessage.value,
                            style: TextStyle(
                              fontFamily: AppFonts.outfit,
                              fontSize: 14,
                              color: controller.isScanning.value
                                  ? AppColors.primaryGreen
                                  : controller.hasError.value
                                  ? AppColors.error
                                  : AppColors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Progress Indicator
                        Obx(
                          () => controller.isScanning.value
                              ? SizedBox(
                                  width: 100,
                                  child: LinearProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryGreen,
                                    ),
                                    backgroundColor: AppColors.grey.withOpacity(
                                      0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )
                              : const SizedBox(height: 4),
                        ),

                        const Spacer(),

                        // Back to PIN Button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TextButton(
                            onPressed: controller.onBackToPin,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                            ),
                            child: Text(
                              'Back to PIN',
                              style: TextStyle(
                                fontFamily: AppFonts.outfit,
                                fontSize: 16,
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        // Help Text
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32.0),
                          child: TextButton(
                            onPressed: controller.onNeedHelp,
                            child: Text(
                              'Need help logging in?',
                              style: TextStyle(
                                fontFamily: AppFonts.outfit,
                                fontSize: 14,
                                color: AppColors.grey,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedFingerprint() {
    return Obx(() {
      return GestureDetector(
        onTap: controller.onFingerprintTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer Ring with Animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: controller.isScanning.value ? 180 : 160,
              height: controller.isScanning.value ? 180 : 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryGreen.withOpacity(
                  controller.isScanning.value ? 0.1 : 0.05,
                ),
                border: Border.all(
                  color: AppColors.primaryGreen.withOpacity(
                    controller.isScanning.value ? 0.3 : 0.1,
                  ),
                  width: controller.isScanning.value ? 3 : 2,
                ),
              ),
            ),

            // Middle Ring with Animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              width: controller.isScanning.value ? 140 : 120,
              height: controller.isScanning.value ? 140 : 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryGreen.withOpacity(
                  controller.isScanning.value ? 0.15 : 0.08,
                ),
                border: Border.all(
                  color: AppColors.primaryGreen.withOpacity(
                    controller.isScanning.value ? 0.4 : 0.2,
                  ),
                  width: controller.isScanning.value ? 2.5 : 1.5,
                ),
              ),
            ),

            // Inner Circle with Fingerprint Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: controller.isScanning.value ? 100 : 80,
              height: controller.isScanning.value ? 100 : 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: controller.isScanning.value
                    ? AppColors.primaryGreen
                    : AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: controller.isScanning.value
                        ? AppColors.primaryGreen.withOpacity(0.5)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: controller.isScanning.value ? 20 : 10,
                    spreadRadius: controller.isScanning.value ? 5 : 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: controller.isScanning.value
                      ? const SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.white,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.fingerprint,
                          size: 40,
                          color: controller.isScanning.value
                              ? AppColors.white
                              : AppColors.primaryGreen,
                        ),
                ),
              ),
            ),

            // Pulsing Animation
            if (controller.isScanning.value) _buildPulseAnimation(),
          ],
        ),
      );
    });
  }

  Widget _buildPulseAnimation() {
    return AnimatedBuilder(
      animation: controller.pulseAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (controller.pulseAnimationController.value * 0.3),
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGreen.withOpacity(
                0.1 - (controller.pulseAnimationController.value * 0.1),
              ),
            ),
          ),
        );
      },
    );
  }
}
