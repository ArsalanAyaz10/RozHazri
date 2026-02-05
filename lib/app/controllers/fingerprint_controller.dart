import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:roz_hazri/app/routes/app_pages.dart';

class FingerprintController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Reactive UI variables
  final RxBool isScanning = false.obs;
  final RxBool hasError = false.obs;
  final RxString statusMessage = 'Touch the fingerprint sensor'.obs;

  late AnimationController pulseAnimationController;
  final LocalAuthentication auth = LocalAuthentication();

  VoidCallback? get onNeedHelp => null;

  @override
  void onInit() {
    super.onInit();
    pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    onFingerprintTap();
  }

  /// The main authentication logic
  Future<void> onFingerprintTap() async {
    try {
      // 1. Check if hardware is capable
      final bool isDeviceSupported = await auth.isDeviceSupported();
      final bool canCheckBiometrics = await auth.canCheckBiometrics;

      if (!isDeviceSupported || !canCheckBiometrics) {
        _showErrorDialog(
          "Not Supported",
          "Your device does not support biometric authentication.",
        );
        return;
      }

      // 2. Check if the user has actually enrolled any fingerprints/faces
      final List<BiometricType> availableBiometrics = await auth
          .getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        _showErrorDialog(
          "No Biometrics Found",
          "Please register a fingerprint in your phone settings first.",
        );
        return;
      }

      // 3. Start the scan
      isScanning.value = true;
      hasError.value = false;
      statusMessage.value = 'Scanning...';

      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please scan your fingerprint to reset your PIN',

        biometricOnly: true,
      );

      if (didAuthenticate) {
        statusMessage.value = 'Verified Successfully!';
        // SUCCESS: Move to Home and clear navigation stack
        Get.offAllNamed(Routes.home);
      } else {
        statusMessage.value = 'Authentication failed. Try again.';
        isScanning.value = false;
      }
    } catch (e) {
      isScanning.value = false;
      hasError.value = true;
      statusMessage.value = 'Error: $e';
    }
  }

  void _showErrorDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.offNamed(Routes.matchpin),
            child: const Text("Use PIN Instead"),
          ),
        ],
      ),
    );
  }

  void onBackToPin() => Get.offNamed(Routes.matchpin);

  @override
  void onClose() {
    pulseAnimationController.dispose();
    super.onClose();
  }
}
