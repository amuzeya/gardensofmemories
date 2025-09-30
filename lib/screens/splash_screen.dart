// YSL Beauty Experience - Splash Screen
// Immersive brand entry point with botanical/fragrance video background
// Following YSL brand principles: elegant, minimal, hard-edged rectangles

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_text.dart';
import '../theme/app_colors.dart';
import '../constants/assets.dart';

/// YSL Beauty Experience Splash Screen
/// Features:
/// - Botanical/Fragrance background video (Ourika)
/// - YSL brand identity
/// - "Enter Experience" CTA button
/// - Elegant, immersive brand world entry
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isVideoInitialized = false;
  bool _showContent = false;
  bool _videoFailed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeVideo();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
    ));
  }

  Future<void> _initializeVideo() async {
    try {
      debugPrint('🎬 Initializing video for ${kIsWeb ? "Web" : "Native"} platform');
      
      // Create video controller with asset
      _videoController = VideoPlayerController.asset('assets/splash_screen_ourika.mp4');
      
      // Add listener for errors and state changes
      _videoController!.addListener(() {
        if (_videoController!.value.hasError) {
          debugPrint('❌ Video error: ${_videoController!.value.errorDescription}');
          if (mounted) {
            setState(() {
              _videoFailed = true;
            });
            _showContentWithDelay();
          }
        }
      });
      
      // Initialize video
      debugPrint('📱 Initializing video player...');
      await _videoController!.initialize();
      
      if (mounted) {
        debugPrint('✅ Video initialized successfully');
        setState(() {
          _isVideoInitialized = true;
        });
        
        // Configure video for mobile autoplay
        await _videoController!.setLooping(true);
        await _videoController!.setVolume(0.0); // Muted is REQUIRED for mobile autoplay
        
        debugPrint('🎵 Video configured - muted and looping');
        
        // Start playback immediately
        debugPrint('▶️ Starting video playback...');
        await _videoController!.play();
        
        debugPrint('🎉 Video playing successfully!');
        
        // Show content after a brief delay
        _showContentWithDelay();
      }
    } catch (e) {
      debugPrint('💥 Video initialization failed: $e');
      if (mounted) {
        setState(() {
          _videoFailed = true;
        });
        _showContentWithDelay();
      }
    }
  }
  
  void _showContentWithDelay() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
        _animationController.forward();
        
        // Automatically navigate to entering experience after showing content for 5 seconds
        _startAutoNavigation();
      }
    });
  }
  
  void _startAutoNavigation() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _enterExperience();
      }
    });
  }

  void _enterExperience() {
    Navigator.pushReplacementNamed(context, '/entering');
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yslBlack,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Video or elegant gradient fallback
          if (_isVideoInitialized && _videoController != null && !_videoFailed)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            )
          else
            // Elegant botanical gradient fallback while video loads
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.3, 0.6, 1.0],
                  colors: [
                    Color(0xFF2D4A2D), // Rich botanical green
                    Color(0xFF1F3A1F), // Deep forest green
                    Color(0xFF1A2A1A), // Dark botanical
                    Color(0xFF0D0D0D), // Deep black
                  ],
                ),
              ),
            ),

          // Dark overlay for content readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),

          // Content Layer
          if (_showContent)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 2),

                            // YSL Brand Identity
                            Column(
                              children: [
                                // YSL Logo
                                SvgPicture.asset(
                                  Assets.logoYslMonogrammeOn,
                                  width: 300,
                                  height: 200,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                
                                const SizedBox(height: 24),

                                // Brand World Subtitle
                                // Text(
                                //   'BRAND WORLD EXPERIENCE',
                                //   style: AppText.displaySubtitle.copyWith(
                                //     color: AppColors.yslWhite.withValues(alpha: 0.9),
                                //     letterSpacing: 2.0,
                                //     shadows: [
                                //       Shadow(
                                //         color: Colors.black.withValues(alpha: 0.6),
                                //         offset: const Offset(0, 1),
                                //         blurRadius: 2,
                                //       ),
                                //     ],
                                //   ),
                                //   textAlign: TextAlign.center,
                                // ),

                                const SizedBox(height: 16),

                                // Botanical/Fragrance subtitle
                                // Text(
                                //   'DISCOVER THE ESSENCE OF LUXURY',
                                //   style: AppText.bodyLarge.copyWith(
                                //     color: AppColors.yslWhite.withValues(alpha: 0.8),
                                //     letterSpacing: 1.5,
                                //     shadows: [
                                //       Shadow(
                                //         color: Colors.black.withValues(alpha: 0.6),
                                //         offset: const Offset(0, 1),
                                //         blurRadius: 2,
                                //       ),
                                //     ],
                                //   ),
                                //   textAlign: TextAlign.center,
                                // ),
                              ],
                            ),

                            const Spacer(flex: 2),

                            // Botanical hint
                            // Text(
                            //   'AN IMMERSIVE JOURNEY AWAITS',
                            //   style: AppText.bodySmall.copyWith(
                            //     color: AppColors.yslWhite.withValues(alpha: 0.7),
                            //     letterSpacing: 1.2,
                            //     shadows: [
                            //       Shadow(
                            //         color: Colors.black.withValues(alpha: 0.6),
                            //         offset: const Offset(0, 1),
                            //         blurRadius: 2,
                            //       ),
                            //     ],
                            //   ),
                            //   textAlign: TextAlign.center,
                            // ),

                            const Spacer(flex: 1),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

          // Loading indicator while video initializes
          if (!_showContent)
             Align(
               alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.yslWhite),
                      strokeWidth: 2,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading...',
                      style: AppText.bodyMedium.copyWith(
                        color: AppColors.yslWhite,
                        letterSpacing: 1.2,
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
}