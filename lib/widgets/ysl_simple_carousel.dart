// YSL Simple Carousel - Clean Image-Only Carousel
// Large images with simple arrow navigation and dot indicators
// Based on complex carousel design but simplified for images only

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';

/// Simple YSL Carousel Item Model - Images only
class YslSimpleCarouselItem {
  final String imagePath;
  final bool isNetworkImage;

  const YslSimpleCarouselItem({
    required this.imagePath,
    this.isNetworkImage = false,
  });
}

/// YSL Simple Carousel Component
/// 
/// A minimal carousel showing large full-size images with navigation arrows
/// and dot indicators. Follows the same design patterns as the complex carousel
/// but simplified for image-only display.
class YslSimpleCarousel extends StatefulWidget {
  final List<YslSimpleCarouselItem> items;
  final double height;
  final ValueChanged<int>? onPageChanged;

  const YslSimpleCarousel({
    super.key,
    required this.items,
    this.height = 280,
    this.onPageChanged,
  });

  @override
  State<YslSimpleCarousel> createState() => _YslSimpleCarouselState();
}

class _YslSimpleCarouselState extends State<YslSimpleCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _animateToPage(_currentIndex - 1);
    }
  }

  void _goToNext() {
    if (_currentIndex < widget.items.length - 1) {
      _animateToPage(_currentIndex + 1);
    }
  }

  void _animateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    if (!mounted) return;
    setState(() {
      _currentIndex = index;
    });
    widget.onPageChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return SizedBox(height: widget.height);
    }

    return Container(
      height: widget.height,
      decoration: const BoxDecoration(
        color: AppColors.yslWhite,
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          // Main image carousel with arrows
          Expanded(
            child: Stack(
              children: [
                // Image PageView
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    return _buildCarouselImage(widget.items[index]);
                  },
                ),
                
                // Left arrow - same style as complex carousel
                if (_currentIndex > 0)
                  Positioned(
                    left: 20,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _buildArrowButton(
                        isLeft: true,
                        onTap: _goToPrevious,
                      ),
                    ),
                  ),
                
                // Right arrow - same style as complex carousel
                if (_currentIndex < widget.items.length - 1)
                  Positioned(
                    right: 20,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _buildArrowButton(
                        isLeft: false,
                        onTap: _goToNext,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Dot indicators - same style as complex carousel
          if (widget.items.length > 1)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: _buildDotIndicators(),
            ),
        ],
      ),
    );
  }

  /// Build individual carousel image - full size, clean
  Widget _buildCarouselImage(YslSimpleCarouselItem item) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.zero,
      ),
      child: ClipRect(
        child: item.isNetworkImage
            ? Image.network(
                item.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorPlaceholder();
                },
              )
            : Image.asset(
                item.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return _buildErrorPlaceholder();
                },
              ),
      ),
    );
  }

  /// Build navigation arrow buttons - same style as complex carousel
  Widget _buildArrowButton({
    required bool isLeft,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.yslBlack, width: 1),
          borderRadius: BorderRadius.zero,
          color: AppColors.yslWhite,
        ),
        child: SvgPicture.asset(
          isLeft 
              ? 'assets/svgs/icons/small_arrow_left.svg'
              : 'assets/svgs/icons/small-arrow.svg',
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(
            AppColors.yslBlack,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  /// Build bar indicators - horizontal lines as shown in screenshot
  Widget _buildDotIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.items.length,
        (index) => GestureDetector(
          onTap: () => _animateToPage(index),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: index == _currentIndex ? 40 : 20, // Longer for active
            height: 3,
            decoration: BoxDecoration(
              color: index == _currentIndex 
                  ? AppColors.yslBlack 
                  : AppColors.yslBlack.withOpacity(0.3),
              borderRadius: BorderRadius.zero, // Sharp rectangles
            ),
          ),
        ),
      ),
    );
  }

  /// Error placeholder for failed image loads
  Widget _buildErrorPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          color: AppColors.yslBlack,
          size: 48,
        ),
      ),
    );
  }
}