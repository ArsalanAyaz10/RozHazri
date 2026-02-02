import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:roz_hazri/app/controllers/splash_controller.dart';
import 'package:roz_hazri/core/constants/colors.dart';
import 'package:roz_hazri/core/constants/fonts.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Roz',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 45,
                    color: AppColors.black,
                    fontFamily: AppFonts.outfit,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Hazri',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.outfit,
                        fontSize: 45,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4),
            Center(
              child: Text(
                'Wage Management App',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.outfit,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                'Version 0.0.1',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppFonts.outfit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
