import 'package:flutter/material.dart';
import 'package:roz_hazri/core/utils/colors.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 3, // 🔥 Adds physical elevation
      shadowColor: Colors.black.withOpacity(0.15),
      borderRadius: BorderRadius.circular(25),
      color: theme.colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),

        // 🔥 Focus + Pressed color logic
        // We use WidgetStateProperty (Modern Flutter) or MaterialStateProperty
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.lightGrey.withOpacity(0.25);
          }
          if (states.contains(WidgetState.focused)) {
            return AppColors.lightGrey.withOpacity(0.20);
          }
          return null;
        }),

        splashColor: AppColors.primaryGreen.withOpacity(0.15),
        highlightColor: AppColors.lightGrey.withOpacity(0.15),

        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: const Color(0xFF4CAF50)),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
