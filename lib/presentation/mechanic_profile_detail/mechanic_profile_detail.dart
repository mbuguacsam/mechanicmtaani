import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/contact_buttons_widget.dart';
import './widgets/hero_section_widget.dart';
import './widgets/location_card_widget.dart';
import './widgets/portfolio_gallery_widget.dart';
import './widgets/reviews_section_widget.dart';
import './widgets/services_section_widget.dart';

class MechanicProfileDetail extends StatefulWidget {
  const MechanicProfileDetail({super.key});

  @override
  State<MechanicProfileDetail> createState() => _MechanicProfileDetailState();
}

class _MechanicProfileDetailState extends State<MechanicProfileDetail> {
  final ScrollController _scrollController = ScrollController();
  bool _isFavorite = false;
  bool _isRefreshing = false;

  // Mock data for mechanic profile
  final Map<String, dynamic> mechanicData = {
    "id": 1,
    "name": "John Mwangi",
    "businessName": "Mwangi Auto Repairs",
    "profileImage":
        "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "rating": 4.8,
    "reviewCount": 127,
    "yearsExperience": 8,
    "isVerified": true,
    "isOnline": true,
    "responseTime": "Usually responds within 15 minutes",
    "completionRate": 98,
    "services": [
      {
        "category": "Engine Repair",
        "description": "Complete engine diagnostics and repair services",
        "priceRange": "\$50 - \$300",
        "isExpanded": false
      },
      {
        "category": "Brake Service",
        "description":
            "Brake pad replacement, disc servicing, and brake fluid change",
        "priceRange": "\$30 - \$150",
        "isExpanded": false
      },
      {
        "category": "Electrical Systems",
        "description":
            "Battery replacement, alternator repair, and wiring issues",
        "priceRange": "\$25 - \$200",
        "isExpanded": false
      },
      {
        "category": "Tire Services",
        "description": "Tire replacement, balancing, and alignment services",
        "priceRange": "\$20 - \$120",
        "isExpanded": false
      }
    ],
    "portfolio": [
      "https://images.pexels.com/photos/3806288/pexels-photo-3806288.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/4489702/pexels-photo-4489702.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/3807277/pexels-photo-3807277.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/13065690/pexels-photo-13065690.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/3807738/pexels-photo-3807738.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    ],
    "reviews": [
      {
        "customerName": "Sarah Wanjiku",
        "rating": 5,
        "comment":
            "Excellent service! Fixed my engine problem quickly and professionally. Highly recommended!",
        "date": "2024-01-15",
        "hasPhoto": true,
        "photoUrl":
            "https://images.pexels.com/photos/3807277/pexels-photo-3807277.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&dpr=1"
      },
      {
        "customerName": "David Kimani",
        "rating": 5,
        "comment":
            "Very honest mechanic. Explained everything clearly and charged fair prices.",
        "date": "2024-01-10",
        "hasPhoto": false,
        "photoUrl": null
      },
      {
        "customerName": "Grace Njeri",
        "rating": 4,
        "comment":
            "Good work on my brake service. Arrived on time and completed the job efficiently.",
        "date": "2024-01-08",
        "hasPhoto": true,
        "photoUrl":
            "https://images.pexels.com/photos/4489702/pexels-photo-4489702.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&dpr=1"
      }
    ],
    "location": {
      "area": "Westlands, Nairobi",
      "distance": "2.3 km away",
      "mapPreview":
          "https://images.pexels.com/photos/2422915/pexels-photo-2422915.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
    },
    "phone": "+254 712 345 678"
  };

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Sticky App Bar with Hero Image
            SliverAppBar(
              expandedHeight: 30.h,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: _toggleFavorite,
                  icon: CustomIconWidget(
                    iconName: _isFavorite ? 'favorite' : 'favorite_border',
                    color: _isFavorite
                        ? AppTheme.errorLight
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
                SizedBox(width: 2.w),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: HeroSectionWidget(
                  mechanicData: mechanicData,
                  isRefreshing: _isRefreshing,
                ),
              ),
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // Services Section
                  ServicesSectionWidget(
                      services: mechanicData["services"] as List),

                  SizedBox(height: 3.h),

                  // Portfolio Gallery
                  PortfolioGalleryWidget(
                      portfolio: mechanicData["portfolio"] as List<String>),

                  SizedBox(height: 3.h),

                  // Reviews Section
                  ReviewsSectionWidget(
                    reviews: mechanicData["reviews"] as List,
                    rating: mechanicData["rating"] as double,
                    reviewCount: mechanicData["reviewCount"] as int,
                  ),

                  SizedBox(height: 3.h),

                  // Location Card
                  LocationCardWidget(
                      location:
                          mechanicData["location"] as Map<String, dynamic>),

                  SizedBox(height: 10.h), // Space for floating contact buttons
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Contact Buttons
      floatingActionButton: ContactButtonsWidget(
        phone: mechanicData["phone"] as String,
        mechanicName: mechanicData["name"] as String,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
