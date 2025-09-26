// YSL Beauty Experience - Theme Guide Page
// Visual reference for typography and colors with their code names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Theme guide page - visual reference for all typography and colors
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YSL BEAUTY THEME GUIDE'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Typography Section
            Text('TYPOGRAPHY', style: AppText.titleLarge),
            const SizedBox(height: 24),
            
            _buildTypographyItem(context, 'AppText.heroDisplay', AppText.heroDisplay, 'HERO DISPLAY TEXT'),
            _buildTypographyItem(context, 'AppText.titleLarge', AppText.titleLarge, 'TITLE LARGE'),
            _buildTypographyItem(context, 'AppText.titleMedium', AppText.titleMedium, 'Title Medium'),
            _buildTypographyItem(context, 'AppText.titleSmall', AppText.titleSmall, 'Title Small'),
            _buildTypographyItem(context, 'AppText.bodyLarge', AppText.bodyLarge, 'Body large text for main content'),
            _buildTypographyItem(context, 'AppText.bodyMedium', AppText.bodyMedium, 'Body medium text for secondary content'),
            _buildTypographyItem(context, 'AppText.bodySmall', AppText.bodySmall, 'Body small text for captions'),
            _buildTypographyItem(context, 'AppText.button', AppText.button, 'BUTTON TEXT'),
            _buildTypographyItem(context, 'AppText.productName', AppText.productName, 'Product Name'),
            _buildTypographyItem(context, 'AppText.productPrice', AppText.productPrice, '\$99'),
            _buildTypographyItem(context, 'AppText.navigation', AppText.navigation, 'Navigation'),
            _buildTypographyItem(context, 'AppText.luxuryAccent', AppText.luxuryAccent, 'LUXURY ACCENT'),
            _buildTypographyItem(context, 'AppText.imageOverlay', AppText.imageOverlay, 'IMAGE OVERLAY TEXT'),
            
            const SizedBox(height: 48),
            
            // Colors Section
            Text('COLORS', style: AppText.titleLarge),
            const SizedBox(height: 24),
            
            // Core YSL Brand Colors
            Text('Core YSL Brand Colors', style: AppText.titleMedium),
            const SizedBox(height: 16),
            _buildColorGrid(context, [
              _ColorItem('AppColors.yslBlack', AppColors.yslBlack, '#000000'),
              _ColorItem('AppColors.yslWhite', AppColors.yslWhite, '#FFFFFF'),
              _ColorItem('AppColors.yslGold', AppColors.yslGold, '#C5A46D'),
            ]),
            
            const SizedBox(height: 32),
            
            // Functional Greys
            Text('Functional Greys', style: AppText.titleMedium),
            const SizedBox(height: 16),
            _buildColorGrid(context, [
              _ColorItem('AppColors.grey100', AppColors.grey100, '#F5F5F5'),
              _ColorItem('AppColors.grey200', AppColors.grey200, '#E5E5E5'),
              _ColorItem('AppColors.grey300', AppColors.grey300, '#D4D4D4'),
              _ColorItem('AppColors.grey400', AppColors.grey400, '#A3A3A3'),
              _ColorItem('AppColors.grey500', AppColors.grey500, '#737373'),
              _ColorItem('AppColors.grey600', AppColors.grey600, '#525252'),
              _ColorItem('AppColors.grey700', AppColors.grey700, '#404040'),
              _ColorItem('AppColors.grey800', AppColors.grey800, '#262626'),
              _ColorItem('AppColors.grey900', AppColors.grey900, '#171717'),
            ]),
            
            const SizedBox(height: 32),
            
            // Overlay Colors
            Text('Overlay Colors', style: AppText.titleMedium),
            const SizedBox(height: 16),
            _buildColorGrid(context, [
              _ColorItem('AppColors.overlayBlack', AppColors.overlayBlack, '50% Black'),
              _ColorItem('AppColors.overlayLight', AppColors.overlayLight, '10% Black'),
            ]),
            
            const SizedBox(height: 32),
            
            // System Colors
            Text('System Colors', style: AppText.titleMedium),
            const SizedBox(height: 16),
            _buildColorGrid(context, [
              _ColorItem('AppColors.error', AppColors.error, '#DC2626'),
              _ColorItem('AppColors.success', AppColors.success, '#16A34A'),
              _ColorItem('AppColors.warning', AppColors.warning, '#EA580C'),
              _ColorItem('AppColors.info', AppColors.info, '#2563EB'),
            ]),
            
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTypographyItem(BuildContext context, String codeName, TextStyle style, String sampleText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  codeName,
                  style: AppText.bodySmall.copyWith(
                    fontFamily: 'monospace',
                    color: AppColors.grey600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 16),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: codeName));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Copied: $codeName')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            sampleText,
            style: style,
          ),
          const SizedBox(height: 4),
          Text(
            'Size: ${style.fontSize?.toInt() ?? 'inherit'}px, Weight: ${style.fontWeight?.toString() ?? 'normal'}',
            style: AppText.bodySmall.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }
  
  Widget _buildColorGrid(BuildContext context, List<_ColorItem> colors) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: colors.map((color) => _buildColorItem(context, color)).toList(),
    );
  }
  
  Widget _buildColorItem(BuildContext context, _ColorItem colorItem) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            color: colorItem.color,
            child: colorItem.color == AppColors.yslWhite
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey300),
                    ),
                  )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        colorItem.name,
                        style: AppText.bodySmall.copyWith(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 12),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: colorItem.name));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Copied: ${colorItem.name}')),
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  colorItem.hex,
                  style: AppText.bodySmall.copyWith(color: AppColors.grey600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorItem {
  final String name;
  final Color color;
  final String hex;
  
  _ColorItem(this.name, this.color, this.hex);
}
