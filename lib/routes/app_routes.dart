import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/customer_home_screen/customer_home_screen.dart';
import '../presentation/mechanic_dashboard/mechanic_dashboard.dart';
import '../presentation/booking_management/booking_management.dart';
import '../presentation/mechanic_profile_detail/mechanic_profile_detail.dart';
import '../presentation/service_request_creation/service_request_creation.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String customerHomeScreen = '/customer-home-screen';
  static const String mechanicDashboard = '/mechanic-dashboard';
  static const String serviceRequestCreation = '/service-request-creation';
  static const String mechanicProfileDetail = '/mechanic-profile-detail';
  static const String bookingManagement = '/booking-management';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    customerHomeScreen: (context) => const CustomerHomeScreen(),
    mechanicDashboard: (context) => const MechanicDashboard(),
    serviceRequestCreation: (context) => const ServiceRequestCreation(),
    mechanicProfileDetail: (context) => const MechanicProfileDetail(),
    bookingManagement: (context) => const BookingManagement(),
  };
}
