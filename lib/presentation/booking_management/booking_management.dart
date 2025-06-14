import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';
import './widgets/booking_card_widget.dart';
import './widgets/booking_filter_tabs_widget.dart';
import './widgets/empty_bookings_widget.dart';

class BookingManagement extends StatefulWidget {
  const BookingManagement({super.key});

  @override
  State<BookingManagement> createState() => _BookingManagementState();
}

class _BookingManagementState extends State<BookingManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _filterController;
  int _currentBottomIndex = 1; // Bookings tab active
  int _currentFilterIndex = 0; // Upcoming filter active
  bool _isRefreshing = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Mock booking data
  final List<Map<String, dynamic>> _allBookings = [
    {
      "id": "BK001",
      "serviceType": "Engine Repair",
      "serviceIcon": "build",
      "mechanicName": "John Doe",
      "mechanicPhoto":
          "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400",
      "mechanicRating": 4.8,
      "vehicleInfo": "Toyota Camry 2020",
      "scheduledDate": "2024-01-15",
      "scheduledTime": "10:00 AM",
      "status": "confirmed",
      "statusColor": "success",
      "estimatedDuration": "2 hours",
      "price": "\$150.00",
      "location": "Downtown Auto Center",
      "phoneNumber": "+1234567890",
      "category": "upcoming",
      "description": "Engine diagnostic and repair service",
      "createdAt": "2024-01-10T09:00:00Z"
    },
    {
      "id": "BK002",
      "serviceType": "Tire Service",
      "serviceIcon": "tire_repair",
      "mechanicName": "Sarah Wilson",
      "mechanicPhoto":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "mechanicRating": 4.9,
      "vehicleInfo": "Honda Civic 2019",
      "scheduledDate": "2024-01-12",
      "scheduledTime": "2:30 PM",
      "status": "in_progress",
      "statusColor": "warning",
      "estimatedDuration": "1 hour",
      "price": "\$80.00",
      "location": "Mobile Service",
      "phoneNumber": "+1234567891",
      "category": "in_progress",
      "description": "Tire replacement and alignment",
      "createdAt": "2024-01-08T14:30:00Z",
      "estimatedCompletion": "3:30 PM",
      "mechanicLocation": "En route to your location"
    },
    {
      "id": "BK003",
      "serviceType": "Oil Change",
      "serviceIcon": "oil_barrel",
      "mechanicName": "Mike Johnson",
      "mechanicPhoto":
          "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400",
      "mechanicRating": 4.7,
      "vehicleInfo": "Ford F-150 2021",
      "scheduledDate": "2024-01-05",
      "scheduledTime": "11:00 AM",
      "status": "completed",
      "statusColor": "success",
      "estimatedDuration": "30 minutes",
      "price": "\$45.00",
      "location": "Quick Lube Station",
      "phoneNumber": "+1234567892",
      "category": "completed",
      "description": "Regular oil change and filter replacement",
      "createdAt": "2024-01-03T10:00:00Z",
      "completedAt": "2024-01-05T11:30:00Z",
      "canRate": true,
      "invoiceAvailable": true
    },
    {
      "id": "BK004",
      "serviceType": "Brake Service",
      "serviceIcon": "car_repair",
      "mechanicName": "Lisa Chen",
      "mechanicPhoto":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
      "mechanicRating": 4.6,
      "vehicleInfo": "BMW X5 2022",
      "scheduledDate": "2024-01-18",
      "scheduledTime": "9:00 AM",
      "status": "confirmed",
      "statusColor": "success",
      "estimatedDuration": "3 hours",
      "price": "\$320.00",
      "location": "Premium Auto Care",
      "phoneNumber": "+1234567893",
      "category": "upcoming",
      "description": "Brake pad replacement and rotor resurfacing",
      "createdAt": "2024-01-11T16:00:00Z"
    },
    {
      "id": "BK005",
      "serviceType": "Battery Service",
      "serviceIcon": "battery_charging_full",
      "mechanicName": "David Rodriguez",
      "mechanicPhoto":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "mechanicRating": 4.5,
      "vehicleInfo": "Tesla Model 3 2023",
      "scheduledDate": "2024-01-02",
      "scheduledTime": "3:00 PM",
      "status": "completed",
      "statusColor": "success",
      "estimatedDuration": "45 minutes",
      "price": "\$120.00",
      "location": "Electric Vehicle Center",
      "phoneNumber": "+1234567894",
      "category": "completed",
      "description": "Battery diagnostic and maintenance",
      "createdAt": "2023-12-28T12:00:00Z",
      "completedAt": "2024-01-02T15:45:00Z",
      "canRate": true,
      "invoiceAvailable": true
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _filterController = TabController(length: 3, vsync: this);
    _filterController.addListener(_onFilterChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _filterController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onFilterChanged() {
    if (_filterController.indexIsChanging) {
      setState(() {
        _currentFilterIndex = _filterController.index;
      });
      HapticFeedback.selectionClick();
    }
  }

  List<Map<String, dynamic>> get _filteredBookings {
    List<Map<String, dynamic>> filtered = _allBookings;

    // Filter by category
    switch (_currentFilterIndex) {
      case 0: // Upcoming
        filtered = filtered
            .where((booking) => booking['category'] == 'upcoming')
            .toList();
        break;
      case 1: // In Progress
        filtered = filtered
            .where((booking) => booking['category'] == 'in_progress')
            .toList();
        break;
      case 2: // Completed
        filtered = filtered
            .where((booking) => booking['category'] == 'completed')
            .toList();
        break;
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((booking) {
        final mechanicName = (booking['mechanicName'] as String).toLowerCase();
        final serviceType = (booking['serviceType'] as String).toLowerCase();
        final vehicleInfo = (booking['vehicleInfo'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();

        return mechanicName.contains(query) ||
            serviceType.contains(query) ||
            vehicleInfo.contains(query);
      }).toList();
    }

    // Sort by date
    filtered.sort((a, b) {
      final dateA = DateTime.parse(a['scheduledDate']);
      final dateB = DateTime.parse(b['scheduledDate']);
      return _currentFilterIndex == 2
          ? dateB.compareTo(dateA)
          : dateA.compareTo(dateB);
    });

    return filtered;
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    HapticFeedback.lightImpact();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomIndex = index;
    });

    HapticFeedback.selectionClick();

    // Navigate to different screens based on index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/customer-home-screen');
        break;
      case 1:
        // Already on bookings screen
        break;
      case 2:
        Navigator.pushNamed(context, '/service-request-creation');
        break;
      case 3:
        // Navigate to profile or settings
        break;
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  void _onBookingTap(Map<String, dynamic> booking) {
    // Navigate to detailed booking view
    _showBookingDetails(booking);
  }

  void _showBookingDetails(Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
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
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: booking['serviceIcon'],
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking['serviceType'],
                                  style:
                                      AppTheme.lightTheme.textTheme.titleLarge,
                                ),
                                Text(
                                  'Booking ID: ${booking['id']}',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.getStatusColor(booking['status'])
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              booking['status'].toString().toUpperCase(),
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color:
                                    AppTheme.getStatusColor(booking['status']),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildDetailSection('Mechanic Information', [
                        _buildDetailRow('Name', booking['mechanicName']),
                        _buildDetailRow(
                            'Rating', '${booking['mechanicRating']} ⭐'),
                        _buildDetailRow('Phone', booking['phoneNumber']),
                      ]),
                      const SizedBox(height: 16),
                      _buildDetailSection('Service Details', [
                        _buildDetailRow('Vehicle', booking['vehicleInfo']),
                        _buildDetailRow('Date', booking['scheduledDate']),
                        _buildDetailRow('Time', booking['scheduledTime']),
                        _buildDetailRow(
                            'Duration', booking['estimatedDuration']),
                        _buildDetailRow('Price', booking['price']),
                        _buildDetailRow('Location', booking['location']),
                      ]),
                      if (booking['description'] != null) ...[
                        const SizedBox(height: 16),
                        _buildDetailSection('Description', [
                          Text(
                            booking['description'],
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ]),
                      ],
                      const SizedBox(height: 32),
                      _buildActionButtons(booking),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> booking) {
    final status = booking['status'] as String;

    return Column(
      children: [
        if (status == 'confirmed') ...[
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _rescheduleBooking(booking),
                  icon: CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 18,
                  ),
                  label: const Text('Reschedule'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _cancelBooking(booking),
                  icon: CustomIconWidget(
                    iconName: 'cancel',
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorLight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _messageOrCallMechanic(booking, 'message'),
              icon: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 18,
              ),
              label: const Text('Message Mechanic'),
            ),
          ),
        ],
        if (status == 'in_progress') ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _trackService(booking),
              icon: CustomIconWidget(
                iconName: 'location_on',
                color: Colors.white,
                size: 18,
              ),
              label: const Text('Track Service'),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _messageOrCallMechanic(booking, 'message'),
                  icon: CustomIconWidget(
                    iconName: 'message',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 18,
                  ),
                  label: const Text('Message'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _messageOrCallMechanic(booking, 'call'),
                  icon: CustomIconWidget(
                    iconName: 'phone',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 18,
                  ),
                  label: const Text('Call'),
                ),
              ),
            ],
          ),
        ],
        if (status == 'completed') ...[
          if (booking['canRate'] == true) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _rateService(booking),
                icon: CustomIconWidget(
                  iconName: 'star',
                  color: Colors.white,
                  size: 18,
                ),
                label: const Text('Rate Service'),
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (booking['invoiceAvailable'] == true) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _viewInvoice(booking),
                icon: CustomIconWidget(
                  iconName: 'receipt',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 18,
                ),
                label: const Text('View Invoice'),
              ),
            ),
          ],
        ],
      ],
    );
  }

  void _rescheduleBooking(Map<String, dynamic> booking) {
    Navigator.pop(context);
    // Implement reschedule functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reschedule booking ${booking['id']}'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _cancelBooking(Map<String, dynamic> booking) {
    Navigator.pop(context);
    // Implement cancel functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content:
            Text('Are you sure you want to cancel booking ${booking['id']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Booking ${booking['id']} cancelled')),
              );
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.errorLight),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _messageOrCallMechanic(Map<String, dynamic> booking, String action) {
    Navigator.pop(context);
    final actionText = action == 'message' ? 'Message' : 'Call';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$actionText ${booking['mechanicName']}')),
    );
  }

  void _trackService(Map<String, dynamic> booking) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tracking service for ${booking['id']}')),
    );
  }

  void _rateService(Map<String, dynamic> booking) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rate service for ${booking['id']}')),
    );
  }

  void _viewInvoice(Map<String, dynamic> booking) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View invoice for ${booking['id']}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBookings = _filteredBookings;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Show calendar view
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calendar view')),
              );
            },
            icon: CustomIconWidget(
              iconName: 'calendar_today',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.lightTheme.colorScheme.surface,
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search bookings...',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: _clearSearch,
                        icon: CustomIconWidget(
                          iconName: 'clear',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.lightTheme.colorScheme.surface,
              ),
            ),
          ),

          // Filter tabs
          BookingFilterTabsWidget(
            controller: _filterController,
            onTap: (index) {
              setState(() {
                _currentFilterIndex = index;
              });
            },
          ),

          // Bookings list
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppTheme.lightTheme.colorScheme.primary,
              child: filteredBookings.isEmpty
                  ? EmptyBookingsWidget(
                      filterType: _currentFilterIndex == 0
                          ? 'upcoming'
                          : _currentFilterIndex == 1
                              ? 'in_progress'
                              : 'completed',
                      onBookService: () {
                        Navigator.pushNamed(
                            context, '/service-request-creation');
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filteredBookings.length,
                      itemBuilder: (context, index) {
                        final booking = filteredBookings[index];
                        return BookingCardWidget(
                          booking: booking,
                          onTap: () => _onBookingTap(booking),
                          onCancel: () => _cancelBooking(booking),
                          onReschedule: () => _rescheduleBooking(booking),
                          onMessage: () =>
                              _messageOrCallMechanic(booking, 'message'),
                          onCall: () => _messageOrCallMechanic(booking, 'call'),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentBottomIndex == 0
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'book_online',
              color: _currentBottomIndex == 1
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'add_circle',
              color: _currentBottomIndex == 2
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'Book Service',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentBottomIndex == 3
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/service-request-creation');
        },
        backgroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
