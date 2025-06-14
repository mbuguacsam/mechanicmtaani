import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';

class BookingFilterTabsWidget extends StatelessWidget {
  final TabController controller;
  final Function(int) onTap;

  const BookingFilterTabsWidget({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: Column(
        children: [
          TabBar(
            controller: controller,
            onTap: onTap,
            labelColor: AppTheme.lightTheme.colorScheme.primary,
            unselectedLabelColor:
                AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            indicatorColor: AppTheme.lightTheme.colorScheme.primary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle:
                AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w400,
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: controller.index == 0
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Text('Upcoming'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'build',
                      color: controller.index == 1
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Text('In Progress'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: controller.index == 2
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    const Text('Completed'),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}
