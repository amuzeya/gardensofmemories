// YSL Beauty Experience - Entering Experience Screen
// Based on Figma design: https://www.figma.com/design/GGfbx70uHOZSdzMgmcmyYq/External---Landng-Owned?node-id=40000180-39399&m=dev
// Following YSL brand principles: realistic photography, hard-edged rectangles, elegant typography

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../widgets/ysl_content_card.dart';
import '../constants/assets.dart';

/// YSL Beauty Experience - Entering Experience Screen
/// Features:
/// - Background image from Figma design
/// - White content card with YSL branding
/// - "YVES THROUGH MARRAKECH" content
/// - "EMBRACE THE JOURNEY" CTA button
/// - Mobile-first responsive design
class EnteringExperienceScreen extends StatefulWidget {
  const EnteringExperienceScreen({super.key});

  @override
  State<EnteringExperienceScreen> createState() => _EnteringExperienceScreenState();
}

class _EnteringExperienceScreenState extends State<EnteringExperienceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    // Start entrance animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  void _onEmbraceJourney() {
    // Navigate to home page with elegant transition
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yslBlack,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          image: DecorationImage(
            // Using the extracted Figma background image
            image: AssetImage(Assets.embrace),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: SvgPicture.asset(
                      Assets.logoYslMonogrammeOn,
                      width: 37.80,
                      height: 92,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),

              // Main content with YSL logo and card
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // White YSL logo positioned above content card
                            SizedBox(height: 10,),
                            // Content card
                            YslContentCard(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 50,
                              ),
                              subtitle: 'MARRAKECH, MOROCCO : \n A VIBRANT HERITAGE',
                              title: 'GARDENS OF MEMORIES, THE SPIRIT OF LIBRE',
                              buttonText: 'LIVE THE LOVE STORY',
                              onButtonPressed: _onEmbraceJourney,
                              description: 'Explore the 4 heritage sites that contributed to the revelation of Yves Saint Laurent\'s palette and senses.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Positioned decorative element (from Figma)
              // This represents the small positioned element in the original design
              Positioned(
                left: 177.50,
                top: 60,
                child: Container(
                  width: 37.80,
                  height: 92,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.zero,
                  ),
                  // This appears to be a decorative element or logo placement
                  // from the original Figma design - keeping structure for future use
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}