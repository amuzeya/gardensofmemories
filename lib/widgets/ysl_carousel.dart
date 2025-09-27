import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// YSL Carousel Item Model
class YslCarouselItem {
  final String? imagePath;
  final String? videoPath;
  final String? introText;
  final String title;
  final String? subtitle;
  final String? paragraph;

  const YslCarouselItem({
    this.imagePath,
    this.videoPath,
    this.introText,
    required this.title,
    this.subtitle,
    this.paragraph,
  }) : assert(imagePath != null || videoPath != null, 
         'Either imagePath or videoPath must be provided');
}

/// YSL Carousel Layout Types
enum YslCarouselLayout {
  standard,
  videoFocused,
}

/// YSL Carousel Component
/// 
/// A premium carousel component that supports images and videos with rich text content.
/// Features YSL brand styling with black/white indicators and smooth transitions.
class YslCarousel extends StatefulWidget {
  final List<YslCarouselItem> items;
  final double height;
  final Duration autoPlayDuration;
  final bool enableAutoPlay;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;
  final bool showIndicators;
  final ValueChanged<int>? onPageChanged;
  final YslCarouselLayout layout;

  const YslCarousel({
    super.key,
    required this.items,
    this.height = 400,
    this.autoPlayDuration = const Duration(seconds: 5),
    this.enableAutoPlay = true,
    this.padding,
    this.backgroundColor = AppColors.yslWhite,
    this.showIndicators = true,
    this.onPageChanged,
    this.layout = YslCarouselLayout.standard,
  });

  @override
  State<YslCarousel> createState() => _YslCarouselState();
}

class _YslCarouselState extends State<YslCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _autoPlayTimer;
  final Map<int, VideoPlayerController> _videoControllers = {};
  bool _isAutoPlayPaused = false;
  final Map<int, bool> _videoStates = {}; // Track video playing state

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeVideoControllers();
    if (widget.enableAutoPlay) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
    _disposeVideoControllers();
    if (_pageController.hasClients) {
      _pageController.dispose();
    }
    super.dispose();
  }

  void _initializeVideoControllers() {
    // On web, avoid creating video controllers to prevent asset fetch and
    // media decode errors for unsupported formats and to keep the render
    // pipeline stable (MouseTracker assertions).
    if (kIsWeb) {
      return;
    }

    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      if (item.videoPath != null) {
        final controller = VideoPlayerController.asset(item.videoPath!);
        _videoControllers[i] = controller;
        _videoStates[i] = false; // Initially not playing
        controller.initialize().then((_) {
          if (i == _currentIndex && mounted) {
            controller.play();
            controller.setLooping(true);
            setState(() {
              _videoStates[i] = true;
            });
          }
        });
      }
    }
  }

  void _disposeVideoControllers() {
    for (final controller in _videoControllers.values) {
      if (controller.value.isInitialized) {
        controller.pause();
      }
      controller.dispose();
    }
    _videoControllers.clear();
    _videoStates.clear();
  }

  void _startAutoPlay() {
    if (_isAutoPlayPaused) return;
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(widget.autoPlayDuration, (timer) {
      if (mounted && !_isAutoPlayPaused) {
        final nextIndex = (_currentIndex + 1) % widget.items.length;
        _animateToPage(nextIndex);
      }
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
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

    // Handle video playback
    _videoControllers.forEach((key, controller) {
      if (key == index) {
        controller.play();
        _videoStates[key] = true;
      } else {
        controller.pause();
        _videoStates[key] = false;
      }
    });

    widget.onPageChanged?.call(index);

    // Restart auto-play timer
    if (widget.enableAutoPlay && !_isAutoPlayPaused) {
      _stopAutoPlay();
      _startAutoPlay();
    }
  }

  void _toggleAutoPlay() {
    if (!mounted) return;
    setState(() {
      _isAutoPlayPaused = !_isAutoPlayPaused;
    });
    
    if (_isAutoPlayPaused) {
      _stopAutoPlay();
    } else if (widget.enableAutoPlay) {
      _startAutoPlay();
    }
  }

  void _toggleVideoPlayback(int index) {
    if (!mounted) return;
    final controller = _videoControllers[index];
    if (controller != null && controller.value.isInitialized) {
      setState(() {
        if (_videoStates[index] == true) {
          controller.pause();
          _videoStates[index] = false;
        } else {
          controller.play();
          _videoStates[index] = true;
        }
      });
    }
  }

  void _goToSlide(int index) {
    _animateToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          // Carousel Content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return _buildCarouselItem(index, widget.items[index]);
              },
            ),
          ),

          // User Controls
          if (widget.items.length > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: _buildUserControls(),
            ),

          // Indicators
          if (widget.showIndicators && widget.items.length > 1)
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildIndicators(),
            ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(int index, YslCarouselItem item) {
    return Container(
      padding: widget.layout == YslCarouselLayout.videoFocused
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 16)
          : (widget.padding ?? const EdgeInsets.all(20)),
      child: widget.layout == YslCarouselLayout.videoFocused
          ? _buildVideoFocusedLayout(index, item)
          : _buildStandardLayout(index, item),
    );
  }

  Widget _buildStandardLayout(int index, YslCarouselItem item) {
    return Column(
      children: [
        // Media Section (Image or Video) - takes most of the space
        Expanded(
          flex: 3,
          child: SizedBox(
            width: double.infinity,
            child: _buildMediaWidget(index, item),
          ),
        ),

        const SizedBox(height: 12),

        // Text Content Section - constrained to remaining space
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: _buildTextContent(item),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoFocusedLayout(int index, YslCarouselItem item) {
    return Column(
      children: [
        // Top Text Section (Intro + Title)
        _buildTopTextContent(item),
        
        const SizedBox(height: 12),
        
        // Wide Video/Media Section
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 0), // Full width
            child: _buildMediaWidget(index, item),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Bottom Text Section (Subtitle + Paragraph)
        _buildBottomTextContent(item),
      ],
    );
  }

  Widget _buildMediaWidget(int index, YslCarouselItem item) {
    if (item.videoPath != null) {
      // On web, inline video can cause render pipeline re-entrancy and pointer assertions.
      // Show a lightweight placeholder instead to keep the carousel stable.
      if (kIsWeb) {
        return Container(
          color: Colors.black12,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.play_circle_outline, color: AppColors.yslBlack, size: 28),
                SizedBox(width: 8),
                Text(
                  'Video (web preview)',
                  style: TextStyle(color: AppColors.yslBlack),
                ),
              ],
            ),
          ),
        );
      }
      final controller = _videoControllers[index];
      if (controller?.value.isInitialized == true) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.zero,
          ),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: controller!.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              ),
              // Video play/pause control (bottom-right corner as per Figma)
              Positioned(
                bottom: 8,
                right: 8,
                child: _buildVideoControls(index),
              ),
            ],
          ),
        );
      } else {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.zero,
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.yslBlack,
            ),
          ),
        );
      }
    } else if (item.imagePath != null) {
      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.zero,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Image.asset(
            item.imagePath!,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.zero,
                ),
                child: const Icon(
                  Icons.image_not_supported,
                  color: AppColors.yslBlack,
                  size: 48,
                ),
              );
            },
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.zero,
      ),
      child: const Icon(
        Icons.error_outline,
        color: AppColors.yslBlack,
        size: 48,
      ),
    );
  }

  Widget _buildTextContent(YslCarouselItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Intro Text
          if (item.introText != null) ...[
            Text(
              item.introText!.toUpperCase(),
              style: AppText.bodySmall.copyWith(
                color: AppColors.yslBlack,
                letterSpacing: 1.0,
                fontFamily: 'ITC Avant Garde Gothic Pro',
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
          ],

          // Title
          Text(
            item.title.toUpperCase(),
            style: AppText.titleLarge.copyWith(
              color: AppColors.yslBlack,
              letterSpacing: 1.0,
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // Subtitle
          if (item.subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              item.subtitle!.toUpperCase(),
              style: AppText.titleMedium.copyWith(
                color: AppColors.yslBlack,
                letterSpacing: 1.0,
                fontFamily: 'ITC Avant Garde Gothic Pro',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Paragraph
          if (item.paragraph != null) ...[
            const SizedBox(height: 6),
            Text(
              item.paragraph!,
              style: AppText.bodyMedium.copyWith(
                color: AppColors.yslBlack,
                height: 1.3,
                fontFamily: 'ITC Avant Garde Gothic Pro',
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTopTextContent(YslCarouselItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Intro Text
        if (item.introText != null) ...[
          Text(
            item.introText!.toUpperCase(),
            style: AppText.bodySmall.copyWith(
              color: AppColors.yslBlack,
              letterSpacing: 1.0,
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
        ],

        // Title
        Text(
          item.title.toUpperCase(),
          style: AppText.titleLarge.copyWith(
            color: AppColors.yslBlack,
            letterSpacing: 1.0,
            fontFamily: 'ITC Avant Garde Gothic Pro',
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildBottomTextContent(YslCarouselItem item) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subtitle
          if (item.subtitle != null) ...[
            Text(
              item.subtitle!.toUpperCase(),
              style: AppText.titleMedium.copyWith(
                color: AppColors.yslBlack,
                letterSpacing: 1.0,
                fontFamily: 'ITC Avant Garde Gothic Pro',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
          ],

          // Paragraph
          if (item.paragraph != null)
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  item.paragraph!,
                  style: AppText.bodyMedium.copyWith(
                    color: AppColors.yslBlack,
                    height: 1.3,
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserControls() {
    return Row(
      children: [
        // Previous slide button
        GestureDetector(
          onTap: () {
            final prevIndex = _currentIndex > 0 
                ? _currentIndex - 1 
                : widget.items.length - 1;
            _goToSlide(prevIndex);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.yslBlack, width: 1),
              borderRadius: BorderRadius.zero,
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.yslBlack,
              size: 16,
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Auto-play toggle
        GestureDetector(
          onTap: _toggleAutoPlay,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isAutoPlayPaused ? AppColors.yslWhite : AppColors.yslBlack,
              border: Border.all(color: AppColors.yslBlack, width: 1),
              borderRadius: BorderRadius.zero,
            ),
            child: Icon(
              _isAutoPlayPaused ? Icons.play_arrow : Icons.pause,
              color: _isAutoPlayPaused ? AppColors.yslBlack : AppColors.yslWhite,
              size: 16,
            ),
          ),
        ),
        
        const Spacer(),
        
        // Slide counter - flexible to prevent overflow
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.yslBlack, width: 1),
              borderRadius: BorderRadius.zero,
            ),
            child: Text(
              '${_currentIndex + 1}/${widget.items.length}',
              style: const TextStyle(
                color: AppColors.yslBlack,
                fontSize: 11,
                fontFamily: 'ITC Avant Garde Gothic Pro',
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Next slide button
        GestureDetector(
          onTap: () {
            final nextIndex = (_currentIndex + 1) % widget.items.length;
            _goToSlide(nextIndex);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.yslBlack, width: 1),
              borderRadius: BorderRadius.zero,
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.yslBlack,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoControls(int index) {
    final isPlaying = _videoStates[index] ?? false;
    return GestureDetector(
      onTap: () => _toggleVideoPlayback(index),
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: AppColors.yslBlack,
          borderRadius: BorderRadius.zero,
        ),
        child: Center(
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: AppColors.yslWhite,
            size: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.items.length,
        (index) => GestureDetector(
          onTap: () => _goToSlide(index),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: index == _currentIndex 
                  ? AppColors.yslBlack 
                  : AppColors.yslBlack.withValues(alpha: 0.3),
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      ),
    );
  }
}

/// Predefined YSL Carousel variants
class YslCarouselVariants {
  YslCarouselVariants._();

  /// Product showcase carousel
  static YslCarousel productShowcase(List<YslCarouselItem> items) {
    return YslCarousel(
      items: items,
      height: 450,
      autoPlayDuration: const Duration(seconds: 4),
      padding: const EdgeInsets.all(20),
    );
  }

  /// Experience carousel
  static YslCarousel experienceShowcase(List<YslCarouselItem> items) {
    return YslCarousel(
      items: items,
      height: 500,
      autoPlayDuration: const Duration(seconds: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    );
  }

  /// Compact carousel
  static YslCarousel compactShowcase(List<YslCarouselItem> items) {
    return YslCarousel(
      items: items,
      height: 320,
      autoPlayDuration: const Duration(seconds: 3),
      padding: const EdgeInsets.all(16),
    );
  }

  /// Video showcase carousel
  static YslCarousel videoShowcase(List<YslCarouselItem> items) {
    return YslCarousel(
      items: items,
      height: 550,
      autoPlayDuration: const Duration(seconds: 8),
      padding: const EdgeInsets.all(20),
      enableAutoPlay: true,
    );
  }

  /// Video-focused carousel with custom layout
  static YslCarousel videoFocused(List<YslCarouselItem> items) {
    return YslCarousel(
      items: items,
      height: 600,
      autoPlayDuration: const Duration(seconds: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enableAutoPlay: true,
      backgroundColor: AppColors.yslWhite,
      layout: YslCarouselLayout.videoFocused,
    );
  }
}
