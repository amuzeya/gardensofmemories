// YSL Location Bottom Sheet - Contextual location details overlay
// Appears after cinematic map animation completes
// Following YSL brand principles: minimal, elegant, black and white

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animations/animations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../models/home_location.dart';

class YslLocationBottomSheet extends StatefulWidget {
  final HomeLocation location;
  final VoidCallback? onClose;
  final bool isVisible;

  const YslLocationBottomSheet({
    super.key,
    required this.location,
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
    double newPosition = _dragPosition - (details.delta.dy / MediaQuery.of(context).size.height);
    
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
    if (details.velocity.pixelsPerSecond.dy < -800 || _dragPosition < 0.25) {
      // Snap to full screen
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
      child: Row(
        children: [
          // Spacer for centering drag handle
          const Spacer(),
          
          // Animated drag handle
          AnimatedBuilder(
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
          
          // Spacer and close button
          const Spacer(),
          
          // Close button
          GestureDetector(
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
        ],
      ),
    );
  }

  Widget _buildLocationContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location category
          Text(
            widget.location.type.name.toUpperCase(),
            style: AppText.bodySmall.copyWith(
              color: AppColors.yslBlack.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              fontFamily: 'ITC Avant Garde Gothic Pro',
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Location name
          Text(
            widget.location.name.toUpperCase(),
            style: AppText.titleLarge.copyWith(
              color: AppColors.yslBlack,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              fontFamily: 'ITC Avant Garde Gothic Pro',
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Location address
          Text(
            '${widget.location.address}, ${widget.location.city}',
            style: AppText.bodyMedium.copyWith(
              color: AppColors.yslBlack.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.4,
              fontFamily: 'ITC Avant Garde Gothic Pro',
            ),
          ),
          
          if (widget.location.distance != null && widget.location.distance!.isNotEmpty) ...[
            const SizedBox(height: 12),
            
            // Distance
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppColors.yslBlack.withOpacity(0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.location.distance!,
                  style: AppText.bodySmall.copyWith(
                    color: AppColors.yslBlack.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 32),
          
          // Placeholder for future content
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.yslBlack.withOpacity(0.1),
          ),
          
          const SizedBox(height: 20),
          
          Text(
            'LOCATION DETAILS COMING SOON',
            style: AppText.bodySmall.copyWith(
              color: AppColors.yslBlack.withOpacity(0.4),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              fontFamily: 'ITC Avant Garde Gothic Pro',
            ),
          ),
          
          Text(
            'Images, videos, exclusive offers, and interactive content will be added here.',
            style: AppText.bodySmall.copyWith(
              color: AppColors.yslBlack.withOpacity(0.4),
              fontSize: 11,
              fontWeight: FontWeight.w300,
              height: 1.4,
              fontFamily: 'ITC Avant Garde Gothic Pro',
            ),
          ),
        ],
      ),
    );
  }
}