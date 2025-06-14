import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BudgetRangeWidget extends StatelessWidget {
  final double budgetRange;
  final Function(double) onBudgetChanged;

  const BudgetRangeWidget({
    super.key,
    required this.budgetRange,
    required this.onBudgetChanged,
  });

  String _getBudgetRangeText(double value) {
    if (value <= 100) return '\$50 - \$100';
    if (value <= 200) return '\$100 - \$200';
    if (value <= 300) return '\$200 - \$300';
    if (value <= 500) return '\$300 - \$500';
    if (value <= 750) return '\$500 - \$750';
    if (value <= 1000) return '\$750 - \$1000';
    return '\$1000+';
  }

  String _getBudgetDescription(double value) {
    if (value <= 100) return 'Basic maintenance and minor repairs';
    if (value <= 200) return 'Standard repairs and part replacements';
    if (value <= 300) return 'Major repairs and diagnostics';
    if (value <= 500) return 'Complex repairs and premium parts';
    if (value <= 750) return 'Extensive repairs and specialized work';
    if (value <= 1000) return 'Major overhauls and premium services';
    return 'No budget limit - premium services';
  }

  List<Map<String, dynamic>> _getBudgetCategories() {
    return [
      {
        'range': '\$50 - \$100',
        'description': 'Oil change, basic inspection',
        'icon': 'build',
        'value': 100.0,
      },
      {
        'range': '\$100 - \$300',
        'description': 'Brake service, tire replacement',
        'icon': 'settings',
        'value': 300.0,
      },
      {
        'range': '\$300 - \$500',
        'description': 'Engine diagnostics, major repairs',
        'icon': 'engineering',
        'value': 500.0,
      },
      {
        'range': '\$500+',
        'description': 'Complex repairs, premium parts',
        'icon': 'precision_manufacturing',
        'value': 1000.0,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget Range',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Set your budget to find mechanics within your price range',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Current budget display
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Selected Budget Range',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  _getBudgetRangeText(budgetRange),
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _getBudgetDescription(budgetRange),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Budget slider
          Container(
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
              children: [
                Text(
                  'Adjust Budget',
                  style: AppTheme.lightTheme.textTheme.titleSmall,
                ),
                SizedBox(height: 2.h),
                Slider(
                  value: budgetRange,
                  min: 50,
                  max: 1000,
                  divisions: 6,
                  onChanged: onBudgetChanged,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$50',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    Text(
                      '\$1000+',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Budget categories
          Text(
            'Common Service Ranges',
            style: AppTheme.lightTheme.textTheme.titleSmall,
          ),
          SizedBox(height: 2.h),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _getBudgetCategories().length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final category = _getBudgetCategories()[index];
              final isInRange = budgetRange >= category['value'] - 100 &&
                  budgetRange <= category['value'];

              return GestureDetector(
                onTap: () => onBudgetChanged(category['value']),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: isInRange
                        ? AppTheme.lightTheme.colorScheme.secondaryContainer
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isInRange
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: isInRange
                              ? AppTheme.lightTheme.colorScheme.secondary
                                  .withValues(alpha: 0.2)
                              : AppTheme.lightTheme.colorScheme
                                  .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: category['icon'],
                          color: isInRange
                              ? AppTheme.lightTheme.colorScheme.secondary
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
                              category['range'],
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: isInRange
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isInRange
                                    ? AppTheme.lightTheme.colorScheme
                                        .onSecondaryContainer
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              category['description'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: isInRange
                                    ? AppTheme.lightTheme.colorScheme
                                        .onSecondaryContainer
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 3.h),

          // Budget info
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiaryContainer,
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
                          AppTheme.lightTheme.colorScheme.onTertiaryContainer,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Budget Information',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Prices may vary based on vehicle type and complexity\n• You\'ll receive detailed quotes before work begins\n• No hidden fees - transparent pricing\n• Payment only after service completion',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onTertiaryContainer,
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
