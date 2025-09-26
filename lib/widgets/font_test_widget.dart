// YSL Beauty Experience - Font Testing Widget
// Use this to verify that your bundled fonts are loading correctly

import 'package:flutter/material.dart';
import '../theme/app_text.dart';
import '../theme/app_colors.dart';

/// Widget to test and verify font loading
/// Shows all typography styles to ensure fonts are working correctly
class FontTestWidget extends StatelessWidget {
  const FontTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yslWhite,
      appBar: AppBar(
        title: const Text('YSL Typography Test'),
        backgroundColor: AppColors.yslBlack,
        foregroundColor: AppColors.yslWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Font Status
            _buildSection(
              'Font Status',
              [
                _buildFontInfo('Primary Font', AppText.primaryFontFamily),
                _buildFontInfo('Display Font', AppText.displayFontFamily),
              ],
            ),
            
            // Arial Display Typography (Brief Section)
            _buildSection(
              'Arial Display Typography (Brief Section)',
              [
                _buildTextExample('Brand Display (72px Bold)', 
                  'YSL BEAUTÉ', AppText.brandDisplay),
                _buildTextExample('Display Subtitle (24px Regular)', 
                  'Brand World Experience', AppText.displaySubtitle),
              ],
            ),

            // ITC Avant Garde Gothic Pro Typography (Style Guide)
            _buildSection(
              'ITC Avant Garde Gothic Pro (Style Guide)',
              [
                _buildTextExample('Hero Display (32px Bold)', 
                  'BEAUTY REDEFINED', AppText.heroDisplay),
                _buildTextExample('Title Large (22px Bold)', 
                  'ICONIC FRAGRANCES', AppText.titleLarge),
                _buildTextExample('Title Medium (19px Light)', 
                  'Discover our collection', AppText.titleMedium),
                _buildTextExample('Title Small (18px Light)', 
                  'Premium skincare', AppText.titleSmall),
                _buildTextExample('Product Name (14px SemiBold)', 
                  'LIBRE EAU DE PARFUM', AppText.productName),
                _buildTextExample('Body Large (12px Medium)', 
                  'Experience the daring spirit of YSL with our signature collection of luxury beauty products.', 
                  AppText.bodyLarge),
                _buildTextExample('Body Medium (12px Light)', 
                  'From iconic lipsticks to revolutionary skincare, discover what makes YSL beauty legendary.', 
                  AppText.bodyMedium),
                _buildTextExample('Body Small (12px Light)', 
                  'Available in select boutiques worldwide', AppText.bodySmall),
              ],
            ),

            // UI Components
            _buildSection(
              'UI Components',
              [
                _buildTextExample('Button (14px SemiBold)', 
                  'SHOP NOW', AppText.button),
                _buildTextExample('Navigation (14px Medium)', 
                  'FRAGRANCES', AppText.navigation),
                _buildTextExample('Luxury Accent (12px Light)', 
                  'EXCLUSIVE', AppText.luxuryAccent),
                _buildTextExample('Image Overlay (16px SemiBold)', 
                  'DISCOVER MORE', AppText.imageOverlay),
              ],
            ),

            // Font Loading Test
            _buildSection(
              'Font Loading Test',
              [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Font Loading Status:',
                        style: AppText.titleMedium.copyWith(color: AppColors.yslBlack),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• If you see sharp, distinctive letterforms: FONTS LOADED ✅',
                        style: AppText.bodyLarge,
                      ),
                      Text(
                        '• If text looks generic/system: FONTS NOT LOADED ❌',
                        style: AppText.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add the real font files to assets/fonts/ as described in FONTS_SETUP.md',
                        style: AppText.bodySmall.copyWith(color: AppColors.grey600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          title,
          style: AppText.sectionHeader.copyWith(color: AppColors.yslBlack),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildFontInfo(String label, String fontFamily) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: AppText.bodyLarge),
          Text(
            fontFamily, 
            style: AppText.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.yslGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextExample(String label, String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppText.bodySmall.copyWith(
              color: AppColors.grey600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(text, style: style),
        ],
      ),
    );
  }
}