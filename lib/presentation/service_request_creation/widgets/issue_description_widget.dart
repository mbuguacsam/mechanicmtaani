import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IssueDescriptionWidget extends StatefulWidget {
  final String description;
  final Function(String) onDescriptionChanged;

  const IssueDescriptionWidget({
    super.key,
    required this.description,
    required this.onDescriptionChanged,
  });

  @override
  State<IssueDescriptionWidget> createState() => _IssueDescriptionWidgetState();
}

class _IssueDescriptionWidgetState extends State<IssueDescriptionWidget> {
  late TextEditingController _controller;
  final int _maxLength = 500;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Describe the Issue',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Please provide detailed information about the problem you\'re experiencing',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Description text area
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _controller,
              maxLines: 8,
              maxLength: _maxLength,
              onChanged: widget.onDescriptionChanged,
              decoration: InputDecoration(
                hintText:
                    'Example: My car makes a strange noise when I brake, especially when turning left. The noise started yesterday and seems to be getting worse...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(4.w),
                counterText: '',
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),

          SizedBox(height: 1.h),

          // Character counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Be as specific as possible for better service',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${_controller.text.length}/$_maxLength',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: _controller.text.length > _maxLength * 0.9
                      ? AppTheme.warningColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Quick suggestions
          Text(
            'Quick Suggestions:',
            style: AppTheme.lightTheme.textTheme.titleSmall,
          ),
          SizedBox(height: 2.h),

          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: [
              'Strange noise',
              'Warning light',
              'Performance issue',
              'Vibration',
              'Overheating',
              'Won\'t start',
            ].map((suggestion) {
              return GestureDetector(
                onTap: () {
                  final currentText = _controller.text;
                  final newText = currentText.isEmpty
                      ? suggestion
                      : '$currentText, $suggestion';
                  _controller.text = newText;
                  widget.onDescriptionChanged(newText);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'add',
                        color: AppTheme
                            .lightTheme.colorScheme.onSecondaryContainer,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        suggestion,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme
                              .lightTheme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
