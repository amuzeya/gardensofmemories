// YSL Beauty Experience - Loading Screen
// Elegant loading sequence before entering the experience
// Following YSL brand principles: minimal, elegant, luxury feel

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_text.dart';
import '../theme/app_colors.dart';
import '../constants/assets.dart';
import 'entering_experience_screen.dart';

/// YSL Beauty Experience Loading Screen
/// Features:
/// - Elegant loading animation
/// - YSL brand identity
/// - Smooth transition to entering experience
/// - Loading delay + 3 second display as requested
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isLoaded = false;
  int _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startLoadingSequence();
  }

  void _initializeAnimations() {
    // Pulse animation for logo
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Fade animation for content
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _pulseController.repeat(reverse: true);
    _fadeController.forward();
  }

  Future<void> _startLoadingSequence() async {
    // Simulate loading process
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) {
        setState(() {
          _loadingProgress = i;
        });
      }
    }

    // Mark as loaded
    if (mounted) {
      setState(() {
        _isLoaded = true;
      });

      // Wait 3 seconds as requested, then navigate
      await Future.delayed(const Duration(seconds: 3));
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const EnteringExperienceScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 1000),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yslBlack,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // YSL Logo with pulse animation
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: SvgPicture.asset(
                          Assets.logoYslMonogrammeOn,
                          width: 150,
                          height: 100,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Loading text
                  Text(
                    _isLoaded ? 'EXPERIENCE READY' : 'PREPARING EXPERIENCE',
                    style: AppText.titleMedium.copyWith(
                      color: AppColors.yslWhite,
                      letterSpacing: 2.0,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  // Loading progress
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Column(
                      children: [
                        // Progress bar
                        Container(
                          height: 2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.yslWhite.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.zero, // Hard edges
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 2,
                            width: MediaQuery.of(context).size.width * 
                                   (_loadingProgress / 100) * 0.7, // 0.7 accounts for padding
                            decoration: const BoxDecoration(
                              color: AppColors.yslWhite,
                              borderRadius: BorderRadius.zero, // Hard edges
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Progress percentage
                        Text(
'$_loadingProgress%',
                          style: AppText.bodyLarge.copyWith(
                            color: AppColors.yslWhite.withValues(alpha: 0.7),
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Brand tagline
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'GARDENS OF MEMORIES AWAIT',
                      style: AppText.bodySmall.copyWith(
                        color: AppColors.yslWhite.withValues(alpha: 0.6),
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}