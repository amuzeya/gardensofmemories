// YSL Beauty Experience - Map/List Toggle Switch Component
// Based on Figma designs: State=Map/State=List toggle
// Following YSL brand principles: hard-edged rectangles, black/white aesthetic

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Toggle options for the YSL toggle switch
enum YslToggleOption {
  map,
  list,
}

/// YSL Beauty Experience Toggle Switch Widget
/// Features:
/// - Hard-edged rectangle design following YSL guidelines
/// - Map/List toggle functionality
/// - Smooth animations for state changes
/// - YSL brand typography and colors
/// - SVG icon support for map/list icons
class YslToggleSwitch extends StatefulWidget {
  final YslToggleOption selectedOption;
  final ValueChanged<YslToggleOption> onToggle;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;

  const YslToggleSwitch({
    super.key,
    required this.selectedOption,
    required this.onToggle,
    this.width = 175,
    this.height = 45,
    this.margin,
  });

  @override
  State<YslToggleSwitch> createState() => _YslToggleSwitchState();
}

class _YslToggleSwitchState extends State<YslToggleSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: widget.selectedOption == YslToggleOption.map ? 0.0 : 1.0,
      end: widget.selectedOption == YslToggleOption.map ? 0.0 : 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(YslToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedOption != widget.selectedOption) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    _slideAnimation = Tween<double>(
      begin: _slideAnimation.value,
      end: widget.selectedOption == YslToggleOption.map ? 0.0 : 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleToggle(YslToggleOption option) {
    if (option != widget.selectedOption) {
      widget.onToggle(option);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: AppColors.yslWhite,
        border: Border.all(
          color: AppColors.yslBlack,
          width: 1,
        ),
        // Hard-edged rectangles - no border radius per YSL guidelines
        borderRadius: BorderRadius.zero,
      ),
      child: Stack(
        children: [
          // Animated background indicator
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Positioned(
                left: _slideAnimation.value * (widget.width! / 2),
                top: 0,
                child: Container(
                  width: widget.width! / 2,
                  height: widget.height,
                  decoration: const BoxDecoration(
                    color: AppColors.yslBlack,
                    // Hard-edged rectangles
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              );
            },
          ),
          
          // Toggle options
          Row(
            children: [
              // Map option
              Expanded(
                child: GestureDetector(
                  onTap: () => _handleToggle(YslToggleOption.map),
                  child: Container(
                    height: widget.height,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Map icon (Material icon for reliability)
                          Icon(
                            Icons.map_outlined,
                            size: 16,
                            color: widget.selectedOption == YslToggleOption.map
                                ? AppColors.yslWhite
                                : AppColors.yslBlack,
                          ),
                          const SizedBox(width: 6),
                          // Map text
                          Text(
                            'MAP',
                            style: AppText.bodyLarge.copyWith(
                              color: widget.selectedOption == YslToggleOption.map
                                  ? AppColors.yslWhite
                                  : AppColors.yslBlack,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // List option
              Expanded(
                child: GestureDetector(
                  onTap: () => _handleToggle(YslToggleOption.list),
                  child: Container(
                    height: widget.height,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // List icon (Material icon for reliability)
                          Icon(
                            Icons.list,
                            size: 16,
                            color: widget.selectedOption == YslToggleOption.list
                                ? AppColors.yslWhite
                                : AppColors.yslBlack,
                          ),
                          const SizedBox(width: 6),
                          // List text
                          Text(
                            'LIST',
                            style: AppText.bodyLarge.copyWith(
                              color: widget.selectedOption == YslToggleOption.list
                                  ? AppColors.yslWhite
                                  : AppColors.yslBlack,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
