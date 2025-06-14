import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/budget_range_widget.dart';
import './widgets/issue_description_widget.dart';
import './widgets/location_section_widget.dart';
import './widgets/photo_upload_widget.dart';
import './widgets/service_category_widget.dart';
import './widgets/timing_picker_widget.dart';
import './widgets/vehicle_selection_widget.dart';

class ServiceRequestCreation extends StatefulWidget {
  const ServiceRequestCreation({super.key});

  @override
  State<ServiceRequestCreation> createState() => _ServiceRequestCreationState();
}

class _ServiceRequestCreationState extends State<ServiceRequestCreation>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 7;
  bool _isLoading = false;

  // Form data
  String? _selectedVehicle;
  final List<String> _selectedCategories = [];
  String _issueDescription = '';
  List<String> _uploadedPhotos = [];
  String _currentLocation = 'Current Location';
  String _preferredTiming = '';
  double _budgetRange = 100.0;

  // Mock data
  final List<Map<String, dynamic>> _vehicles = [
    {
      'id': '1',
      'name': 'Toyota Camry 2020',
      'plate': 'ABC-123',
      'type': 'Sedan',
    },
    {
      'id': '2',
      'name': 'Honda Civic 2019',
      'plate': 'XYZ-456',
      'type': 'Sedan',
    },
    {
      'id': '3',
      'name': 'Ford F-150 2021',
      'plate': 'DEF-789',
      'type': 'Truck',
    },
  ];

  final List<Map<String, dynamic>> _serviceCategories = [
    {'name': 'Engine', 'icon': 'build', 'selected': false},
    {'name': 'Brakes', 'icon': 'disc_full', 'selected': false},
    {'name': 'Electrical', 'icon': 'electrical_services', 'selected': false},
    {'name': 'Tires', 'icon': 'tire_repair', 'selected': false},
    {'name': 'Oil Change', 'icon': 'oil_barrel', 'selected': false},
    {'name': 'Inspection', 'icon': 'search', 'selected': false},
    {'name': 'Other', 'icon': 'more_horiz', 'selected': false},
  ];

  final List<Map<String, dynamic>> _timingOptions = [
    {'label': 'ASAP', 'value': 'asap', 'description': 'Within 2 hours'},
    {'label': 'Today', 'value': 'today', 'description': 'Same day service'},
    {
      'label': 'Tomorrow',
      'value': 'tomorrow',
      'description': 'Next day service'
    },
    {
      'label': 'Schedule Later',
      'value': 'schedule',
      'description': 'Pick a date & time'
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _canProceedToNext() {
    switch (_currentStep) {
      case 0:
        return _selectedVehicle != null;
      case 1:
        return _selectedCategories.isNotEmpty;
      case 2:
        return _issueDescription.trim().isNotEmpty;
      case 3:
        return true; // Photos are optional
      case 4:
        return _currentLocation.isNotEmpty;
      case 5:
        return _preferredTiming.isNotEmpty;
      case 6:
        return _budgetRange > 0;
      default:
        return false;
    }
  }

  void _findMechanics() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Navigate to mechanic list or show results
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Found 5 mechanics nearby!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed:
              _currentStep > 0 ? _previousStep : () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Request Service',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Center(
              child: Text(
                '${_currentStep + 1}/$_totalSteps',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.primary,
              ),
              minHeight: 4,
            ),
          ),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildVehicleSelectionStep(),
                _buildServiceCategoryStep(),
                _buildIssueDescriptionStep(),
                _buildPhotoUploadStep(),
                _buildLocationStep(),
                _buildTimingStep(),
                _buildBudgetStep(),
              ],
            ),
          ),

          // Bottom navigation
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: Text('Back'),
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: 4.w),
                  Expanded(
                    flex: 2,
                    child: _currentStep == _totalSteps - 1
                        ? ElevatedButton(
                            onPressed: _canProceedToNext() && !_isLoading
                                ? _findMechanics
                                : null,
                            child: _isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text('Find Mechanics'),
                          )
                        : ElevatedButton(
                            onPressed: _canProceedToNext() ? _nextStep : null,
                            child: Text('Next'),
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

  Widget _buildVehicleSelectionStep() {
    return VehicleSelectionWidget(
      vehicles: _vehicles,
      selectedVehicle: _selectedVehicle,
      onVehicleSelected: (vehicle) {
        setState(() {
          _selectedVehicle = vehicle;
        });
      },
      onAddVehicle: () {
        // Navigate to add vehicle screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Add vehicle functionality')),
        );
      },
    );
  }

  Widget _buildServiceCategoryStep() {
    return ServiceCategoryWidget(
      categories: _serviceCategories,
      selectedCategories: _selectedCategories,
      onCategoryToggled: (category) {
        setState(() {
          if (_selectedCategories.contains(category)) {
            _selectedCategories.remove(category);
          } else {
            _selectedCategories.add(category);
          }
        });
      },
    );
  }

  Widget _buildIssueDescriptionStep() {
    return IssueDescriptionWidget(
      description: _issueDescription,
      onDescriptionChanged: (value) {
        setState(() {
          _issueDescription = value;
        });
      },
    );
  }

  Widget _buildPhotoUploadStep() {
    return PhotoUploadWidget(
      uploadedPhotos: _uploadedPhotos,
      onPhotosChanged: (photos) {
        setState(() {
          _uploadedPhotos = photos;
        });
      },
    );
  }

  Widget _buildLocationStep() {
    return LocationSectionWidget(
      currentLocation: _currentLocation,
      onLocationChanged: (location) {
        setState(() {
          _currentLocation = location;
        });
      },
    );
  }

  Widget _buildTimingStep() {
    return TimingPickerWidget(
      timingOptions: _timingOptions,
      selectedTiming: _preferredTiming,
      onTimingSelected: (timing) {
        setState(() {
          _preferredTiming = timing;
        });
      },
    );
  }

  Widget _buildBudgetStep() {
    return BudgetRangeWidget(
      budgetRange: _budgetRange,
      onBudgetChanged: (value) {
        setState(() {
          _budgetRange = value;
        });
      },
    );
  }
}
