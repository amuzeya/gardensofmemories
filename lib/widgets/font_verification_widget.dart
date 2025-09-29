// Font Verification Widget - Test ITC Avant Garde Gothic Pro font loading
// This widget helps verify that the font weights are loading correctly

import 'package:flutter/material.dart';
import '../theme/app_text.dart';
import '../theme/app_colors.dart';

class FontVerificationWidget extends StatelessWidget {
  const FontVerificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yslWhite,
      appBar: AppBar(
        title: Text('Font Verification', style: AppText.titleLarge),
        backgroundColor: AppColors.yslBlack,
        foregroundColor: AppColors.yslWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ITC Avant Garde Gothic Pro Weight Tests
            Text(
              'ITC AVANT GARDE GOTHIC PRO FONT WEIGHTS',
              style: AppText.titleLarge.copyWith(color: AppColors.yslBlack),
            ),
            const SizedBox(height: 20),
            
            _buildFontWeightTest('Extra Light (200)', FontWeight.w200),
            _buildFontWeightTest('Book/Light (300)', FontWeight.w300),
            _buildFontWeightTest('Regular (400)', FontWeight.w400),
            _buildFontWeightTest('Medium (500)', FontWeight.w500),
            _buildFontWeightTest('Demi/Semi-Bold (600)', FontWeight.w600),
            _buildFontWeightTest('Bold (700)', FontWeight.w700),
            
            const SizedBox(height: 30),
            
            // AppText Style Tests
            Text(
              'APPTEXT STYLES VERIFICATION',
              style: AppText.titleLarge.copyWith(color: AppColors.yslBlack),
            ),
            const SizedBox(height: 20),
            
            _buildAppTextTest('Brand Display (Arial)', AppText.brandDisplay),
            _buildAppTextTest('Display Subtitle (Arial)', AppText.displaySubtitle),
            _buildAppTextTest('Hero Display', AppText.heroDisplay),
            _buildAppTextTest('Title Large', AppText.titleLarge),
            _buildAppTextTest('Title Medium', AppText.titleMedium),
            _buildAppTextTest('Title Small', AppText.titleSmall),
            _buildAppTextTest('Body Large', AppText.bodyLarge),
            _buildAppTextTest('Body Medium', AppText.bodyMedium),
            _buildAppTextTest('Body Small', AppText.bodySmall),
            _buildAppTextTest('Button Text', AppText.button),
            _buildAppTextTest('Product Name', AppText.productName),
            
            const SizedBox(height: 30),
            
            // Direct Font Family Test
            Text(
              'DIRECT FONT FAMILY TEST',
              style: AppText.titleLarge.copyWith(color: AppColors.yslBlack),
            ),
            const SizedBox(height: 20),
            
            _buildDirectFontTest('ITC Avant Garde Gothic Pro', 'ITC Avant Garde Gothic Pro'),
            _buildDirectFontTest('Arial', 'Arial'),
            
            const SizedBox(height: 30),
            
            // Brand Sample Text
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.yslBlack, width: 2),
                color: AppColors.yslWhite,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YVES SAINT LAURENT',
                    style: AppText.heroDisplay.copyWith(color: AppColors.yslBlack),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'GARDENS OF MEMORIES',
                    style: AppText.titleLarge.copyWith(color: AppColors.yslBlack),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'A luxury beauty experience through the streets of Marrakech, discovering the heritage and essence of YSL Beauty.',
                    style: AppText.bodyMedium.copyWith(color: AppColors.yslBlack),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFontWeightTest(String label, FontWeight weight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: AppText.bodySmall.copyWith(color: AppColors.yslBlack.withOpacity(0.7)),
            ),
          ),
          Expanded(
            child: Text(
              'The quick brown fox jumps over the lazy dog',
              style: TextStyle(
                fontFamily: 'ITC Avant Garde Gothic Pro',
                fontWeight: weight,
                fontSize: 16,
                color: AppColors.yslBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAppTextTest(String label, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: AppText.bodySmall.copyWith(color: AppColors.yslBlack.withOpacity(0.7)),
            ),
          ),
          Expanded(
            child: Text(
              'Sample text with proper styling',
              style: style.copyWith(color: AppColors.yslBlack),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDirectFontTest(String label, String fontFamily) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: AppText.bodySmall.copyWith(color: AppColors.yslBlack.withOpacity(0.7)),
            ),
          ),
          Expanded(
            child: Text(
              'Direct font family test - YVES SAINT LAURENT',
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.yslBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}