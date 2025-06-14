import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/availability_toggle_widget.dart';
import './widgets/calendar_widget.dart';
import './widgets/earnings_summary_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/service_request_card_widget.dart';
import './widgets/status_card_widget.dart';

class MechanicDashboard extends StatefulWidget {
  const MechanicDashboard({super.key});

  @override
  State<MechanicDashboard> createState() => _MechanicDashboardState();
}

class _MechanicDashboardState extends State<MechanicDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isOnline = true;
  bool _isRefreshing = false;

  // Mock data for dashboard
  final List<Map<String, dynamic>> _serviceRequests = [
    {
      "id": "REQ001",
      "customerName": "John Smith",
      "customerImage":
          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
      "vehicleInfo": "2019 Toyota Camry",
      "serviceType": "Engine Diagnostics",
      "location": "Downtown Plaza",
      "distance": "2.3 km",
      "estimatedPayment": "\$85.00",
      "urgency": "Medium",
      "requestTime": "15 mins ago",
      "description": "Engine making unusual noise during acceleration"
    },
    {
      "id": "REQ002",
      "customerName": "Sarah Johnson",
      "customerImage":
          "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg",
      "vehicleInfo": "2021 Honda Civic",
      "serviceType": "Tire Replacement",
      "location": "Mall Parking",
      "distance": "1.8 km",
      "estimatedPayment": "\$120.00",
      "urgency": "High",
      "requestTime": "8 mins ago",
      "description": "Flat tire needs immediate replacement"
    },
    {
      "id": "REQ003",
      "customerName": "Mike Davis",
      "customerImage":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg",
      "vehicleInfo": "2020 Ford F-150",
      "serviceType": "Battery Jump Start",
      "location": "Office Complex",
      "distance": "3.1 km",
      "estimatedPayment": "\$45.00",
      "urgency": "High",
      "requestTime": "22 mins ago",
      "description": "Car won't start, battery seems dead"
    }
  ];

  final List<Map<String, dynamic>> _todayAppointments = [
    {
      "time": "09:00 AM",
      "customerName": "Alex Wilson",
      "service": "Oil Change",
      "status": "confirmed"
    },
    {
      "time": "11:30 AM",
      "customerName": "Emma Brown",
      "service": "Brake Inspection",
      "status": "confirmed"
    },
    {
      "time": "02:00 PM",
      "customerName": "David Lee",
      "service": "AC Repair",
      "status": "pending"
    },
    {
      "time": "04:30 PM",
      "customerName": "Lisa Garcia",
      "service": "Transmission Check",
      "status": "confirmed"
    }
  ];

  final Map<String, dynamic> _dashboardStats = {
    "activeRequests": 12,
    "completionRate": 94.5,
    "customerRating": 4.8,
    "todayEarnings": "\$285.50",
    "weeklyEarnings": "\$1,847.25",
    "totalJobs": 156,
    "responseTime": "3.2 min"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 2.h),
                    _buildEarningsSummary(),
                    SizedBox(height: 3.h),
                    _buildStatusCards(),
                    SizedBox(height: 3.h),
                    _buildServiceRequestsSection(),
                    SizedBox(height: 3.h),
                    _buildCalendarSection(),
                    SizedBox(height: 3.h),
                    _buildQuickActions(),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 12.h,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning!',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Ready for work?',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  AvailabilityToggleWidget(
                    isOnline: _isOnline,
                    onToggle: _toggleAvailability,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarningsSummary() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: EarningsSummaryWidget(
        todayEarnings: _dashboardStats["todayEarnings"],
        weeklyEarnings: _dashboardStats["weeklyEarnings"],
      ),
    );
  }

  Widget _buildStatusCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: StatusCardWidget(
              title: 'Active Requests',
              value: _dashboardStats["activeRequests"].toString(),
              icon: 'assignment',
              color: AppTheme.accentColor,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: StatusCardWidget(
              title: 'Completion Rate',
              value: '${_dashboardStats["completionRate"]}%',
              icon: 'check_circle',
              color: AppTheme.successColor,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: StatusCardWidget(
              title: 'Rating',
              value: _dashboardStats["customerRating"].toString(),
              icon: 'star',
              color: AppTheme.warningColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Incoming Requests',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('View All'),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 25.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _serviceRequests.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 3.w),
                child: ServiceRequestCardWidget(
                  request: _serviceRequests[index],
                  onAccept: () => _handleAcceptRequest(_serviceRequests[index]),
                  onDecline: () =>
                      _handleDeclineRequest(_serviceRequests[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Today\'s Schedule',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: CalendarWidget(
            appointments: _todayAppointments,
            onAppointmentTap: _handleAppointmentTap,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: QuickActionsWidget(
        onUpdateAvailability: _toggleAvailability,
        onViewRoute: _handleViewRoute,
        onEmergencyToggle: _handleEmergencyToggle,
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.cardColor,
      selectedItemColor: AppTheme.lightTheme.primaryColor,
      unselectedItemColor: AppTheme.textSecondaryLight,
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: _currentIndex == 0
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.textSecondaryLight,
            size: 24,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'assignment',
            color: _currentIndex == 1
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.textSecondaryLight,
            size: 24,
          ),
          label: 'Requests',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'schedule',
            color: _currentIndex == 2
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.textSecondaryLight,
            size: 24,
          ),
          label: 'Schedule',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'account_balance_wallet',
            color: _currentIndex == 3
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.textSecondaryLight,
            size: 24,
          ),
          label: 'Earnings',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _currentIndex == 4
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.textSecondaryLight,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _toggleAvailability,
      backgroundColor:
          _isOnline ? AppTheme.successColor : AppTheme.textSecondaryLight,
      child: CustomIconWidget(
        iconName: _isOnline ? 'power_settings_new' : 'power_settings_new',
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dashboard updated successfully'),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleAvailability() {
    HapticFeedback.lightImpact();
    setState(() {
      _isOnline = !_isOnline;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isOnline ? 'You are now online' : 'You are now offline'),
        backgroundColor:
            _isOnline ? AppTheme.successColor : AppTheme.textSecondaryLight,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleAcceptRequest(Map<String, dynamic> request) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request accepted from ${request["customerName"]}'),
        backgroundColor: AppTheme.successColor,
        action: SnackBarAction(
          label: 'View Details',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/booking-management');
          },
        ),
      ),
    );
  }

  void _handleDeclineRequest(Map<String, dynamic> request) {
    HapticFeedback.lightImpact();
    _showDeclineReasonDialog(request);
  }

  void _showDeclineReasonDialog(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Decline Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Why are you declining this request?'),
              SizedBox(height: 2.h),
              ...[
                'Too far away',
                'Already booked',
                'Service not available',
                'Other'
              ]
                  .map((reason) => ListTile(
                        title: Text(reason),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Request declined: $reason'),
                              backgroundColor: AppTheme.warningColor,
                            ),
                          );
                        },
                      ))
                  ,
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _handleAppointmentTap(Map<String, dynamic> appointment) {
    Navigator.pushNamed(context, '/booking-management');
  }

  void _handleViewRoute() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening route to next job...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _handleEmergencyToggle() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Emergency services mode toggled'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to different screens based on index
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/service-request-creation');
        break;
      case 2:
        Navigator.pushNamed(context, '/booking-management');
        break;
      case 3:
        // Navigate to earnings screen (placeholder)
        break;
      case 4:
        Navigator.pushNamed(context, '/mechanic-profile-detail');
        break;
    }
  }
}
