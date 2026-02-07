// lib/app/controllers/UnlockPin_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vibration/vibration.dart';

class UnlockPinController extends GetxController {
  final RxString enteredPin = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxInt attempts = 0.obs;
  final RxBool isLocked = false.obs;
  final RxInt lockTimerSeconds = 0.obs;
  final int maxAttempts = 5;

  Timer? _lockTimer;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    _clearErrorOnInput();
  }

  @override
  void onClose() {
    _lockTimer?.cancel();
    super.onClose();
  }

  void _clearErrorOnInput() {
    ever(enteredPin, (_) {
      if (errorMessage.value.isNotEmpty && !isLocked.value) {
        errorMessage.value = '';
      }
    });
  }

  void onKeypadTap(String value) {
    // Prevent input if locked
    if (isLocked.value) {
      return;
    }

    if (enteredPin.value.length < 4) {
      enteredPin.value += value;

      // Auto-check when 4 digits entered
      if (enteredPin.value.length == 4) {
        _verifyPin();
      }
    }
  }

  void onDeleteTap() {
    // Prevent input if locked
    if (isLocked.value) {
      return;
    }

    if (enteredPin.value.isNotEmpty) {
      enteredPin.value = enteredPin.value.substring(
        0,
        enteredPin.value.length - 1,
      );
    }
  }

  Future<void> _verifyPin() async {
    try {
      final storedPin = await _storage.read(key: 'user_pin');

      if (storedPin == null) {
        // No PIN stored, redirect to set PIN screen
        Get.offNamed('/set-pin');
        return;
      }

      if (enteredPin.value == storedPin) {
        // Success - reset attempts and navigate
        _resetAttempts();
        Get.offAllNamed('/home');
      } else {
        // Wrong PIN
        Vibration.vibrate(duration: 200);
        attempts.value++;
        enteredPin.value = '';

        if (attempts.value >= maxAttempts) {
          _startLockTimer();
        } else {
          errorMessage.value =
              'Incorrect PIN. ${maxAttempts - attempts.value} attempts remaining.';
        }
      }
    } catch (e) {
      errorMessage.value = 'Error verifying PIN. Please try again.';
      enteredPin.value = '';
    }
  }

  void _startLockTimer() {
    isLocked.value = true;
    lockTimerSeconds.value = 30;
    errorMessage.value = 'Too many failed attempts. Please wait 30 seconds.';

    _lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (lockTimerSeconds.value > 0) {
        lockTimerSeconds.value--;
      } else {
        timer.cancel();
        _resetLock();
      }
    });
  }

  void _resetLock() {
    _lockTimer?.cancel();
    isLocked.value = false;
    attempts.value = 0;
    errorMessage.value = '';
  }

  void _resetAttempts() {
    attempts.value = 0;
    isLocked.value = false;
    _lockTimer?.cancel();
    lockTimerSeconds.value = 0;
  }

  void onForgotPin() {
    Get.back();
    Get.offNamed('/fingerprint');
  }

  // Helper getter for UI
  String get lockTimerText {
    final minutes = lockTimerSeconds.value ~/ 60;
    final seconds = lockTimerSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
