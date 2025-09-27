import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_page_screen.dart';

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style for web/mobile consistency
  SystemChrome.setSystemUIOverlayStyle(AppTheme.yslLightOverlay);
  
  runApp(const YSLBeautyApp());
}

/// YSL Beauty Experience - Main Application
class YSLBeautyApp extends StatelessWidget {
  const YSLBeautyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YSL Beauty Experience',
      
      // YSL Beauty themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Default to light theme per brand guidelines
      
      // Remove debug banner for production-ready appearance
      debugShowCheckedModeBanner: false,
      
      // Testing home page component - temporarily bypassing splash
      home: const HomePageScreen(), // const SplashScreen(),
      
      // Web-specific configurations for responsive design
      builder: (context, child) {
        return child!;
      },
    );
  }
}

