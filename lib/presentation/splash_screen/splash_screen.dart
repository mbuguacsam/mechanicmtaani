import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isLoading = true;
  bool _hasError = false;
  bool _showRetry = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    _logoAnimationController.forward();
    _fadeAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.primaryLight,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // Simulate initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserPreferences(),
        _fetchMechanicAvailability(),
        _prepareLocationServices(),
        Future.delayed(const Duration(seconds: 2)), // Minimum splash duration
      ]);

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        _showRetryAfterDelay();
      }
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    // Simulate authentication check
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _fetchMechanicAvailability() async {
    // Simulate fetching mechanic availability
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _prepareLocationServices() async {
    // Simulate preparing location services
    await Future.delayed(const Duration(milliseconds: 600));
  }

  void _showRetryAfterDelay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _hasError) {
        setState(() {
          _showRetry = true;
        });
      }
    });
  }

  void _navigateToNextScreen() {
    // Mock authentication logic
    final bool isAuthenticated = _mockAuthenticationCheck();
    final bool isMechanic = _mockUserTypeCheck();

    String nextRoute;
    if (isAuthenticated) {
      nextRoute = isMechanic ? '/mechanic-dashboard' : '/customer-home-screen';
    } else {
      nextRoute = '/customer-home-screen'; // Default to customer home for demo
    }

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  bool _mockAuthenticationCheck() {
    // Mock authentication - return true for demo
    return true;
  }

  bool _mockUserTypeCheck() {
    // Mock user type check - return false for customer demo
    return false;
  }

  void _retryInitialization() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _showRetry = false;
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryLight,
              AppTheme.primaryLight.withValues(alpha: 0.8),
              AppTheme.secondaryLight.withValues(alpha: 0.6),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo with Animation
                    AnimatedBuilder(
                      animation: _logoScaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildAppLogo(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // App Name
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'MechanicMtaani',
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Tagline
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Your Trusted Automotive Partner',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Loading/Error State
              _buildBottomSection(),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'build',
            color: AppTheme.primaryLight,
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            'MM',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.primaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    if (_hasError) {
      return Column(
        children: [
          CustomIconWidget(
            iconName: 'error_outline',
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to initialize app',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your internet connection',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          if (_showRetry) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _retryInitialization,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryLight,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.primaryLight,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Retry',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }

    if (_isLoading) {
      return Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Initializing services...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
