import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TimingPickerWidget extends StatefulWidget {
  final List<Map<String, dynamic>> timingOptions;
  final String selectedTiming;
  final Function(String) onTimingSelected;

  const TimingPickerWidget({
    super.key,
    required this.timingOptions,
    required this.selectedTiming,
    required this.onTimingSelected,
  });

  @override
  State<TimingPickerWidget> createState() => _TimingPickerWidgetState();
}

class _TimingPickerWidgetState extends State<TimingPickerWidget> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedDate = date;
          _selectedTime = time;
        });
        widget.onTimingSelected('schedule');
      }
    }
  }

  String _getScheduledDateTime() {
    if (_selectedDate != null && _selectedTime != null) {
      return '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} at ${_selectedTime!.format(context)}';
    }
    return 'Select date and time';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferred Timing',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'When would you like the service to be performed?',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Timing options
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.timingOptions.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final option = widget.timingOptions[index];
              final isSelected = widget.selectedTiming == option['value'];

              return GestureDetector(
                onTap: () {
                  if (option['value'] == 'schedule') {
                    _selectDateTime();
                  } else {
                    widget.onTimingSelected(option['value']);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1)
                              : AppTheme.lightTheme.colorScheme
                                  .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: _getIconForTiming(option['value']),
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option['label'],
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              option['value'] == 'schedule' && isSelected
                                  ? _getScheduledDateTime()
                                  : option['description'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 3.h),

          // Time slots for ASAP and Today
          if (widget.selectedTiming == 'asap' ||
              widget.selectedTiming == 'today') ...[
            Text(
              'Available Time Slots',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            SizedBox(height: 2.h),
            Wrap(
              spacing: 3.w,
              runSpacing: 2.h,
              children: _getAvailableTimeSlots().map((slot) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    slot,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color:
                          AppTheme.lightTheme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 3.h),
          ],

          // Timing info
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
                      iconName: 'schedule',
                      color:
                          AppTheme.lightTheme.colorScheme.onSecondaryContainer,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Timing Information',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme
                            .lightTheme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  '• ASAP services are subject to mechanic availability\n• Scheduled services have higher priority\n• You\'ll receive confirmation once a mechanic accepts\n• Emergency services available 24/7 with additional charges',
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

  String _getIconForTiming(String timing) {
    switch (timing) {
      case 'asap':
        return 'flash_on';
      case 'today':
        return 'today';
      case 'tomorrow':
        return 'event';
      case 'schedule':
        return 'schedule';
      default:
        return 'schedule';
    }
  }

  List<String> _getAvailableTimeSlots() {
    if (widget.selectedTiming == 'asap') {
      return ['Next 2 hours', 'Within 4 hours', 'By end of day'];
    } else if (widget.selectedTiming == 'today') {
      return ['Morning (8-12)', 'Afternoon (12-17)', 'Evening (17-20)'];
    }
    return [];
  }
}
