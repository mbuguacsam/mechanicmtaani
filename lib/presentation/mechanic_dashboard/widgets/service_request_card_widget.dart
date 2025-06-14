import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServiceRequestCardWidget extends StatelessWidget {
  final Map<String, dynamic> request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const ServiceRequestCardWidget({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 2.h),
          _buildVehicleInfo(),
          SizedBox(height: 2.h),
          _buildServiceDetails(),
          SizedBox(height: 2.h),
          _buildLocationInfo(),
          SizedBox(height: 3.h),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.w),
            child: CustomImageWidget(
              imageUrl: request["customerImage"] ?? "",
              width: 12.w,
              height: 12.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request["customerName"] ?? "",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                request["requestTime"] ?? "",
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        _buildUrgencyBadge(),
      ],
    );
  }

  Widget _buildUrgencyBadge() {
    Color badgeColor;
    switch (request["urgency"]?.toLowerCase()) {
      case 'high':
        badgeColor = AppTheme.errorLight;
        break;
      case 'medium':
        badgeColor = AppTheme.warningColor;
        break;
      default:
        badgeColor = AppTheme.successColor;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        request["urgency"] ?? "",
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildVehicleInfo() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'directions_car',
            color: AppTheme.lightTheme.primaryColor,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Text(
            request["vehicleInfo"] ?? "",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'build',
              color: AppTheme.accentColor,
              size: 18,
            ),
            SizedBox(width: 2.w),
            Text(
              request["serviceType"] ?? "",
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.accentColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          request["description"] ?? "",
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryLight,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.textSecondaryLight,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  request["location"] ?? "",
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          request["distance"] ?? "",
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onDecline,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.errorLight,
              side: BorderSide(color: AppTheme.errorLight),
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
            child: Text('Decline'),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successColor,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Accept ',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  request["estimatedPayment"] ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
