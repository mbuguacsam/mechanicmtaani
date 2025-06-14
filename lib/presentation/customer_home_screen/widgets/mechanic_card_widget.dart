import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MechanicCardWidget extends StatelessWidget {
  final Map<String, dynamic> mechanic;
  final VoidCallback onTap;

  const MechanicCardWidget({
    super.key,
    required this.mechanic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = mechanic["isAvailable"] as bool? ?? false;
    final double rating = (mechanic["rating"] as num?)?.toDouble() ?? 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomImageWidget(
                    imageUrl: mechanic["photo"] as String? ?? "",
                    width: double.infinity,
                    height: 12.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 2.w,
                  right: 2.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? AppTheme.successColor
                          : AppTheme.warningColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isAvailable ? 'Available' : 'Busy',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              mechanic["name"] as String? ?? "Unknown",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 0.5.h),
            Text(
              mechanic["specialization"] as String? ?? "",
              style: AppTheme.lightTheme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'star',
                  color: AppTheme.accentColor,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  rating.toStringAsFixed(1),
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.textSecondaryLight,
                  size: 14,
                ),
                SizedBox(width: 1.w),
                Text(
                  mechanic["distance"] as String? ?? "",
                  style: AppTheme.lightTheme.textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
