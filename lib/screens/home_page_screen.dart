// YSL Beauty Experience - Home Page Screen
// Features map/list toggle with proper content switching
// Following YSL brand principles and mobile-first design

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ysl_toggle_switch.dart';

/// YSL Beauty Experience Home Page Screen
/// Features:
/// - Header with YSL branding
/// - Map/List toggle switch
/// - Dynamic content based on selected view
/// - Mobile-first responsive design
/// - YSL brand guidelines compliance
class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with SingleTickerProviderStateMixin {
  YslToggleOption _selectedView = YslToggleOption.map;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _handleViewToggle(YslToggleOption option) {
    if (option != _selectedView) {
      _fadeController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _selectedView = option;
          });
          _fadeController.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yslWhite,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with toggle switch
          _buildHeader(),
          
          // Dynamic content based on selected view
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _selectedView == YslToggleOption.map 
                  ? _buildMapView() 
                  : _buildListView(),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.yslWhite,
      elevation: 0,
      title: Text(
        'YSL BEAUTY',
        style: AppText.titleMedium.copyWith(
          color: AppColors.yslBlack,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        // Component library navigation
        IconButton(
          icon: const Icon(
            Icons.widgets,
            color: AppColors.yslBlack,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/components');
          },
          tooltip: 'Component Library',
        ),
        IconButton(
          icon: const Icon(
            Icons.more_vert,
            color: AppColors.yslBlack,
          ),
          onPressed: () {
            // Handle menu action
          },
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.yslWhite,
        border: Border(
          bottom: BorderSide(
            color: AppColors.yslBlack,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page title
          Text(
            'YVES THROUGH MARRAKECH',
            style: AppText.titleLarge.copyWith(
              color: AppColors.yslBlack,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          
          // Toggle switch
          Center(
            child: YslToggleSwitch(
              selectedOption: _selectedView,
              onToggle: _handleViewToggle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Map placeholder icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.yslBlack,
                width: 2,
              ),
              borderRadius: BorderRadius.zero, // Hard edges
            ),
            child: const Center(
              child: Icon(
                Icons.map_outlined,
                size: 60,
                color: AppColors.yslBlack,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Map view text
          Text(
            'MAP VIEW',
            style: AppText.titleMedium.copyWith(
              color: AppColors.yslBlack,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          
          Text(
            'Interactive map showing locations\nacross Marrakech for your\nYSL Beauty experience',
            style: AppText.bodyLarge.copyWith(
              color: AppColors.yslBlack,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // List placeholder icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.yslBlack,
                width: 2,
              ),
              borderRadius: BorderRadius.zero, // Hard edges
            ),
            child: const Center(
              child: Icon(
                Icons.list,
                size: 60,
                color: AppColors.yslBlack,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // List view text
          Text(
            'LIST VIEW',
            style: AppText.titleMedium.copyWith(
              color: AppColors.yslBlack,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          
          Text(
            'Curated list of exclusive offers\nand experiences available\nthroughout your journey',
            style: AppText.bodyLarge.copyWith(
              color: AppColors.yslBlack,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}