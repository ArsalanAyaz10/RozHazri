import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roz_hazri/app/controllers/pin_contrloller.dart';
import 'package:roz_hazri/core/constants/widgets/BackgroundCircle.dart';
import 'package:roz_hazri/core/utils/colors.dart';
import 'package:roz_hazri/core/utils/fonts.dart';

class PinScreen extends GetView<PinController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const BackgroundCircle(top: -0.3, left: -0.2),
          const BackgroundCircle(bottom: -0.3, right: -0.2),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                Text(
                  "Set Your Secure PIN",
                  style: TextStyle(
                    fontFamily: AppFonts.outfit,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Enter a 4-digit PIN to secure your data.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.outfit,
                      color: AppColors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 5. PIN Visual Indicators (The dots)
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      bool isActive = index < controller.pin.value.length;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? AppColors.primaryGreen
                              : Colors.transparent,
                          border: Border.all(
                            color: isActive
                                ? AppColors.primaryGreen
                                : AppColors.grey.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const Spacer(),

                // 6. Custom Numeric Keypad
                _buildKeypad(),

                const SizedBox(height: 30),

                // 7. Next Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (controller.isPinComplete) {
                          controller.submitPin();
                        } else {
                          Get.snackbar(
                            "Incomplete PIN",
                            "Please enter a 4-digit PIN to proceed.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        for (var row in [
          ["1", "2", "3"],
          ["4", "5", "6"],
          ["7", "8", "9"],
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((val) => _keypadButton(val)).toList(),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 80, height: 80), // Empty space
            _keypadButton("0"),
            _keypadButton("delete", isIcon: true),
          ],
        ),
      ],
    );
  }

  Widget _keypadButton(String value, {bool isIcon = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: value == "delete"
            ? controller.onDeleteTap
            : () => controller.onKeypadTap(value),
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 80,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isIcon
              ? const Icon(Icons.backspace_outlined, size: 24)
              : Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
