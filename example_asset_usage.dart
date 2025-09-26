// Example usage of YSL Beauty Experience Assets
// This file demonstrates how to use all available icons and assets

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ysl_beauty_experience/constants/assets.dart';

class AssetUsageExample extends StatelessWidget {
  const AssetUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YSL Beauty Assets'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // UI Control Icons
            const Text('UI Control Icons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                SvgPicture.asset(Assets.iconPlus, width: 24, height: 24),
                const SizedBox(width: 16),
                SvgPicture.asset(Assets.iconMinus, width: 24, height: 24),
                const SizedBox(width: 16),
                SvgPicture.asset(Assets.iconArrowLeft, width: 24, height: 24),
                const SizedBox(width: 16),
                SvgPicture.asset(Assets.iconArrowRight, width: 24, height: 24),
              ],
            ),
            const SizedBox(height: 24),

            // State Icons
            const Text('State Icons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                SvgPicture.asset(Assets.iconStateOn, width: 24, height: 24),
                const SizedBox(width: 16),
                SvgPicture.asset(Assets.iconStateOff, width: 24, height: 24),
                const SizedBox(width: 16),
                SvgPicture.asset(Assets.iconMap, width: 24, height: 24),
                const SizedBox(width: 16),
                SvgPicture.asset(Assets.iconTop, width: 24, height: 24),
              ],
            ),
            const SizedBox(height: 24),

            // Media & Interaction Icons (INCLUDING THE MISSING ONES YOU MENTIONED!)
            const Text('Media & Interaction Icons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                SvgPicture.asset(Assets.iconSounds, width: 24, height: 24),
                const SizedBox(width: 16),
                SvgPicture.asset(Assets.iconVideo, width: 24, height: 24),
                const SizedBox(width: 16),
                SvgPicture.asset(Assets.iconVolumeOn, width: 24, height: 24),
              ],
            ),
            const SizedBox(height: 24),

            // Pin Option Icons (THE ONES YOU MENTIONED!)
            const Text('Pin Option Icons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                SvgPicture.asset(Assets.iconPinOption1, width: 24, height: 24),
                const SizedBox(width: 16),
                SvgPicture.asset(Assets.iconPinOption2, width: 24, height: 24),
              ],
            ),
            const SizedBox(height: 24),

            // YSL Logo Variants
            const Text('YSL Logo Variants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(Assets.logoYslMonogrammeOn, width: 40, height: 40),
                    const SizedBox(width: 16),
                    SvgPicture.asset(Assets.logoYslMonogrammeOff, width: 40, height: 40),
                    const SizedBox(width: 16),
                    SvgPicture.asset(Assets.logoYslFullOn, width: 40, height: 40),
                    const SizedBox(width: 16),
                    SvgPicture.asset(Assets.logoYslFullOff, width: 40, height: 40),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SvgPicture.asset(Assets.logoYslVersion1, width: 40, height: 40),
                    const SizedBox(width: 16),
                    SvgPicture.asset(Assets.logoYslVersion2, width: 40, height: 40),
                    const SizedBox(width: 16),
                    SvgPicture.asset(Assets.logoYslVersion5, width: 40, height: 40),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Product Images
            const Text('Product Images', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Image.asset(Assets.productLibreParfum, width: 100, height: 100, fit: BoxFit.cover),
            const SizedBox(height: 16),

            // State Images
            const Text('State Images', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Image.asset(Assets.imageStateA, width: 60, height: 60, fit: BoxFit.cover),
                const SizedBox(width: 8),
                Image.asset(Assets.imageStateB, width: 60, height: 60, fit: BoxFit.cover),
                const SizedBox(width: 8),
                Image.asset(Assets.imageStateC, width: 60, height: 60, fit: BoxFit.cover),
                const SizedBox(width: 8),
                Image.asset(Assets.imageStateD, width: 60, height: 60, fit: BoxFit.cover),
              ],
            ),
          ],
        ),
      ),
    );
  }
}