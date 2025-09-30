// YSL Location Bottom Sheet - Contextual location details overlay
// Appears after cinematic map animation completes
// Following YSL brand principles: minimal, elegant, black and white

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animations/animations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../models/home_location.dart';
import '../models/location_details.dart';
import 'ysl_carousel.dart';

class YslLocationBottomSheet extends StatefulWidget {
  final HomeLocation location;
  final LocationDetails? details;
  final VoidCallback? onClose;
  final bool isVisible;

  const YslLocationBottomSheet({
    super.key,
    required this.location,
    this.details,
    this.onClose,
    this.isVisible = false,
  });

  @override
  State<YslLocationBottomSheet> createState() => _YslLocationBottomSheetState();
}

class _YslLocationBottomSheetState extends State<YslLocationBottomSheet>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isDraggedUp = false;
  double _dragPosition = 0.5; // Start at 50% height
  double _dragScale = 1.0; // Scale factor during drag

  @override
  void initState() {
    super.initState();
    
    // Slide up animation - smooth and elegant
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000), // slower entrance
      reverseDuration: const Duration(milliseconds: 700), // gentle exit
      vsync: this,
    );
    
    // Pulse animation for drag handle
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800), // Slower pulse
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 1.0, // Start hidden (below screen)
      end: 0.5, // Show at 50% height
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic, // Smooth slide up
      reverseCurve: Curves.easeInCubic,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Start pulsing the drag handle
    _pulseController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(YslLocationBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isVisible && !oldWidget.isVisible) {
      // Show the bottom sheet with animation
      _showBottomSheet();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      // Hide the bottom sheet
      _hideBottomSheet();
    }
  }

  void _showBottomSheet() {
    _slideController.forward();
    // Start pulsing after slide completes
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _pulseController.repeat(reverse: true);
      }
    });
  }

  void _hideBottomSheet() {
    _slideController.reverse();
    _pulseController.stop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    // Fix: Add delta instead of subtract - swipe UP should open (reduce position), swipe DOWN should close (increase position)
    double newPosition = _dragPosition + (details.delta.dy / MediaQuery.of(context).size.height);
    
    // Add smooth resistance when dragging beyond boundaries
    if (newPosition < 0) {
      // Exponential resistance when dragging up beyond full screen
      newPosition = newPosition * 0.15; // 85% resistance when dragging up beyond full screen
    } else if (newPosition > 1) {
      // Exponential resistance when dragging down beyond bottom
      double excess = newPosition - 1;
      newPosition = 1 + excess * 0.15; // 85% resistance when dragging down beyond bottom
    }
    
    setState(() {
      _dragPosition = newPosition.clamp(-0.1, 1.1); // Allow slight overscroll
      _isDraggedUp = _dragPosition < 0.3; // Update expansion state
      
      // Subtle scale feedback during drag
      double velocity = details.delta.dy.abs() / 5.0; // Convert velocity to scale factor
      _dragScale = (1.0 + velocity * 0.002).clamp(0.98, 1.02); // Very subtle scale
    });
    
    // Stop pulsing while dragging
    _pulseController.stop();
  }

  void _onDragEnd(DragEndDetails details) {
    // Smooth animation to snap positions
    late double targetPosition;
    late bool shouldExpand;
    
    // Determine target based on velocity and position
    // Fix: Swap velocity directions - upward velocity (negative) should expand, downward (positive) should close
    if (details.velocity.pixelsPerSecond.dy < -800 || _dragPosition < 0.25) {
      // Fast upward swipe or already near top - snap to full screen
      targetPosition = 0.05; // Almost full screen
      shouldExpand = true;
      _pulseController.stop(); // Stop pulsing when fully expanded
      HapticFeedback.mediumImpact(); // Haptic feedback for full screen
    } else if (details.velocity.pixelsPerSecond.dy > 800 || _dragPosition > 0.75) {
      // Snap to hidden
      targetPosition = 1.0;
      shouldExpand = false;
      HapticFeedback.lightImpact(); // Haptic feedback for closing
    } else {
      // Snap back to half screen
      targetPosition = 0.5;
      shouldExpand = false;
      _pulseController.repeat(reverse: true); // Resume pulsing
      HapticFeedback.selectionClick(); // Subtle haptic for returning to half
    }
    
    // Smooth animation to target position
    final AnimationController snapController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    final Animation<double> snapAnimation = Tween<double>(
      begin: _dragPosition,
      end: targetPosition,
    ).animate(CurvedAnimation(
      parent: snapController,
      curve: Curves.easeOutQuart,
    ));
    
    snapController.addListener(() {
      setState(() {
        _dragPosition = snapAnimation.value;
        _isDraggedUp = shouldExpand;
        _dragScale = 1.0; // Reset scale during snap animation
      });
    });
    
    snapController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        snapController.dispose();
        if (targetPosition == 1.0) {
          // Close the sheet after hiding animation
          widget.onClose?.call();
        }
      }
    });
    
    snapController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        // Use either animation position or drag position
        final position = widget.isVisible ? _dragPosition : _slideAnimation.value;
        
        return Stack(
          children: [
            // Full-screen transparent backdrop to allow closing when tapping outside
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onClose,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: -screenHeight * position,
              height: screenHeight * 0.95, // 95% of screen height
              child: GestureDetector(
                onPanUpdate: _onDragUpdate,
                onPanEnd: _onDragEnd,
                child: FadeScaleTransition(
                  animation: CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
                  child: Transform.scale(
                    scale: _dragScale,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.yslWhite,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 20,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header with drag handle and close button
                  _buildHeader(),
                  
                  // Location content
                  Expanded(
                    child: _buildLocationContent(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
            )],
  );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          // Centered drag handle (aligned with ACTIVITY text below)
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isDraggedUp ? 1.0 : _pulseAnimation.value,
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.yslBlack.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Close button positioned at top-right
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.yslBlack,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.yslWhite,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: ListView(
        children: [
          // "ACTIVITY" aligned under handle - center aligned
          Center(
            child: Text(
              'ACTIVITY',
              style: AppText.bodySmall.copyWith(
                color: AppColors.yslBlack.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Location name - centered with biggest AppText font (heroDisplay)
          Center(
            child: Text(
              widget.location.name.toUpperCase(),
              style: AppText.heroDisplay.copyWith(
                color: AppColors.yslBlack,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Location address - lightweight, center aligned
          Center(
            child: Text(
              widget.location.address,
              style: AppText.bodyMedium.copyWith(
                color: AppColors.yslBlack.withOpacity(0.6),
                fontWeight: FontWeight.w300, // Lightweight
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // YSL Carousel component
          _buildLocationCarousel(),
          
          const SizedBox(height: 16),
          
          // Detailed description and CTA section
          if (widget.details?.detailedDescription != null)
            _buildDetailedContent(),
          
          // Bottom spacing to ensure content is not cut off
          const SizedBox(height: 40),
        ],
      ),
    );
  }
  
  /// Build YSL Carousel with location gallery images
  Widget _buildLocationCarousel() {
    // Create carousel items from location gallery
    final carouselItems = <YslCarouselItem>[];
    
    // Add gallery images from location details if available
    if (widget.details?.galleryLocal.isNotEmpty == true) {
      for (final imagePath in widget.details!.galleryLocal.take(5)) {
        carouselItems.add(
          YslCarouselItem(
            imagePath: imagePath,
            title: widget.location.name,
          ),
        );
      }
    }
    
    // Add remote gallery images as fallback
    if (carouselItems.isEmpty && widget.details?.galleryRemote.isNotEmpty == true) {
      for (final imageUrl in widget.details!.galleryRemote.take(5)) {
        carouselItems.add(
          YslCarouselItem(
            imagePath: imageUrl,
            title: widget.location.name,
          ),
        );
      }
    }
    
    // Fallback to location cover image if no gallery available
    if (carouselItems.isEmpty) {
      carouselItems.add(
        YslCarouselItem(
          imagePath: widget.location.image,
          title: widget.location.name,
        ),
      );
    }
    
    return SizedBox(
      height: 400,
      child: YslCarousel(
        items: carouselItems,
        height: 500,
        enableAutoPlay: false,
        autoPlayDuration: const Duration(seconds: 4),
        showIndicators: true,
      ),
    );
  }
  
  /// Build detailed description and CTA section
  Widget _buildDetailedContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Detailed description paragraph
          Text(
            widget.details!.detailedDescription!,
            style: AppText.bodyMedium.copyWith(
              color: AppColors.yslBlack,
              fontWeight: FontWeight.w300,
              height: 1.5,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // CTA Button
          if (widget.details?.cta != null)
            GestureDetector(
              onTap: () => _launchURL(widget.details!.cta!.url),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32, 
                  vertical: 12
                ),
                decoration: const BoxDecoration(
                  color: AppColors.yslBlack,
                  borderRadius: BorderRadius.zero, // Hard edges
                ),
                child: Text(
                  widget.details!.cta!.text,
                  style: AppText.button.copyWith(
                    color: AppColors.yslWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  /// Launch URL for CTA button
  void _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch URL: $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

}
