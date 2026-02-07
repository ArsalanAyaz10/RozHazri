// lib/app/views/pin/unlock_pin_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:roz_hazri/features/Pin/controllers/UnlockPin_controller.dart';
import 'package:roz_hazri/core/widgets/BackgroundCircle.dart';
import 'package:roz_hazri/core/utils/colors.dart';
import 'package:roz_hazri/core/utils/fonts.dart';

class UnlockPinScreen extends GetView<UnlockPinController> {
  const UnlockPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            const BackgroundCircle(top: -0.3, left: -0.2),
            const BackgroundCircle(bottom: -0.3, right: -0.2),

            SafeArea(
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                          onPressed: () => Get.back(),
                        ),
                        Expanded(
                          child: Center(
                            child: RichText(
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
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Welcome Back Text
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontFamily: AppFonts.outfit,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColorDark,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Instruction with Timer Display
                  Obx(() {
                    if (controller.isLocked.value) {
                      return Column(
                        children: [
                          Text(
                            'Account Locked',
                            style: TextStyle(
                              fontFamily: AppFonts.outfit,
                              color: AppColors.error,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try again in:',
                            style: TextStyle(
                              fontFamily: AppFonts.outfit,
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              controller.lockTimerText,
                              style: TextStyle(
                                fontFamily: AppFonts.outfit,
                                color: AppColors.error,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text(
                        controller.errorMessage.value.isNotEmpty
                            ? controller.errorMessage.value
                            : "Enter your PIN to unlock",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.outfit,
                          color: controller.errorMessage.value.isNotEmpty
                              ? AppColors.error
                              : AppColors.grey,
                          fontSize: 16,
                        ),
                      );
                    }
                  }),

                  const SizedBox(height: 25),

                  // PIN Visual Indicators with shake animation
                  Obx(() {
                    final shouldShake =
                        controller.errorMessage.value.isNotEmpty &&
                        controller.enteredPin.value.isEmpty;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      transform: shouldShake
                          ? Matrix4.translationValues(_getShakeOffset(), 0, 0)
                          : Matrix4.identity(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          bool isActive =
                              index < controller.enteredPin.value.length;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            width: 18,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? AppColors.primaryGreen
                                  : Colors.transparent,
                              border: Border.all(
                                color: isActive
                                    ? AppColors.primaryGreen
                                    : controller.isLocked.value
                                    ? AppColors.grey.withOpacity(0.1)
                                    : AppColors.grey.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),

                  // Attempts counter
                  Obx(
                    () =>
                        controller.attempts.value > 0 &&
                            !controller.isLocked.value
                        ? Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              'Attempt ${controller.attempts.value}/5',
                              style: TextStyle(
                                fontFamily: AppFonts.outfit,
                                color: AppColors.error,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : const SizedBox(height: 5),
                  ),

                  const Spacer(),

                  // Custom Numeric Keypad with disabled state
                  _buildKeypad(),

                  const SizedBox(height: 10),

                  // Forgot PIN Button (disabled when locked)
                  Obx(
                    () => TextButton(
                      onPressed: controller.isLocked.value
                          ? null
                          : controller.onForgotPin,
                      child: Text(
                        "Use Fingerprint",
                        style: TextStyle(
                          fontFamily: AppFonts.outfit,
                          color: controller.isLocked.value
                              ? AppColors.grey
                              : AppColors.primaryGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for shake animation
  double _getShakeOffset() {
    final time = DateTime.now().millisecondsSinceEpoch;
    return (time % 200 < 100 ? -1 : 1) * 4.0;
  }

  Widget _buildKeypad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          // Grid for numbers 1-9
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20, // Vertical spacing
              crossAxisSpacing: 20, // Horizontal spacing
              childAspectRatio: 1.2, // Width/Height ratio
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              return _keypadButton("${index + 1}");
            },
          ),

          const SizedBox(height: 20),

          // Bottom row for 0 and delete
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _keypadButton("0"),
                const SizedBox(width: 2),
                _keypadButton("delete", isIcon: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _keypadButton(String value, {bool isIcon = false}) {
    return Obx(() {
      final isLocked = controller.isLocked.value;
      return AnimatedButton(
        isLocked: isLocked,
        onTap: value == "delete"
            ? controller.onDeleteTap
            : () => controller.onKeypadTap(value),
        child: Container(
          width: 80,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isLocked ? Colors.grey.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isLocked
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
            border: isLocked
                ? Border.all(color: Colors.grey.withOpacity(0.3))
                : null,
          ),
          child: isIcon
              ? Icon(
                  Icons.backspace_outlined,
                  size: 24,
                  color: isLocked
                      ? AppColors.grey.withOpacity(0.5)
                      : AppColors.textColorDark,
                )
              : Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isLocked
                        ? AppColors.grey.withOpacity(0.5)
                        : AppColors.textColorDark,
                  ),
                ),
        ),
      );
    });
  }
}

// Custom animated button widget
class AnimatedButton extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;
  final bool isLocked;

  const AnimatedButton({
    super.key,
    this.onTap,
    required this.child,
    required this.isLocked,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown() {
    if (!widget.isLocked) {
      _controller.forward();
    }
  }

  void _onTapUp() {
    if (!widget.isLocked) {
      _controller.reverse();
      if (widget.onTap != null) {
        widget.onTap!();
      }
    }
  }

  void _onTapCancel() {
    if (!widget.isLocked) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
