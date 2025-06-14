import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/emergency_fab_widget.dart';
import './widgets/mechanic_card_widget.dart';
import './widgets/recent_booking_widget.dart';
import './widgets/service_type_chip_widget.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  // Mock data for nearby mechanics
  final List<Map<String, dynamic>> nearbyMechanics = [
    {
      "id": 1,
      "name": "John Mwangi",
      "photo":
          "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400",
      "rating": 4.8,
      "distance": "0.5 km",
      "isAvailable": true,
      "specialization": "Engine Repair",
      "experience": "8 years",
      "completedJobs": 245
    },
    {
      "id": 2,
      "name": "Sarah Wanjiku",
      "photo":
          "https://images.pexels.com/photos/3785077/pexels-photo-3785077.jpeg?auto=compress&cs=tinysrgb&w=400",
      "rating": 4.9,
      "distance": "1.2 km",
      "isAvailable": false,
      "specialization": "Electrical Systems",
      "experience": "6 years",
      "completedJobs": 189
    },
    {
      "id": 3,
      "name": "David Kiprotich",
      "photo":
          "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400",
      "rating": 4.7,
      "distance": "2.1 km",
      "isAvailable": true,
      "specialization": "Tire Service",
      "experience": "5 years",
      "completedJobs": 156
    }
  ];

  // Mock data for recent bookings
  final List<Map<String, dynamic>> recentBookings = [
    {
      "id": 1,
      "serviceName": "Engine Oil Change",
      "mechanicName": "John Mwangi",
      "date": "Today, 2:00 PM",
      "status": "confirmed",
      "price": "\$45.00",
      "vehicleType": "Toyota Corolla"
    },
    {
      "id": 2,
      "serviceName": "Brake Inspection",
      "mechanicName": "Sarah Wanjiku",
      "date": "Tomorrow, 10:00 AM",
      "status": "pending",
      "price": "\$35.00",
      "vehicleType": "Honda Civic"
    }
  ];

  // Service type options
  final List<Map<String, dynamic>> serviceTypes = [
    {"name": "Emergency", "icon": "emergency", "color": AppTheme.errorLight},
    {"name": "Maintenance", "icon": "build", "color": AppTheme.successColor},
    {"name": "Repair", "icon": "handyman", "color": AppTheme.warningColor},
    {"name": "Inspection", "icon": "search", "color": AppTheme.primaryLight}
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      // Simulate data refresh
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 2.h),
                _buildSearchBar(),
                SizedBox(height: 3.h),
                _buildBookServiceCard(),
                SizedBox(height: 2.h),
                _buildServiceTypeChips(),
                SizedBox(height: 3.h),
                _buildNearbyMechanicsSection(),
                SizedBox(height: 3.h),
                _buildRecentBookingsSection(),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: EmergencyFabWidget(
        onPressed: () {
          // Handle emergency service request
          _showEmergencyDialog();
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Location',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'location_on',
                    color: AppTheme.primaryLight,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Nairobi, Kenya',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: () {
                      // Handle location change
                    },
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.textSecondaryLight,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // Handle notifications
            },
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.textPrimaryLight,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search mechanics or services...',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                // Handle filter
              },
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'tune',
                  color: AppTheme.primaryLight,
                  size: 20,
                ),
              ),
            ),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          ),
        ),
      ),
    );
  }

  Widget _buildBookServiceCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryLight,
              AppTheme.primaryLight.withValues(alpha: 0.8)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryLight.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need Vehicle Service?',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Find qualified mechanics near you',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/service-request-creation');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryLight,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Book Service Now',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTypeChips() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Services',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: serviceTypes.map((service) {
                return Padding(
                  padding: EdgeInsets.only(right: 3.w),
                  child: ServiceTypeChipWidget(
                    name: service["name"] as String,
                    iconName: service["icon"] as String,
                    color: service["color"] as Color,
                    onTap: () {
                      Navigator.pushNamed(context, '/service-request-creation');
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyMechanicsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Mechanics',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle view all
                },
                child: Text('View All'),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: nearbyMechanics.length,
            itemBuilder: (context, index) {
              final mechanic = nearbyMechanics[index];
              return Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: MechanicCardWidget(
                  mechanic: mechanic,
                  onTap: () {
                    Navigator.pushNamed(context, '/mechanic-profile-detail');
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentBookingsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Bookings',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/booking-management');
                },
                child: Text('View All'),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentBookings.length,
            itemBuilder: (context, index) {
              final booking = recentBookings[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: RecentBookingWidget(
                  booking: booking,
                  onTap: () {
                    Navigator.pushNamed(context, '/booking-management');
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });

        switch (index) {
          case 0:
            // Already on home
            break;
          case 1:
            Navigator.pushNamed(context, '/booking-management');
            break;
          case 2:
            // Navigate to messages
            break;
          case 3:
            // Navigate to profile
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _currentIndex == 0
                ? AppTheme.primaryLight
                : AppTheme.textSecondaryLight,
            size: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'calendar_today',
            color: _currentIndex == 1
                ? AppTheme.primaryLight
                : AppTheme.textSecondaryLight,
            size: 24,
          ),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'message',
            color: _currentIndex == 2
                ? AppTheme.primaryLight
                : AppTheme.textSecondaryLight,
            size: 24,
          ),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _currentIndex == 3
                ? AppTheme.primaryLight
                : AppTheme.textSecondaryLight,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'emergency',
                color: AppTheme.errorLight,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text('Emergency Service'),
            ],
          ),
          content: Text(
            'Do you need immediate roadside assistance? This will connect you with the nearest available mechanic.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/service-request-creation');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorLight,
              ),
              child: Text('Request Help'),
            ),
          ],
        );
      },
    );
  }
}
