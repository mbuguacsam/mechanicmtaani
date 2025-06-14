import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onUpdateAvailability;
  final VoidCallback onViewRoute;
  final VoidCallback onEmergencyToggle;

  const QuickActionsWidget({
    super.key,
    required this.onUpdateAvailability,
    required this.onViewRoute,
    required this.onEmergencyToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Update\nAvailability',
                icon: 'schedule',
                color: AppTheme.lightTheme.primaryColor,
                onTap: onUpdateAvailability,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildActionCard(
                title: 'View Route\nto Next Job',
                icon: 'directions',
                color: AppTheme.accentColor,
                onTap: onViewRoute,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildActionCard(
                title: 'Emergency\nServices',
                icon: 'emergency',
                color: AppTheme.errorLight,
                onTap: onEmergencyToggle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
