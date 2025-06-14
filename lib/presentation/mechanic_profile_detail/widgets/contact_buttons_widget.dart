import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContactButtonsWidget extends StatelessWidget {
  final String phone;
  final String mechanicName;

  const ContactButtonsWidget({
    super.key,
    required this.phone,
    required this.mechanicName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Message Button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _openMessage(context),
              icon: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 18,
              ),
              label: Text('Message'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // Call Button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _makeCall(context),
              icon: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.successColor,
                size: 18,
              ),
              label: Text('Call'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.successColor,
                side: BorderSide(color: AppTheme.successColor, width: 1.5),
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          SizedBox(width: 3.w),

          // Request Quote Button
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () => _requestQuote(context),
              icon: CustomIconWidget(
                iconName: 'request_quote',
                color: Colors.white,
                size: 18,
              ),
              label: Text('Request Quote'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openMessage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MessageBottomSheet(mechanicName: mechanicName),
    );
  }

  void _makeCall(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'phone',
              color: AppTheme.successColor,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Call Mechanic'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Do you want to call $mechanicName?'),
            SizedBox(height: 1.h),
            Text(
              phone,
              style: AppTheme.getDataTextStyle(
                isLight: true,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, this would initiate a phone call
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling $mechanicName...'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'phone',
              color: Colors.white,
              size: 16,
            ),
            label: Text('Call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successColor,
            ),
          ),
        ],
      ),
    );
  }

  void _requestQuote(BuildContext context) {
    Navigator.pushNamed(context, '/service-request-creation');
  }
}

class _MessageBottomSheet extends StatefulWidget {
  final String mechanicName;

  const _MessageBottomSheet({required this.mechanicName});

  @override
  State<_MessageBottomSheet> createState() => _MessageBottomSheetState();
}

class _MessageBottomSheetState extends State<_MessageBottomSheet> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _quickMessages = [
    'Hi, I need help with my car',
    'What are your rates for brake service?',
    'Are you available today?',
    'Can you come to my location?',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'message',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Message ${widget.mechanicName}',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Quick Messages
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Messages',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: _quickMessages.map((message) {
                    return InkWell(
                      onTap: () {
                        _messageController.text = message;
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme
                              .lightTheme.colorScheme.primaryContainer
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          message,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Message Input
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppTheme.lightTheme.colorScheme.surface,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  FloatingActionButton(
                    onPressed: () {
                      if (_messageController.text.trim().isNotEmpty) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Message sent to ${widget.mechanicName}'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    mini: true,
                    child: CustomIconWidget(
                      iconName: 'send',
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
