import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class EmergencyFabWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const EmergencyFabWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        // Haptic feedback for emergency button
        HapticFeedback.heavyImpact();
        onPressed();
      },
      backgroundColor: AppTheme.errorLight,
      foregroundColor: Colors.white,
      elevation: 8,
      icon: CustomIconWidget(
        iconName: 'emergency',
        color: Colors.white,
        size: 24,
      ),
      label: Text(
        'Emergency',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
