import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReviewsSectionWidget extends StatelessWidget {
  final List reviews;
  final double rating;
  final int reviewCount;

  const ReviewsSectionWidget({
    super.key,
    required this.reviews,
    required this.rating,
    required this.reviewCount,
  });

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
                iconName: 'star',
                color: AppTheme.successColor,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Reviews & Ratings',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Navigate to all reviews screen
                },
                child: Text('See All Reviews'),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Rating Summary
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Rating Display
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          rating.toString(),
                          style: AppTheme.lightTheme.textTheme.headlineMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.successColor,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        CustomIconWidget(
                          iconName: 'star',
                          color: AppTheme.successColor,
                          size: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '$reviewCount reviews',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 6.w),

                // Rating Bars
                Expanded(
                  child: Column(
                    children: List.generate(5, (index) {
                      final starCount = 5 - index;
                      final percentage = _calculateRatingPercentage(starCount);

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.5.h),
                        child: Row(
                          children: [
                            Text(
                              '$starCount',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                            SizedBox(width: 1.w),
                            CustomIconWidget(
                              iconName: 'star',
                              color: AppTheme.successColor,
                              size: 12,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: percentage / 100,
                                backgroundColor: AppTheme
                                    .lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.successColor),
                                minHeight: 4,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '${percentage.toInt()}%',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Recent Reviews
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length > 3 ? 3 : reviews.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final review = reviews[index] as Map<String, dynamic>;

              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Review Header
                    Row(
                      children: [
                        // Customer Avatar
                        CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.primaryContainer,
                          child: Text(
                            (review["customerName"] as String)[0].toUpperCase(),
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(width: 3.w),

                        // Customer Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review["customerName"] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Row(
                                children: [
                                  // Rating Stars
                                  Row(
                                    children: List.generate(5, (starIndex) {
                                      return CustomIconWidget(
                                        iconName: starIndex <
                                                (review["rating"] as int)
                                            ? 'star'
                                            : 'star_border',
                                        color: AppTheme.successColor,
                                        size: 16,
                                      );
                                    }),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    review["date"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
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
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Review Comment
                    Text(
                      review["comment"] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),

                    // Review Photo
                    if (review["hasPhoto"] as bool &&
                        review["photoUrl"] != null) ...[
                      SizedBox(height: 2.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: review["photoUrl"] as String,
                          width: 25.w,
                          height: 15.h,
                          fit: BoxFit.cover,
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

  double _calculateRatingPercentage(int starCount) {
    // Mock calculation - in real app, this would be based on actual review data
    switch (starCount) {
      case 5:
        return 75.0;
      case 4:
        return 20.0;
      case 3:
        return 3.0;
      case 2:
        return 1.0;
      case 1:
        return 1.0;
      default:
        return 0.0;
    }
  }
}
