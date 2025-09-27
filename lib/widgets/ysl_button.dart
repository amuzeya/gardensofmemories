// YSL Beauty Experience - YSL Button Component
// Hard-edged rectangles consistent with YSL site/Instagram
// Following YSL brand principles: elegant, minimal, luxury feel

import 'package:flutter/material.dart';
import '../theme/app_text.dart';
import '../theme/app_colors.dart';

/// YSL Button variants following brand guidelines
enum YslButtonVariant {
  primary,   // Black background, white text
  secondary, // White background, black text
  outline,   // Transparent background, white/black border
  light,     // Black background, white text with lighter font weight
}

/// YSL Beauty Experience Button Widget
/// Features:
/// - Hard-edged rectangles (no rounded corners)
/// - YSL brand typography
/// - Elegant hover/press animations
/// - Multiple variants for different contexts
class YslButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final YslButtonVariant variant;
  final double? width;
  final double? height;
  final bool enabled;
  final EdgeInsetsGeometry? padding;

  const YslButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = YslButtonVariant.primary,
    this.width,
    this.height = 48,
    this.enabled = true,
    this.padding,
  });

  @override
  State<YslButton> createState() => _YslButtonState();
}

class _YslButtonState extends State<YslButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.enabled) return;
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.enabled) return;
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _onTapCancel() {
    if (!widget.enabled) return;
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  Color _getBackgroundColor() {
    if (!widget.enabled) {
      return AppColors.grey300;
    }

    switch (widget.variant) {
      case YslButtonVariant.primary:
        return _isPressed ? AppColors.grey800 : AppColors.yslBlack;
      case YslButtonVariant.secondary:
        return _isPressed ? AppColors.grey100 : AppColors.yslWhite;
      case YslButtonVariant.outline:
        return _isPressed 
            ? Colors.white.withValues(alpha: 0.1) 
            : Colors.transparent;
      case YslButtonVariant.light:
        return _isPressed ? AppColors.grey800 : AppColors.yslBlack;
    }
  }

  Color _getTextColor() {
    if (!widget.enabled) {
      return AppColors.grey500;
    }

    switch (widget.variant) {
      case YslButtonVariant.primary:
        return AppColors.yslWhite;
      case YslButtonVariant.secondary:
        return AppColors.yslBlack;
      case YslButtonVariant.outline:
        return AppColors.yslWhite;
      case YslButtonVariant.light:
        return AppColors.yslWhite;
    }
  }

  Color? _getBorderColor() {
    switch (widget.variant) {
      case YslButtonVariant.outline:
        return widget.enabled 
            ? (_isPressed ? AppColors.grey300 : AppColors.yslWhite)
            : AppColors.grey400;
      default:
        return null;
    }
  }

  TextStyle _getButtonTextStyle() {
    switch (widget.variant) {
      case YslButtonVariant.light:
        return AppText.button.copyWith(
          fontWeight: FontWeight.w400, // Lighter font weight
          color: _getTextColor(),
        );
      default:
        return AppText.button.copyWith(
          color: _getTextColor(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.enabled ? widget.onPressed : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.width,
              height: widget.height,
              padding: widget.padding ?? 
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                border: _getBorderColor() != null
                    ? Border.all(
                        color: _getBorderColor()!,
                        width: 2,
                      )
                    : null,
                // Hard-edged rectangles - no border radius
                borderRadius: BorderRadius.zero,
                boxShadow: _isPressed ? null : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: _getButtonTextStyle(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}