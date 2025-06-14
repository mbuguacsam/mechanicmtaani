import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoUploadWidget extends StatelessWidget {
  final List<String> uploadedPhotos;
  final Function(List<String>) onPhotosChanged;

  // Mock photo URLs for demonstration
  final List<String> _mockPhotos = [
    'https://images.pexels.com/photos/3806288/pexels-photo-3806288.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/13065690/pexels-photo-13065690.jpeg?auto=compress&cs=tinysrgb&w=600',
    'https://images.pexels.com/photos/3807277/pexels-photo-3807277.jpeg?auto=compress&cs=tinysrgb&w=600',
  ];

  const PhotoUploadWidget({
    super.key,
    required this.uploadedPhotos,
    required this.onPhotosChanged,
  });

  void _addPhoto() {
    if (uploadedPhotos.length < 5) {
      final newPhotos = List<String>.from(uploadedPhotos);
      // Simulate adding a photo
      final photoIndex = uploadedPhotos.length % _mockPhotos.length;
      newPhotos.add(_mockPhotos[photoIndex]);
      onPhotosChanged(newPhotos);
    }
  }

  void _removePhoto(int index) {
    final newPhotos = List<String>.from(uploadedPhotos);
    newPhotos.removeAt(index);
    onPhotosChanged(newPhotos);
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                'Add Photo',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _addPhoto();
                      },
                      child: Container(
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
                            CustomIconWidget(
                              iconName: 'camera_alt',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 32,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Camera',
                              style: AppTheme.lightTheme.textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _addPhoto();
                      },
                      child: Container(
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
                            CustomIconWidget(
                              iconName: 'photo_library',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 32,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Gallery',
                              style: AppTheme.lightTheme.textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
            ],
          ),
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
            'Add Photos (Optional)',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Photos help mechanics understand the issue better. You can add up to 5 photos.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Photo grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1,
            ),
            itemCount:
                uploadedPhotos.length + (uploadedPhotos.length < 5 ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == uploadedPhotos.length) {
                // Add photo button
                return GestureDetector(
                  onTap: () => _showPhotoOptions(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'add_a_photo',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 32,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Add Photo',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Photo thumbnail
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomImageWidget(
                        imageUrl: uploadedPhotos[index],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 1.w,
                    right: 1.w,
                    child: GestureDetector(
                      onTap: () => _removePhoto(index),
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.errorLight,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'close',
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          SizedBox(height: 3.h),

          // Tips section
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
                      iconName: 'lightbulb',
                      color:
                          AppTheme.lightTheme.colorScheme.onSecondaryContainer,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Photo Tips',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme
                            .lightTheme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Take clear, well-lit photos\n• Show the problem area from different angles\n• Include any warning lights or error messages\n• Capture any visible damage or wear',
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