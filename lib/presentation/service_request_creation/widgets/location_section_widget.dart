import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationSectionWidget extends StatelessWidget {
  final String currentLocation;
  final Function(String) onLocationChanged;

  const LocationSectionWidget({
    super.key,
    required this.currentLocation,
    required this.onLocationChanged,
  });

  void _changeLocation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Container(
                    width: 12.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Select Service Location',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  SizedBox(height: 3.h),

                  // Search field
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for address...',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'search',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        // Current location
                        ListTile(
                          leading: CustomIconWidget(
                            iconName: 'my_location',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                          title: Text('Use Current Location'),
                          subtitle: Text('123 Main Street, Downtown'),
                          onTap: () {
                            onLocationChanged('Current Location');
                            Navigator.pop(context);
                          },
                        ),

                        Divider(),

                        // Saved addresses
                        ListTile(
                          leading: CustomIconWidget(
                            iconName: 'home',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                          title: Text('Home'),
                          subtitle: Text('456 Oak Avenue, Suburb'),
                          onTap: () {
                            onLocationChanged('Home - 456 Oak Avenue, Suburb');
                            Navigator.pop(context);
                          },
                        ),

                        ListTile(
                          leading: CustomIconWidget(
                            iconName: 'work',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                          title: Text('Work'),
                          subtitle: Text('789 Business Park, City Center'),
                          onTap: () {
                            onLocationChanged(
                                'Work - 789 Business Park, City Center');
                            Navigator.pop(context);
                          },
                        ),

                        Divider(),

                        // Recent locations
                        Text(
                          'Recent Locations',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),

                        SizedBox(height: 1.h),

                        ListTile(
                          leading: CustomIconWidget(
                            iconName: 'history',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                          title: Text('Shopping Mall Parking'),
                          subtitle: Text('321 Mall Drive, Shopping District'),
                          onTap: () {
                            onLocationChanged('Shopping Mall Parking');
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Location',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Where would you like the mechanic to meet you?',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Current location display
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Location',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            currentLocation,
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),

                // Map preview placeholder
                Container(
                  width: double.infinity,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'map',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Map Preview',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Change location button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _changeLocation(context),
              icon: CustomIconWidget(
                iconName: 'edit_location',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              label: Text('Change Location'),
            ),
          ),

          SizedBox(height: 3.h),

          // Location info
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color:
                          AppTheme.lightTheme.colorScheme.onSecondaryContainer,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Location Information',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme
                            .lightTheme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Make sure the location is accessible for the mechanic\n• Provide additional details if needed (parking instructions, building number, etc.)\n• The mechanic will contact you before arriving',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
