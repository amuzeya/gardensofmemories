import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// YSL Exclusive Offer Banner Component
/// 
/// A banner component that can expand to show detailed offer information
/// Features YSL brand styling with accordion functionality
class YslExclusiveOfferBanner extends StatefulWidget {
  final String text;
  final String? subText;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isCloseable;
  final VoidCallback? onClose;
  final bool canExpand;
  final Widget? expandedContent;

  const YslExclusiveOfferBanner({
    super.key,
    required this.text,
    this.subText,
    this.onTap,
    this.icon,
    this.isCloseable = false,
    this.onClose,
    this.canExpand = false,
    this.expandedContent,
  });

  @override
  State<YslExclusiveOfferBanner> createState() => _YslExclusiveOfferBannerState();
}

class _YslExclusiveOfferBannerState extends State<YslExclusiveOfferBanner>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;
  OverlayEntry? _overlayEntry;
  final GlobalKey _bannerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (_isExpanded) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    
    final RenderBox? renderBox = _bannerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy + size.height,
        left: position.dx,
        right: MediaQuery.of(context).size.width - position.dx - size.width,
        child: Material(
          color: Colors.transparent,
          child: AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return Transform.scale(
                scaleY: _expandAnimation.value,
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.yslBlack,
                    borderRadius: BorderRadius.zero,
                  ),
                  child: widget.expandedContent ?? const SizedBox.shrink(),
                ),
              );
            },
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
  }
  
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _bannerKey,
      onTap: widget.canExpand ? _toggleExpansion : widget.onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.yslBlack,
          borderRadius: BorderRadius.zero,
        ),
        child: Row(
          children: [
            // Main text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.text.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'ITC Avant Garde Gothic Pro',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.40,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.subText != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.subText!.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontFamily: 'ITC Avant Garde Gothic Pro',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            // Right side icon with rotation animation if expandable
            if (widget.canExpand) ...[
              const SizedBox(width: 12),
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14159,
                    child: const Icon(
                      Icons.add,
                      color: AppColors.yslWhite,
                      size: 16,
                    ),
                  );
                },
              ),
            ] else if (widget.icon != null) ...[
              const SizedBox(width: 12),
              Icon(
                widget.icon!,
                color: AppColors.yslWhite,
                size: 16,
              ),
            ],
            
            // Close button (if closeable)
            if (widget.isCloseable) ...[
              const SizedBox(width: 12),
              GestureDetector(
                onTap: widget.onClose,
                child: const Icon(
                  Icons.close,
                  color: AppColors.yslWhite,
                  size: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Predefined YSL Exclusive Offer Banner variants
class YslExclusiveOfferBannerVariants {
  YslExclusiveOfferBannerVariants._();
  
  /// Free shipping offer banner
  static YslExclusiveOfferBanner freeShipping({
    VoidCallback? onTap,
    bool isCloseable = false,
    VoidCallback? onClose,
  }) {
    return YslExclusiveOfferBanner(
      text: 'FREE SHIPPING ON ALL ORDERS',
      subText: 'No minimum purchase required',
      icon: Icons.local_shipping_outlined,
      onTap: onTap,
      isCloseable: isCloseable,
      onClose: onClose,
    );
  }
  
  /// Limited time offer banner
  static YslExclusiveOfferBanner limitedOffer({
    required String offerText,
    String? timeText,
    VoidCallback? onTap,
    bool isCloseable = false,
    VoidCallback? onClose,
  }) {
    return YslExclusiveOfferBanner(
      text: offerText,
      subText: timeText ?? 'Limited time only',
      icon: Icons.access_time_outlined,
      onTap: onTap,
      isCloseable: isCloseable,
      onClose: onClose,
    );
  }
  
  /// Exclusive access banner
  static YslExclusiveOfferBanner exclusiveAccess({
    String? experienceText,
    VoidCallback? onTap,
    bool isCloseable = false,
    VoidCallback? onClose,
  }) {
    return YslExclusiveOfferBanner(
      text: experienceText ?? 'EXCLUSIVE ACCESS AVAILABLE',
      subText: 'Members only experience',
      icon: Icons.star_outline,
      onTap: onTap,
      isCloseable: isCloseable,
      onClose: onClose,
    );
  }
  
  /// New arrival announcement banner
  static YslExclusiveOfferBanner newArrival({
    String? productText,
    VoidCallback? onTap,
    bool isCloseable = false,
    VoidCallback? onClose,
  }) {
    return YslExclusiveOfferBanner(
      text: productText ?? 'NEW ARRIVALS NOW AVAILABLE',
      subText: 'Discover the latest collection',
      icon: Icons.fiber_new_outlined,
      onTap: onTap,
      isCloseable: isCloseable,
      onClose: onClose,
    );
  }
  
  /// Figma-exact offer banner with expandable content
  static YslExclusiveOfferBanner figmaOffer({
    required String offerText,
    VoidCallback? onTap,
    bool isCloseable = false,
    VoidCallback? onClose,
  }) {
    return YslExclusiveOfferBanner(
      text: offerText,
      canExpand: true,
      isCloseable: isCloseable,
      onClose: onClose,
      expandedContent: _buildExpandedOfferContent(),
    );
  }
  
  /// Build the expanded content for the figma offer
  static Widget _buildExpandedOfferContent() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Blurred background image with lock icon
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('assets/images/exclusive_offer/main_banner.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withOpacity(0.5),
              ),
              child: const Center(
                child: Icon(
                  Icons.lock,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Main headline
          const Text(
            'COMPLETE THE JOURNEY,\nUNLOCK YOUR REWARD!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: AppText.fontFamily,
              fontWeight: FontWeight.w700,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // How it works section
          const Text(
            'HOW IT WORKS?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontWeight: FontWeight.w300,
              letterSpacing: 0.90,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Step 01
          _buildStep(
            'STEP 01',
            'Explore 4 must-see Yves Saint Laurent spots around Marrakech and enjoy an interactive urban adventure.',
          ),
          
          const SizedBox(height: 30),
          
          // Step 02
          _buildStep(
            'STEP 02',
            'At each stop, discover the location and move one step closer to your reward.',
          ),
          
          const SizedBox(height: 30),
          
          // Step 03
          _buildStep(
            'STEP 03',
            'Once completed, your reward will be revealed automatically.',
          ),
          
          const SizedBox(height: 32),
          
          // YSL logo
          SvgPicture.asset(
            'assets/svgs/logos/state_logo_beaut_on.svg',
            height: 24,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Gardens of memories
          const Text(
            'GARDENS OF MEMORIES',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontWeight: FontWeight.w300,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build individual step content
  static Widget _buildStep(String stepTitle, String stepDescription) {
    return Column(
      children: [
        Text(
          stepTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'ITC Avant Garde Gothic Pro',
            fontWeight: FontWeight.w500,
            letterSpacing: 0.48,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          stepDescription,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'ITC Avant Garde Gothic Pro',
            fontWeight: FontWeight.w300,
            height: 1.33,
          ),
        ),
      ],
    );
  }
}
