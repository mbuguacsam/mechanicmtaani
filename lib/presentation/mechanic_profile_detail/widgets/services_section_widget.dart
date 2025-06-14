import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServicesSectionWidget extends StatefulWidget {
  final List services;

  const ServicesSectionWidget({
    super.key,
    required this.services,
  });

  @override
  State<ServicesSectionWidget> createState() => _ServicesSectionWidgetState();
}

class _ServicesSectionWidgetState extends State<ServicesSectionWidget> {
  List<bool> expandedStates = [];

  @override
  void initState() {
    super.initState();
    expandedStates = List.generate(widget.services.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'build',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Services Offered',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Services List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.services.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final service = widget.services[index] as Map<String, dynamic>;
              final isExpanded = expandedStates[index];

              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Service Header
                    InkWell(
                      onTap: () {
                        setState(() {
                          expandedStates[index] = !expandedStates[index];
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Row(
                          children: [
                            // Service Icon
                            Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                color: AppTheme
                                    .lightTheme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: _getServiceIcon(
                                      service["category"] as String),
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                            ),

                            SizedBox(width: 3.w),

                            // Service Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service["category"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    service["priceRange"] as String,
                                    style: AppTheme.getDataTextStyle(
                                      isLight: true,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ).copyWith(
                                      color: AppTheme.successColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Expand Icon
                            CustomIconWidget(
                              iconName:
                                  isExpanded ? 'expand_less' : 'expand_more',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Expanded Content
                    if (isExpanded) ...[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                              height: 1,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Service Description',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              service["description"] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/service-request-creation');
                                },
                                child: Text('Request This Service'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getServiceIcon(String category) {
    switch (category.toLowerCase()) {
      case 'engine repair':
        return 'settings';
      case 'brake service':
        return 'disc_full';
      case 'electrical systems':
        return 'electrical_services';
      case 'tire services':
        return 'tire_repair';
      default:
        return 'build';
    }
  }
}
