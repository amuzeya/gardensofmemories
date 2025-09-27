import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';

/// YSL App Bar Component
/// 
/// Premium app bar component with white background, YSL BEAUTÉ logo centered,
/// and customizable action icons. Follows YSL brand guidelines with clean design.
class YslAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? leadingActions;
  final List<Widget>? trailingActions;
  final VoidCallback? onLogoTap;
  final double height;
  final Color backgroundColor;

  const YslAppBar({
    super.key,
    this.leadingActions,
    this.trailingActions,
    this.onLogoTap,
    this.height = 56.0,
    this.backgroundColor = AppColors.yslWhite,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0.5,
      shadowColor: AppColors.yslBlack.withValues(alpha: 0.1),
      automaticallyImplyLeading: false,
      toolbarHeight: height,
      titleSpacing: 0,
      title: SizedBox(
        height: height,
        child: Row(
          children: [
            // Leading actions
            if (leadingActions != null) ...[
              SizedBox(
                width: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: leadingActions!,
                ),
              ),
              const SizedBox(width: 8),
            ] else
              const SizedBox(width: 56),

            // Centered YSL BEAUTÉ logo
            Expanded(
              child: GestureDetector(
                onTap: onLogoTap,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svgs/logos/state_logo_beaut_on.svg',
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.yslBlack,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),

            // Trailing actions
            if (trailingActions != null) ...[
              const SizedBox(width: 8),
              Expanded(
                flex: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: trailingActions!,
                ),
              ),
            ] else
              const SizedBox(width: 56),
          ],
        ),
      ),
    );
  }
}

/// YSL App Bar Action Icon Widget
/// 
/// Standardized icon button for app bar actions
class YslAppBarIcon extends StatelessWidget {
  final String iconPath;
  final VoidCallback? onTap;
  final double size;
  final Color? color;

  const YslAppBarIcon({
    super.key,
    required this.iconPath,
    this.onTap,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: size,
            height: size,
            colorFilter: ColorFilter.mode(
              color ?? AppColors.yslBlack,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

/// Predefined YSL App Bar variants matching Figma designs
class YslAppBarVariants {
  YslAppBarVariants._();

  /// Version 1: Volume control and Close button
  static YslAppBar version1({
    VoidCallback? onVolumeToggle,
    VoidCallback? onClose,
    VoidCallback? onLogoTap,
  }) {
    return YslAppBar(
      leadingActions: [
        YslAppBarIcon(
          iconPath: 'assets/svgs/icons/volumestate=on.svg',
          onTap: onVolumeToggle,
          size: 18,
        ),
      ],
      trailingActions: [
        YslAppBarIcon(
          iconPath: 'assets/svgs/icons/close.svg',
          onTap: onClose,
          size: 16,
        ),
      ],
      onLogoTap: onLogoTap,
    );
  }

  /// Version 2: Menu, Volume, and Share button
  static YslAppBar version2({
    VoidCallback? onMenu,
    VoidCallback? onVolumeToggle,
    VoidCallback? onShare,
    VoidCallback? onLogoTap,
  }) {
    return YslAppBar(
      leadingActions: [
        _buildMenuIcon(onMenu),
      ],
      trailingActions: [
        YslAppBarIcon(
          iconPath: 'assets/svgs/icons/volumestate=on.svg',
          onTap: onVolumeToggle,
          size: 18,
        ),
        const SizedBox(width: 4),
        YslAppBarIcon(
          iconPath: 'assets/svgs/icons/share.svg',
          onTap: onShare,
          size: 16,
        ),
      ],
      onLogoTap: onLogoTap,
    );
  }

  /// Version 3: Custom configuration
  static YslAppBar version3({
    VoidCallback? onBack,
    VoidCallback? onSettings,
    VoidCallback? onLogoTap,
  }) {
    return YslAppBar(
      leadingActions: [
        GestureDetector(
          onTap: onBack,
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.yslBlack,
            size: 20,
          ),
        ),
      ],
      trailingActions: [
        GestureDetector(
          onTap: onSettings,
          child: const Icon(
            Icons.more_vert,
            color: AppColors.yslBlack,
            size: 20,
          ),
        ),
      ],
      onLogoTap: onLogoTap,
    );
  }

  /// Version 4: Map navigation variant
  static YslAppBar version4({
    VoidCallback? onMenu,
    VoidCallback? onMap,
    VoidCallback? onLogoTap,
  }) {
    return YslAppBar(
      leadingActions: [
        _buildMenuIcon(onMenu),
      ],
      trailingActions: [
        YslAppBarIcon(
          iconPath: 'assets/svgs/icons/map.svg',
          onTap: onMap,
          size: 18,
        ),
      ],
      onLogoTap: onLogoTap,
    );
  }

  /// Version 5: Logo only (minimal)
  static YslAppBar version5({
    VoidCallback? onLogoTap,
  }) {
    return YslAppBar(
      onLogoTap: onLogoTap,
    );
  }

  /// Version 6: Menu (SVG) + Volume + Share
  static YslAppBar version6({
    VoidCallback? onMenu,
    VoidCallback? onVolumeToggle,
    VoidCallback? onShare,
    VoidCallback? onLogoTap,
  }) {
    return YslAppBar(
      leadingActions: [
        YslAppBarIcon(
          iconPath: 'assets/svgs/icons/menu.svg',
          onTap: onMenu,
          size: 18,
        ),
      ],
      trailingActions: [
        YslAppBarIcon(
          iconPath: 'assets/svgs/icons/volumestate=on.svg',
          onTap: onVolumeToggle,
          size: 18,
        ),
        const SizedBox(width: 4),
        YslAppBarIcon(
          iconPath: 'assets/svgs/icons/share.svg',
          onTap: onShare,
          size: 16,
        ),
      ],
      onLogoTap: onLogoTap,
    );
  }

  /// Version 7: Sound + Share only
  static YslAppBar version7({
    VoidCallback? onVolumeToggle,
    VoidCallback? onShare,
    VoidCallback? onLogoTap,
  }) {
    return YslAppBar(
      trailingActions: [
        YslAppBarIcon(
          iconPath: 'assets/svgs/icons/volumestate=on.svg',
          onTap: onVolumeToggle,
          size: 18,
        ),
        const SizedBox(width: 4),
        YslAppBarIcon(
          iconPath: 'assets/svgs/icons/share.svg',
          onTap: onShare,
          size: 16,
        ),
      ],
      onLogoTap: onLogoTap,
    );
  }

  // Helper method to build hamburger menu icon
  static Widget _buildMenuIcon(VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 18,
                height: 2,
                color: AppColors.yslBlack,
              ),
              const SizedBox(height: 3),
              Container(
                width: 24,
                height: 2,
                color: AppColors.yslBlack,
              ),
              const SizedBox(height: 3),
              Container(
                width: 15,
                height: 2,
                color: AppColors.yslBlack,
              ),
            ],
          ),
        ),
      ),
    );
  }
}