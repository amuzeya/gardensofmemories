// YSL Beauty Experience - Home Screen
// Main experience screen after splash - blank for now as requested

import 'package:flutter/material.dart';
import '../theme/app_text.dart';
import '../theme/app_colors.dart';

/// YSL Beauty Experience Home Screen
/// This is the main screen users see after entering the experience
/// Currently blank as requested - ready for future content
class ExperienceHomeScreen extends StatelessWidget {
  const ExperienceHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yslWhite,
      appBar: AppBar(
        title: Text(
          'YSL BEAUTY EXPERIENCE',
          style: AppText.navigation.copyWith(
            color: AppColors.yslWhite,
          ),
        ),
        backgroundColor: AppColors.yslBlack,
        foregroundColor: AppColors.yslWhite,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder content
              Text(
                'WELCOME TO THE',
                style: AppText.titleLarge.copyWith(
                  color: AppColors.yslBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'YSL BEAUTY EXPERIENCE',
                style: AppText.heroDisplay.copyWith(
                  color: AppColors.yslBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'Experience content will be added here',
                style: AppText.bodyMedium.copyWith(
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}