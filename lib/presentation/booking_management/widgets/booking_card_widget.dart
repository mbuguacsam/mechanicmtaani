import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/app_export.dart';

class BookingCardWidget extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;
  final VoidCallback? onMessage;
  final VoidCallback? onCall;

  const BookingCardWidget({
    super.key,
    required this.booking,
    required this.onTap,
    this.onCancel,
    this.onReschedule,
    this.onMessage,
    this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final status = booking['status'] as String;
    final statusColor = AppTheme.getStatusColor(status);

    return Dismissible(
      key: Key(booking['id']),
      background: _buildSwipeBackground(context, isLeft: true),
      secondaryBackground: _buildSwipeBackground(context, isLeft: false),
      confirmDismiss: (direction) async {
        HapticFeedback.mediumImpact();

        if (direction == DismissDirection.startToEnd) {
          // Left swipe - Message
          if (onMessage != null) onMessage!();
        } else {
          // Right swipe - Cancel/Reschedule
          if (status == 'confirmed') {
            _showActionSheet(context);
          }
        }
        return false; // Don't actually dismiss
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          elevation: 2,
          shadowColor: AppTheme.shadowLight,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Service icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: booking['serviceIcon'],
                            color: statusColor,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Service info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    booking['serviceType'],
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getStatusText(status),
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking['vehicleInfo'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Mechanic info
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CustomImageWidget(
                          imageUrl: booking['mechanicPhoto'],
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking['mechanicName'],
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'star',
                                  color: AppTheme.accentColor,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${booking['mechanicRating']}',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        booking['price'],
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Date and time info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${booking['scheduledDate']} at ${booking['scheduledTime']}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        if (status == 'in_progress' &&
                            booking['estimatedCompletion'] != null) ...[
                          CustomIconWidget(
                            iconName: 'timer',
                            color: AppTheme.warningColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'ETA: ${booking['estimatedCompletion']}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.warningColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Location info
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          booking['location'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Quick actions for in-progress bookings
                  if (status == 'in_progress') ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onMessage,
                            icon: CustomIconWidget(
                              iconName: 'message',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 16,
                            ),
                            label: const Text('Message'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onCall,
                            icon: CustomIconWidget(
                              iconName: 'phone',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 16,
                            ),
                            label: const Text('Call'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Rate service button for completed bookings
                  if (status == 'completed' && booking['canRate'] == true) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle rate service
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Rate service for ${booking['id']}')),
                          );
                        },
                        icon: CustomIconWidget(
                          iconName: 'star',
                          color: Colors.white,
                          size: 16,
                        ),
                        label: const Text('Rate Service'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.errorLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'message' : 'cancel',
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                isLeft ? 'Message' : 'Cancel',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Booking Actions',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ListTile(
                      leading: CustomIconWidget(
                        iconName: 'schedule',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      title: const Text('Reschedule'),
                      onTap: () {
                        Navigator.pop(context);
                        if (onReschedule != null) onReschedule!();
                      },
                    ),
                    ListTile(
                      leading: CustomIconWidget(
                        iconName: 'message',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      title: const Text('Message Mechanic'),
                      onTap: () {
                        Navigator.pop(context);
                        if (onMessage != null) onMessage!();
                      },
                    ),
                    ListTile(
                      leading: CustomIconWidget(
                        iconName: 'phone',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                      title: const Text('Call Mechanic'),
                      onTap: () {
                        Navigator.pop(context);
                        if (onCall != null) onCall!();
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: CustomIconWidget(
                        iconName: 'cancel',
                        color: AppTheme.errorLight,
                        size: 24,
                      ),
                      title: Text(
                        'Cancel Booking',
                        style: TextStyle(color: AppTheme.errorLight),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        if (onCancel != null) onCancel!();
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Confirmed';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'en_route':
        return 'En Route';
      default:
        return status.toUpperCase();
    }
  }
}
