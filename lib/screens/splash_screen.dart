import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/trackly_logo.dart';

class SplashScreen extends StatefulWidget {
  final Duration duration;
  final VoidCallback? onComplete;

  const SplashScreen({
    super.key,
    this.duration = const Duration(minutes: 1),
    this.onComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAutoNavigate();
  }

  void _initializeAnimations() {
    // Rotation animation controller untuk spinner
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Infinite rotation

    // Fade animation untuk splash screen
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startAutoNavigate() {
    Timer(widget.duration, () {
      if (mounted) {
        // Fade out transition sebelum navigate
        _rotationController.forward();
        
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted && context.mounted) {
            widget.onComplete?.call();
            Navigator.of(context, rootNavigator: true).pop();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFC68642), // Cardboard brown
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spinner dengan Trackly Logo
                RotationTransition(
                  turns: _rotationController,
                  child: const TracklyLogo(size: 100),
                ),

                const SizedBox(height: 40),

                // Loading Text
                const Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

