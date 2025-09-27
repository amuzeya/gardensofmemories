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
      shadowColor: AppColors.yslBlack.withOpacity(0.1),
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
    return Container(
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

  Widget _buildUpcomingSection() {
    final upcomingComponents = [
      'Location Slider Component',
      'Map View Component',
      'List View Component',
      'Navigation Components',
      'Product Display Cards',
      'Image Gallery Component',
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