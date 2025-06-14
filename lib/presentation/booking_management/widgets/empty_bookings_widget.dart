import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';

class EmptyBookingsWidget extends StatelessWidget {
  final String filterType;
  final VoidCallback onBookService;

  const EmptyBookingsWidget({
    super.key,
    required this.filterType,
    required this.onBookService,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getEmptyStateIcon(),
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 60,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Title
            Text(
              _getEmptyStateTitle(),
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              _getEmptyStateDescription(),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Action button
            if (filterType == 'upcoming') ...[
              ElevatedButton.icon(
                onPressed: onBookService,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text('Book Your First Service'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ] else if (filterType == 'in_progress') ...[
              OutlinedButton.icon(
                onPressed: onBookService,
                icon: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: const Text('Find Mechanics'),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ] else ...[
              OutlinedButton.icon(
                onPressed: onBookService,
                icon: CustomIconWidget(
                  iconName: 'history',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                label: const Text('Book Another Service'),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Secondary action
            if (filterType == 'upcoming') ...[
              TextButton.icon(
                onPressed: () {
                  // Navigate to mechanic discovery
                  Navigator.pushNamed(context, '/customer-home-screen');
                },
                icon: CustomIconWidget(
                  iconName: 'explore',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 18,
                ),
                label: const Text('Explore Mechanics'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getEmptyStateIcon() {
    switch (filterType) {
      case 'upcoming':
        return 'event_available';
      case 'in_progress':
        return 'build_circle';
      case 'completed':
        return 'history';
      default:
        return 'book_online';
    }
  }

  String _getEmptyStateTitle() {
    switch (filterType) {
      case 'upcoming':
        return 'No Upcoming Bookings';
      case 'in_progress':
        return 'No Active Services';
      case 'completed':
        return 'No Service History';
      default:
        return 'No Bookings Found';
    }
  }

  String _getEmptyStateDescription() {
    switch (filterType) {
      case 'upcoming':
        return 'You don\'t have any scheduled services.\nBook your first service to get started!';
      case 'in_progress':
        return 'No services are currently in progress.\nYour active bookings will appear here.';
      case 'completed':
        return 'You haven\'t completed any services yet.\nYour service history will appear here.';
      default:
        return 'No bookings match your search criteria.\nTry adjusting your filters.';
    }
  }
}
