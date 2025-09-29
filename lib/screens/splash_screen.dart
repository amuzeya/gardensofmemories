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
  bool _isMobile = false;
  bool _videoFailed = false;

  @override
  void initState() {
    super.initState();
    _detectPlatform();
    _initializeAnimations();
    _initializeVideo();
  }

  void _detectPlatform() {
    // Detect if running on mobile web or mobile app
    _isMobile = kIsWeb ? _isMobileWeb() : (Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.android);
    debugPrint('Platform detected - Mobile: $_isMobile, Web: $kIsWeb');
  }

  bool _isMobileWeb() {
    // For web, we need to check user agent or screen size
    // Using screen size as a heuristic for mobile detection
    final data = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first);
    return data.size.width < 768; // Tablet breakpoint
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
    // Skip video initialization on mobile to avoid autoplay issues
    if (_isMobile && kIsWeb) {
      debugPrint('Mobile web detected - skipping video autoplay');
      setState(() {
        _videoFailed = true;
      });
      _showContentWithDelay();
      return;
    }
    
    try {
      debugPrint('Initializing video for platform: ${kIsWeb ? "Web" : "Native"}, Mobile: $_isMobile');
      
      // Create video controller
      _videoController = VideoPlayerController.asset('assets/splash_screen_ourika.mp4');
      
      // Set up listener for initialization
      _videoController!.addListener(() {
        if (_videoController!.value.hasError) {
          debugPrint('Video playback error: ${_videoController!.value.errorDescription}');
          if (mounted) {
            setState(() {
              _videoFailed = true;
            });
          }
        }
      });
      
      // Initialize video with timeout
      await _videoController!.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Video initialization timeout');
        },
      );
      
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
        
        // Configure video for optimal playback
        _videoController!.setLooping(true);
        _videoController!.setVolume(0.0); // Muted for autoplay compliance
        
        // Attempt to play video
        try {
          await _videoController!.play();
          debugPrint('Video playback started successfully');
        } catch (playError) {
          debugPrint('Video play error: $playError');
          if (mounted) {
            setState(() {
              _videoFailed = true;
            });
          }
        }
        
        // Show content after video starts
        _showContentWithDelay();
      }
    } catch (e) {
      debugPrint('Video initialization error: $e');
      if (mounted) {
        setState(() {
          _videoFailed = true;
        });
        // Show content even if video fails
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
          // Background: Video or enhanced gradient fallback
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
            // Enhanced botanical gradient fallback for mobile and video failures
            Container(
              decoration: BoxDecoration(
                gradient: _isMobile ? 
                  // Mobile-optimized gradient with more visual interest
                  const RadialGradient(
                    center: Alignment.topLeft,
                    radius: 1.5,
                    stops: [0.0, 0.3, 0.6, 1.0],
                    colors: [
                      Color(0xFF3E5E3E), // Brighter botanical green
                      Color(0xFF2D4A2D), // Rich botanical green
                      Color(0xFF1F3A1F), // Deep forest green
                      Color(0xFF0D0D0D), // Deep black
                    ],
                  ) :
                  // Desktop gradient
                  const LinearGradient(
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
              child: _isMobile ? 
                // Add subtle pattern for mobile to compensate for missing video
                Container(
                  decoration: BoxDecoration(
                    backgroundBlendMode: BlendMode.overlay,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.5, 1.0],
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ) : null,
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
                                Text(
                                  'BRAND WORLD EXPERIENCE',
                                  style: AppText.displaySubtitle.copyWith(
                                    color: AppColors.yslWhite.withValues(alpha: 0.9),
                                    letterSpacing: 2.0,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(alpha: 0.6),
                                        offset: const Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 16),

                                // Botanical/Fragrance subtitle
                                Text(
                                  'DISCOVER THE ESSENCE OF LUXURY',
                                  style: AppText.bodyLarge.copyWith(
                                    color: AppColors.yslWhite.withValues(alpha: 0.8),
                                    letterSpacing: 1.5,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(alpha: 0.6),
                                        offset: const Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),

                            const Spacer(flex: 2),

                            // Botanical hint
                            Text(
                              'AN IMMERSIVE JOURNEY AWAITS',
                              style: AppText.bodySmall.copyWith(
                                color: AppColors.yslWhite.withValues(alpha: 0.7),
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    offset: const Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),

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
             Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.yslWhite),
                    strokeWidth: 2,
                  ),
                  SizedBox(height: 16),
                  Text(
                    _isMobile ? 'Entering Experience...' : 'Loading...',
                    style: AppText.bodyMedium.copyWith(
                      color: AppColors.yslWhite,
                      letterSpacing: 1.2,
                    ),
                  ),
                  if (_isMobile && kIsWeb)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'For full video experience, visit on desktop',
                        style: AppText.bodySmall.copyWith(
                          color: AppColors.yslWhite.withValues(alpha: 0.7),
                          letterSpacing: 0.8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}