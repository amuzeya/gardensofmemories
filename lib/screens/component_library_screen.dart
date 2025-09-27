// YSL Beauty Experience - Component Library Screen
// Visual showcase of all built components for testing and review
// Following YSL brand principles and mobile-first design

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ysl_toggle_switch.dart';
import '../widgets/ysl_button.dart';
import '../widgets/ysl_content_card.dart';
import '../widgets/ysl_offer_card.dart';
import '../widgets/ysl_exclusive_offer_banner.dart';
import '../widgets/ysl_app_bar.dart';
import '../widgets/ysl_header_v2.dart';
import '../widgets/ysl_carousel.dart';
import '../widgets/ysl_settings_card.dart';
import '../widgets/ysl_location_card.dart';
import '../widgets/ysl_location_slider.dart';

/// YSL Beauty Experience Component Library Screen
/// Features:
/// - Visual showcase of all built components
/// - Interactive testing environment
/// - YSL brand guidelines compliance
/// - Mobile-first responsive grid layout
/// - Component documentation and examples
class ComponentLibraryScreen extends StatefulWidget {
  const ComponentLibraryScreen({super.key});

  @override
  State<ComponentLibraryScreen> createState() => _ComponentLibraryScreenState();
}

class _ComponentLibraryScreenState extends State<ComponentLibraryScreen> {
  YslToggleOption _toggleValue = YslToggleOption.map;
  YslToggleOption _settingsToggleValue = YslToggleOption.map;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yslWhite,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 40),
            
            // Components Grid
            _buildComponentsGrid(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.yslWhite,
      elevation: 1,
      shadowColor: AppColors.yslBlack.withValues(alpha: 0.1),
      title: Text(
        'YSL COMPONENT LIBRARY',
        style: AppText.titleMedium.copyWith(
          color: AppColors.yslBlack,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
          fontFamily: 'ITC Avant Garde Gothic Pro',
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.yslBlack,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.yslBlack,
          width: 2,
        ),
        borderRadius: BorderRadius.zero, // Hard edges per YSL guidelines
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YSL BEAUTY EXPERIENCE',
            style: AppText.titleLarge.copyWith(
              color: AppColors.yslBlack,
              letterSpacing: 1.5,
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'COMPONENT SHOWCASE',
            style: AppText.bodyLarge.copyWith(
              color: AppColors.yslBlack,
              letterSpacing: 1.0,
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 2,
            width: 80,
            color: AppColors.yslBlack,
          ),
          const SizedBox(height: 16),
          Text(
            'Interactive library showcasing all YSL Beauty Experience components.\nBuilt with Flutter following YSL brand guidelines.',
            style: AppText.bodyMedium.copyWith(
              color: AppColors.yslBlack,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Font Family: ITC Avant Garde Gothic Pro (bundled)',
            style: TextStyle(
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Font Test: Light(300) Regular(400) Medium(500) SemiBold(600) Bold(700)',
            style: TextStyle(
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontSize: 9,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Text(
          'COMPONENTS',
          style: AppText.titleLarge.copyWith(
            color: AppColors.yslBlack,
            letterSpacing: 1.2,
            fontFamily: 'ITC Avant Garde Gothic Pro',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),
        
        // Component Cards
        _buildComponentCard(
          title: 'MAP/LIST TOGGLE SWITCH',
          status: 'READY',
          description: 'Interactive toggle switch for switching between map and list views. Features smooth sliding animation and YSL brand styling.',
          component: _buildToggleSwitchDemo(),
          figmaLinks: [
            'State=Map: node-id=40000153-15250',
            'State=List: node-id=40000153-15311',
          ],
        ),
        
        const SizedBox(height: 32),
        
        _buildComponentCard(
          title: 'YSL BUTTON VARIANTS',
          status: 'READY',
          description: 'Multiple button variants including primary, secondary, outline, and light variations. All following YSL hard-edge design principles.',
          component: _buildButtonDemo(),
          figmaLinks: [
            'Button Component: node-id=40000161-13082',
          ],
        ),
        
        const SizedBox(height: 32),
        
        _buildComponentCard(
          title: 'YSL CONTENT CARD',
          status: 'READY',
          description: 'Reusable white content card with YSL branding, typography, and hard-edged rectangles for consistent brand experience.',
          component: _buildContentCardDemo(),
          figmaLinks: [
            'Content Card: Based on entering experience design',
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Typography Showcase
        _buildTypographyCard(),
        
        const SizedBox(height: 32),
        
        // Offer Card Component
        _buildOfferCardComponent(),
        
        const SizedBox(height: 32),
        
        // Exclusive Offer Banner Component
        _buildOfferBannerComponent(),
        
        const SizedBox(height: 32),
        
        // App Bar Component
        _buildAppBarComponent(),
        
        const SizedBox(height: 32),
        
        // Header V2 Component
        _buildHeaderV2Component(),
        
        const SizedBox(height: 32),
        
        // Carousel Component
        _buildCarouselComponent(),
        
        const SizedBox(height: 32),
        
        // Settings Card Component
        _buildSettingsCardComponent(),
        
        const SizedBox(height: 32),
        
        // Location Card Component
        _buildLocationCardComponent(),
        
        const SizedBox(height: 32),
        
        // Location Slider Component
        _buildLocationSliderComponent(),
        
        const SizedBox(height: 32),
        
        // Upcoming Components
        _buildUpcomingSection(),
      ],
    );
  }

  Widget _buildComponentCard({
    required String title,
    required String status,
    required String description,
    required Widget component,
    required List<String> figmaLinks,
  }) {
    final isReady = status == 'READY';
    final statusColor = isReady ? AppColors.yslBlack : Colors.grey;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.yslBlack,
          width: 1,
        ),
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: isReady ? AppColors.yslBlack : Colors.grey.shade300,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppText.titleMedium.copyWith(
                          color: isReady ? AppColors.yslWhite : Colors.grey.shade700,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.zero,
                        ),
                        child: Text(
                          status,
                          style: AppText.bodySmall.copyWith(
                            color: AppColors.yslWhite,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  description,
                  style: AppText.bodyLarge.copyWith(
                    color: AppColors.yslBlack,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Figma Links
                if (figmaLinks.isNotEmpty) ...[
                  Text(
                    'FIGMA REFERENCE:',
                    style: AppText.bodyMedium.copyWith(
                      color: AppColors.yslBlack,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...figmaLinks.map((link) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $link',
                      style: AppText.bodySmall.copyWith(
                        color: AppColors.yslBlack,
                        height: 1.3,
                      ),
                    ),
                  )),
                  const SizedBox(height: 20),
                ],
                
                // Component Demo
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: component,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSwitchDemo() {
    return Column(
      children: [
        YslToggleSwitch(
          selectedOption: _toggleValue,
          onToggle: (value) {
            setState(() {
              _toggleValue = value;
            });
          },
        ),
        const SizedBox(height: 12),
        Text(
          'Selected: ${_toggleValue.name.toUpperCase()}',
          style: AppText.bodyMedium.copyWith(
            color: AppColors.yslBlack,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonDemo() {
    return Column(
      children: [
        // Primary Button
        YslButton(
          text: 'PRIMARY BUTTON',
          onPressed: () {},
          variant: YslButtonVariant.primary,
        ),
        const SizedBox(height: 12),
        
        // Light Button
        YslButton(
          text: 'LIGHT VARIANT',
          onPressed: () {},
          variant: YslButtonVariant.light,
        ),
        const SizedBox(height: 12),
        
        // Secondary Button
        YslButton(
          text: 'SECONDARY BUTTON',
          onPressed: () {},
          variant: YslButtonVariant.secondary,
        ),
        const SizedBox(height: 12),
        
        // Outline Button
        YslButton(
          text: 'OUTLINE BUTTON',
          onPressed: () {},
          variant: YslButtonVariant.outline,
        ),
      ],
    );
  }

  Widget _buildContentCardDemo() {
    return YslContentCard(
      subtitle: 'COMPONENT DEMO',
      title: 'YSL CONTENT CARD EXAMPLE',
      buttonText: 'DEMO BUTTON',
      onButtonPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Content card button pressed!'),
            backgroundColor: AppColors.yslBlack,
          ),
        );
      },
      padding: const EdgeInsets.all(20),
    );
  }

  Widget _buildTypographyCard() {
    return _buildComponentCard(
      title: 'YSL TYPOGRAPHY SYSTEM',
      status: 'READY',
      description: 'Complete typography system using ITC Avant Garde Gothic Pro font extracted from Figma style guide. All styles follow YSL brand guidelines with proper weights and spacing.',
      component: _buildTypographyDemo(),
      figmaLinks: [
        'Style Guide: node-id=40000152-10044',
        'Typography extracted from Figma design system',
      ],
    );
  }

  Widget _buildTypographyDemo() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand Display Typography
          _buildTypographySection(
            title: 'BRAND DISPLAY',
            styles: [
              _buildTypographyExample(
                'H1 - BRAND DISPLAY',
                'YVES SAINT LAURENT BEAUTY',
                AppText.brandDisplay,
              ),
              _buildTypographyExample(
                'DISPLAY SUBTITLE',
                'Luxury Beauty Experience',
                AppText.displaySubtitle,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Headings & Titles
          _buildTypographySection(
            title: 'HEADINGS & TITLES',
            styles: [
              _buildTypographyExample(
                'H2 - HERO DISPLAY',
                'GARDENS OF MEMORIES',
                AppText.heroDisplay,
              ),
              _buildTypographyExample(
                'H3 - SECTION HEADER',
                'MARRAKECH EXPERIENCE',
                AppText.sectionHeader,
              ),
              _buildTypographyExample(
                'H4 - TITLE LARGE',
                'YVES THROUGH MARRAKECH',
                AppText.titleLarge,
              ),
              _buildTypographyExample(
                'H5 - TITLE MEDIUM',
                'Exclusive Collections',
                AppText.titleMedium,
              ),
              _buildTypographyExample(
                'H6 - TITLE SMALL',
                'Product Categories',
                AppText.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Product & UI Typography
          _buildTypographySection(
            title: 'PRODUCT & UI',
            styles: [
              _buildTypographyExample(
                'PRODUCT NAME',
                'LIBRE EAU DE PARFUM',
                AppText.productName,
              ),
              _buildTypographyExample(
                'PRODUCT PRICE',
                '€89.00',
                AppText.productPrice,
              ),
              _buildTypographyExample(
                'BUTTON TEXT',
                'EMBRACE THE JOURNEY',
                AppText.button,
              ),
              _buildTypographyExample(
                'NAVIGATION',
                'Component Library',
                AppText.navigation,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Body Text
          _buildTypographySection(
            title: 'BODY TEXT',
            styles: [
              _buildTypographyExample(
                'BODY LARGE',
                'Interactive library showcasing all YSL Beauty Experience components.',
                AppText.bodyLarge,
              ),
              _buildTypographyExample(
                'BODY MEDIUM',
                'Built with Flutter following YSL brand guidelines and design principles.',
                AppText.bodyMedium,
              ),
              _buildTypographyExample(
                'BODY SMALL',
                'Typography system extracted from Figma design specifications.',
                AppText.bodySmall,
              ),
              _buildTypographyExample(
                'UI DESCRIPTION',
                'Detailed component documentation and usage examples.',
                AppText.uiDescription,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Special Typography
          _buildTypographySection(
            title: 'SPECIAL STYLES',
            styles: [
              _buildTypographyExample(
                'LUXURY ACCENT',
                'PREMIUM COLLECTION',
                AppText.luxuryAccent,
              ),
              _buildTypographyExample(
                'IMAGE OVERLAY',
                'DISCOVER MORE',
                AppText.imageOverlay,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypographySection({required String title, required List<Widget> styles}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: const BoxDecoration(
            color: AppColors.yslBlack,
            borderRadius: BorderRadius.zero,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.yslWhite,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...styles,
      ],
    );
  }

  Widget _buildTypographyExample(String label, String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'ITC Avant Garde Gothic Pro',
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          
          // Typography example
          Text(
            text,
            style: style.copyWith(
              fontFamily: 'ITC Avant Garde Gothic Pro',
              color: AppColors.yslBlack,
            ),
          ),
          
          // Style info
          const SizedBox(height: 4),
          Text(
            'Size: ${style.fontSize?.toInt() ?? 'inherit'}px • Weight: ${_getFontWeightName(style.fontWeight ?? FontWeight.normal)} • Family: ITC Avant Garde Gothic Pro',
            style: const TextStyle(
              fontSize: 8,
              color: Colors.grey,
              fontFamily: 'ITC Avant Garde Gothic Pro',
            ),
          ),
        ],
      ),
    );
  }

  String _getFontWeightName(FontWeight weight) {
    switch (weight) {
      case FontWeight.w300:
        return 'Light';
      case FontWeight.w400:
        return 'Regular';
      case FontWeight.w500:
        return 'Medium';
      case FontWeight.w600:
        return 'SemiBold';
      case FontWeight.w700:
        return 'Bold';
      default:
        return 'Regular';
    }
  }

  Widget _buildOfferCardComponent() {
    return _buildComponentCard(
      title: 'YSL EXCLUSIVE OFFER CARD',
      status: 'READY',
      description: 'Premium offer card component with YSL brand styling, exclusive badges, hover animations, and integrated call-to-action buttons. Includes predefined variants for different use cases.',
      component: _buildOfferCardDemo(),
      figmaLinks: [
        'Offer Component: node-id=40000161-13082',
        'Offer Card: node-id=40000153-15230',
      ],
    );
  }

  Widget _buildOfferCardDemo() {
    return Column(
      children: [
        // Product Offer Card
        YslOfferCardVariants.productOffer(
          productName: 'LIBRE EAU DE PARFUM',
          offerText: '20% OFF + FREE SHIPPING',
          description: 'Experience the iconic YSL fragrance that captures the spirit of freedom and rebellion.',
          onShopNow: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Shop Now clicked - Product Offer'),
                backgroundColor: AppColors.yslBlack,
              ),
            );
          },
        ),
        
        const SizedBox(height: 20),
        
        // Experience Offer Card
        YslOfferCardVariants.experienceOffer(
          title: 'MARRAKECH GARDENS',
          experienceText: 'Discover the exclusive YSL Beauty experience through the enchanted gardens of Marrakech. Limited access available.',
          subtitle: 'EXCLUSIVE ACCESS',
          onExplore: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Explore clicked - Experience Offer'),
                backgroundColor: AppColors.yslBlack,
              ),
            );
          },
        ),
        
        const SizedBox(height: 20),
        
        // Compact Offer Card
        YslOfferCardVariants.compactOffer(
          title: 'BEAUTY INSIDER REWARDS',
          offerText: 'TRIPLE POINTS',
          buttonText: 'JOIN NOW',
          onAction: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Join Now clicked - Compact Offer'),
                backgroundColor: AppColors.yslBlack,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildOfferBannerComponent() {
    return _buildComponentCard(
      title: 'YSL EXCLUSIVE OFFER BANNER',
      status: 'READY',
      description: 'Top banner component for exclusive offers and announcements. Features YSL black background with white text, right-side icons, and optional close functionality. Designed to appear above app bars.',
      component: _buildOfferBannerDemo(),
      figmaLinks: [
        'Offer Banner: node-id=40000161-13082',
      ],
    );
  }

  Widget _buildOfferBannerDemo() {
    return Column(
      children: [
        // Free Shipping Banner
        YslExclusiveOfferBannerVariants.freeShipping(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Free shipping banner tapped!'),
                backgroundColor: AppColors.yslBlack,
              ),
            );
          },
          isCloseable: true,
          onClose: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Banner closed'),
                backgroundColor: AppColors.yslBlack,
              ),
            );
          },
        ),
        
        const SizedBox(height: 12),
        
        // Limited Time Offer Banner
        YslExclusiveOfferBannerVariants.limitedOffer(
          offerText: '50% OFF SELECTED FRAGRANCES',
          timeText: 'Ends midnight tonight',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Limited offer banner tapped!'),
                backgroundColor: AppColors.yslBlack,
              ),
            );
          },
        ),
        
        const SizedBox(height: 12),
        
        // Exclusive Access Banner
        YslExclusiveOfferBannerVariants.exclusiveAccess(
          experienceText: 'MEMBER PREVIEW: MARRAKECH COLLECTION',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Exclusive access banner tapped!'),
                backgroundColor: AppColors.yslBlack,
              ),
            );
          },
        ),
        
        const SizedBox(height: 12),
        
        // New Arrival Banner
        YslExclusiveOfferBannerVariants.newArrival(
          productText: 'NEW: LIBRE LE PARFUM AVAILABLE NOW',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('New arrival banner tapped!'),
                backgroundColor: AppColors.yslBlack,
              ),
            );
          },
        ),
        
        const SizedBox(height: 12),
        
        // Figma-exact Offer Banner (plus icon, no subtext)
        YslExclusiveOfferBannerVariants.figmaOffer(
          offerText: 'EXCLUSIVE OFFER AVAILABLE',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Figma offer banner tapped!'),
                backgroundColor: AppColors.yslBlack,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAppBarComponent() {
    return _buildComponentCard(
      title: 'YSL APP BAR VARIANTS',
      status: 'READY',
      description: 'Premium app bar component with YSL BEAUTÉ logo and customizable action icons. Features white background, centered logo, and 7 predefined variants including Figma designs and additional configurations.',
      component: _buildAppBarDemo(),
      figmaLinks: [
        'Header Component: node-id=40000152-9744',
        'Original 5 Figma variants + 2 additional variants',
        'Versions 6 & 7 use menu.svg and optimized icon combinations',
      ],
    );
  }

  Widget _buildAppBarDemo() {
    return Column(
      children: [
        // App Bar Demo Container
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            children: [
              // Version 1: Volume + Close
              Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VERSION 1: VOLUME + CLOSE',
                      style: TextStyle(
                        fontFamily: 'ITC Avant Garde Gothic Pro',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: YslAppBarVariants.version1(
                        onVolumeToggle: () => _showSnackBar('Volume toggled - Version 1'),
                        onClose: () => _showSnackBar('Close pressed - Version 1'),
                        onLogoTap: () => _showSnackBar('YSL logo tapped - Version 1'),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Version 2: Menu + Volume + Share
              Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VERSION 2: MENU + VOLUME + SHARE',
                      style: TextStyle(
                        fontFamily: 'ITC Avant Garde Gothic Pro',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: YslAppBarVariants.version2(
                        onMenu: () => _showSnackBar('Menu opened - Version 2'),
                        onVolumeToggle: () => _showSnackBar('Volume toggled - Version 2'),
                        onShare: () => _showSnackBar('Share pressed - Version 2'),
                        onLogoTap: () => _showSnackBar('YSL logo tapped - Version 2'),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Version 3: Back + Settings
              Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VERSION 3: BACK + SETTINGS',
                      style: TextStyle(
                        fontFamily: 'ITC Avant Garde Gothic Pro',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: YslAppBarVariants.version3(
                        onBack: () => _showSnackBar('Back pressed - Version 3'),
                        onSettings: () => _showSnackBar('Settings opened - Version 3'),
                        onLogoTap: () => _showSnackBar('YSL logo tapped - Version 3'),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Version 4: Menu + Map
              Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VERSION 4: MENU + MAP',
                      style: TextStyle(
                        fontFamily: 'ITC Avant Garde Gothic Pro',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: YslAppBarVariants.version4(
                        onMenu: () => _showSnackBar('Menu opened - Version 4'),
                        onMap: () => _showSnackBar('Map opened - Version 4'),
                        onLogoTap: () => _showSnackBar('YSL logo tapped - Version 4'),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Version 5: Logo only
              Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VERSION 5: LOGO ONLY (MINIMAL)',
                      style: TextStyle(
                        fontFamily: 'ITC Avant Garde Gothic Pro',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: YslAppBarVariants.version5(
                        onLogoTap: () => _showSnackBar('YSL logo tapped - Version 5'),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Version 6: Menu (SVG) + Volume + Share
              Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VERSION 6: MENU (SVG) + VOLUME + SHARE',
                      style: TextStyle(
                        fontFamily: 'ITC Avant Garde Gothic Pro',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: YslAppBarVariants.version6(
                        onMenu: () => _showSnackBar('Menu opened - Version 6'),
                        onVolumeToggle: () => _showSnackBar('Volume toggled - Version 6'),
                        onShare: () => _showSnackBar('Share pressed - Version 6'),
                        onLogoTap: () => _showSnackBar('YSL logo tapped - Version 6'),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Version 7: Sound + Share only
              Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VERSION 7: SOUND + SHARE ONLY',
                      style: TextStyle(
                        fontFamily: 'ITC Avant Garde Gothic Pro',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: YslAppBarVariants.version7(
                        onVolumeToggle: () => _showSnackBar('Volume toggled - Version 7'),
                        onShare: () => _showSnackBar('Share pressed - Version 7'),
                        onLogoTap: () => _showSnackBar('YSL logo tapped - Version 7'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.yslBlack,
      ),
    );
  }

  Widget _buildHeaderV2Component() {
    return _buildComponentCard(
      title: 'YSL HEADER V2',
      status: 'READY',
      description: 'Vertical header component with YSL BEAUTÉ logo on top and customizable title below. Perfect for screen headers and content sections. Features 5 predefined variants.',
      component: _buildHeaderV2Demo(),
      figmaLinks: [
        'Header-V2 Component: node-id=40000311-21716',
        'Gardens of Memories variant included',
      ],
    );
  }

  Widget _buildHeaderV2Demo() {
    return Column(
      children: [
        // Gardens of Memories (Figma exact)
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'GARDENS OF MEMORIES (FIGMA EXACT)',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslHeaderV2Variants.gardensOfMemories(),
            ],
          ),
        ),

        // Experience Header
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'EXPERIENCE HEADER',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslHeaderV2Variants.experienceHeader(
                title: 'MARRAKECH COLLECTION',
              ),
            ],
          ),
        ),

        // Hero Header
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'HERO HEADER',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslHeaderV2Variants.heroHeader(
                title: 'LIBRE COLLECTION',
              ),
            ],
          ),
        ),

        // Product Header
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'PRODUCT HEADER',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslHeaderV2Variants.productHeader(
                productName: 'LIBRE EAU DE PARFUM',
              ),
            ],
          ),
        ),

        // Compact Header
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'COMPACT HEADER',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslHeaderV2Variants.compactHeader(
                title: 'BEAUTY ESSENTIALS',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselComponent() {
    return _buildComponentCard(
      title: 'YSL CAROUSEL',
      status: 'READY',
      description: 'Premium carousel component supporting images and videos with rich text content. Features YSL black/white indicators, auto-play, smooth transitions, and 3 predefined variants.',
      component: _buildCarouselDemo(),
      figmaLinks: [
        'Carousel Component: node-id=40000155-11205',
        'Slider Indicators: node-id=40000152-9853',
      ],
    );
  }

  Widget _buildCarouselDemo() {
    final sampleItems = [
      const YslCarouselItem(
        imagePath: 'assets/images/embrace.png',
        introText: 'DISCOVER',
        title: 'GARDENS OF MEMORIES',
        subtitle: 'MARRAKECH COLLECTION',
        paragraph: 'Experience the enchanting beauty of Marrakech through our exclusive fragrance collection inspired by the iconic Majorelle Gardens.',
      ),
      const YslCarouselItem(
        imagePath: 'assets/images/components_product.png',
        introText: 'EXPLORE',
        title: 'LIBRE EAU DE PARFUM',
        subtitle: 'FREEDOM IN A BOTTLE',
        paragraph: 'The scent of freedom. A statement of personal liberation and the tension between the burning of ginger and the softness of lavender.',
      ),
      const YslCarouselItem(
        imagePath: 'assets/images/frame_845083978.png',
        introText: 'LUXURY',
        title: 'YSL BEAUTY ESSENTIALS',
        subtitle: 'PREMIUM COLLECTION',
        paragraph: 'Discover our curated selection of luxury beauty products that define the YSL aesthetic and embody French elegance.',
      ),
    ];

    return Column(
      children: [
        // Product Showcase Variant
        Container(
          margin: const EdgeInsets.only(bottom: 32),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'PRODUCT SHOWCASE CAROUSEL',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslCarouselVariants.productShowcase(sampleItems),
            ],
          ),
        ),

        // Experience Showcase Variant
        Container(
          margin: const EdgeInsets.only(bottom: 32),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'EXPERIENCE SHOWCASE CAROUSEL',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslCarouselVariants.experienceShowcase(sampleItems),
            ],
          ),
        ),

        // Compact Showcase Variant
        Container(
          margin: const EdgeInsets.only(bottom: 32),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'COMPACT SHOWCASE CAROUSEL',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslCarouselVariants.compactShowcase(sampleItems),
            ],
          ),
        ),

        // Video Showcase Variant
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'VIDEO SHOWCASE CAROUSEL',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              _buildVideoCarouselDemo(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCarouselDemo() {
    final videoSampleItems = [
      const YslCarouselItem(
        videoPath: 'assets/splash_screen_ourika.mp4',
        introText: 'IMMERSIVE',
        title: 'OURIKA VALLEY',
        subtitle: 'CINEMATIC EXPERIENCE',
        paragraph: 'Journey through the stunning landscapes of the Ourika Valley, where YSL Beauty finds inspiration in the natural beauty of Morocco.',
      ),
      const YslCarouselItem(
        imagePath: 'assets/images/embrace.png',
        introText: 'DISCOVER',
        title: 'GARDENS OF MEMORIES',
        subtitle: 'MARRAKECH COLLECTION',
        paragraph: 'From video to image - experience the versatility of our carousel component with mixed media content.',
      ),
      const YslCarouselItem(
        imagePath: 'assets/images/components_product.png',
        introText: 'LUXURY',
        title: 'PREMIUM FRAGRANCES',
        subtitle: 'CRAFTED EXCELLENCE',
        paragraph: 'Discover the art of perfumery through our exclusive collection of luxury fragrances, each telling a unique story.',
      ),
    ];

    return YslCarouselVariants.videoFocused(videoSampleItems);
  }

  Widget _buildSettingsCardComponent() {
    return _buildComponentCard(
      title: 'YSL SETTINGS CARD',
      status: 'READY',
      description: 'Settings card component with integrated YSL toggle switch. Features clean typography, flexible content layout, and YSL brand styling. Includes multiple predefined variants for common use cases.',
      component: _buildSettingsCardDemo(),
      figmaLinks: [
        'Settings Card: node-id=40000153-15230',
        'Toggle Integration: Reuses existing toggle component',
      ],
    );
  }

  Widget _buildSettingsCardDemo() {
    return Column(
      children: [
        // Figma Exact Variant
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'FIGMA EXACT - LOCATION SERVICES',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslSettingsCardVariants.figmaExact(
                selectedOption: _settingsToggleValue,
                onToggleChanged: (value) {
                  setState(() {
                    _settingsToggleValue = value;
                  });
                },
              ),
            ],
          ),
        ),

        // Map Preferences Variant
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'MAP PREFERENCES VARIANT',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslSettingsCardVariants.mapPreferences(
                selectedOption: _settingsToggleValue,
                onToggleChanged: (value) {
                  setState(() {
                    _settingsToggleValue = value;
                  });
                },
              ),
            ],
          ),
        ),

        // Full Width Variant
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'FULL WIDTH VARIANT',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslSettingsCardVariants.fullWidth(
                title: 'Display Preferences',
                description: 'Choose your preferred method for viewing YSL Beauty content and experiences.',
                toggleLabel: 'View Mode',
                selectedOption: _settingsToggleValue,
                onToggleChanged: (value) {
                  setState(() {
                    _settingsToggleValue = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCardComponent() {
    return _buildComponentCard(
      title: 'YSL LOCATION CARD',
      status: 'READY',
      description: 'Location display card component featuring store/boutique information with images. Includes SVG pin variations (pin_a.svg, pin_b.svg, pin_c.svg), distance indicators, status badges, and YSL brand styling. Perfect for store locators and location-based features.',
      component: _buildLocationCardDemo(),
      figmaLinks: [
        'Location Card: node-id=40000153-17589',
        'Image Asset: Automatically exported from Figma',
      ],
    );
  }

  Widget _buildLocationCardDemo() {
    return Column(
      children: [
        // Figma Exact Variant
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'FIGMA EXACT - PIN A VARIATION',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslLocationCardVariants.figmaExact(
                pinVariation: PinVariation.pinA,
                onTap: () => _showSnackBar('Location card tapped: YSL Beauty Store - Pin A'),
              ),
            ],
          ),
        ),

        // Store Variant
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'STORE VARIANT - PIN A',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslLocationCardVariants.store(
                name: 'YSL Beauty Marrakech',
                address: 'Experience the ultimate luxury beauty destination with exclusive YSL collections and expert beauty consultations.',
                city: 'Marrakech',
                distance: '1.2 km',
                isOpen: true,
                pinVariation: PinVariation.pinA,
                onTap: () => _showSnackBar('Location tapped: YSL Beauty Marrakech - Pin A'),
              ),
            ],
          ),
        ),

        // Boutique Variant
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'BOUTIQUE VARIANT - PIN B',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslLocationCardVariants.boutique(
                name: 'YSL Libre Experience',
                address: 'Immerse yourself in the world of YSL Libre with personalized fragrance consultations and exclusive limited editions.',
                city: 'Paris',
                distance: '0.8 km',
                isOpen: true,
                pinVariation: PinVariation.pinB,
                onTap: () => _showSnackBar('Boutique tapped: YSL Libre Experience - Pin B'),
              ),
            ],
          ),
        ),

        // Experience Variant
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'EXPERIENCE VARIANT - PIN C',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslLocationCardVariants.experience(
                name: 'Gardens of Memories Pop-up',
                address: 'Step into the enchanting world of YSL Beauty inspired by the iconic Marrakech gardens and discover limited edition collections.',
                city: 'Marrakech',
                distance: '2.1 km',
                isOpen: false,
                pinVariation: PinVariation.pinC,
                onTap: () => _showSnackBar('Experience tapped: Gardens of Memories - Pin C'),
              ),
            ],
          ),
        ),

        // Compact Variant
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'COMPACT VARIANT - PIN B',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslLocationCardVariants.compact(
                name: 'YSL Mini Store',
                address: 'Explore YSL Beauty essentials and bestsellers in our convenient mini store location.',
                distance: '3.5 km',
                isOpen: true,
                pinVariation: PinVariation.pinB,
                onTap: () => _showSnackBar('Compact location tapped: YSL Mini Store - Pin B'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSliderComponent() {
    return _buildComponentCard(
      title: 'YSL LOCATION SLIDER',
      status: 'READY',
      description: 'Horizontal location slider with manual navigation controls. Features multiple location cards with different pin variations (pin_a.svg, pin_b.svg, pin_c.svg), smooth scrolling animations, and YSL brand styling. Includes borderless variants for minimal, clean layouts. Perfect for browsing multiple locations.',
      component: _buildLocationSliderDemo(),
      figmaLinks: [
        'Location Slider: node-id=40000153-12569',
        'Manual navigation with arrow controls',
        'Uses existing location card components',
      ],
    );
  }

  Widget _buildLocationSliderDemo() {
    return Column(
      children: [
        // Figma Exact Variant
        Container(
          margin: const EdgeInsets.only(bottom: 32),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'FIGMA EXACT - 5 LOCATIONS WITH PIN VARIATIONS',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslLocationSliderVariants.figmaExact(
                onLocationTap: () => _showSnackBar('Location slider item tapped - Figma Exact'),
              ),
            ],
          ),
        ),

        // Standard Variant
        Container(
          margin: const EdgeInsets.only(bottom: 32),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'STANDARD - 3 DISTINCT LOCATIONS (PIN A, B, C)',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslLocationSliderVariants.standard(
                onLocationTap: () => _showSnackBar('Location slider item tapped - Standard'),
              ),
            ],
          ),
        ),

        // Compact Variant
        Container(
          margin: const EdgeInsets.only(bottom: 32),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'COMPACT VARIANT - SMALLER CARDS',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslLocationSliderVariants.compact(
                onLocationTap: () => _showSnackBar('Location slider item tapped - Compact'),
              ),
            ],
          ),
        ),

        // Premium Variant
        Container(
          margin: const EdgeInsets.only(bottom: 32),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'PREMIUM VARIANT - LUXURY LOCATIONS',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslLocationSliderVariants.premium(
                onLocationTap: () => _showSnackBar('Location slider item tapped - Premium'),
              ),
            ],
          ),
        ),

        // Borderless Variant
        Container(
          margin: const EdgeInsets.only(bottom: 32),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'BORDERLESS VARIANT - NO CARD BORDERS',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslLocationSliderVariants.borderless(
                onLocationTap: () => _showSnackBar('Location slider item tapped - Borderless'),
              ),
            ],
          ),
        ),

        // Borderless Compact Variant
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'BORDERLESS COMPACT - CLEAN & MINIMAL',
                  style: TextStyle(
                    fontFamily: 'ITC Avant Garde Gothic Pro',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              YslLocationSliderVariants.borderlessCompact(
                onLocationTap: () => _showSnackBar('Location slider item tapped - Borderless Compact'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingSection() {
    final upcomingComponents = [
      'Map View Component',
      'List View Component', 
      'Navigation Components',
      'Product Display Cards',
      'Image Gallery Component',
      'Location Search & Filter',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          width: 1,
        ),
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'UPCOMING COMPONENTS',
            style: AppText.titleMedium.copyWith(
              color: Colors.grey.shade700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          ...upcomingComponents.map((component) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  component,
                  style: AppText.bodyMedium.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}