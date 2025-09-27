import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_page_screen.dart';
import 'screens/component_library_screen.dart';

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
      title: 'YSL Beauty Brand Experience',
      
      // YSL Beauty themes with forced font family
      theme: AppTheme.lightTheme.copyWith(
        textTheme: AppTheme.lightTheme.textTheme.apply(
          fontFamily: 'ITC Avant Garde Gothic Pro',
        ),
        primaryTextTheme: AppTheme.lightTheme.primaryTextTheme.apply(
          fontFamily: 'ITC Avant Garde Gothic Pro',
        ),
      ),
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Default to light theme per brand guidelines
      
      // Remove debug banner for production-ready appearance
      debugShowCheckedModeBanner: false,
      
      // Routing configuration
      initialRoute: '/components', // Start with component library for development
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/components':
            return MaterialPageRoute(builder: (_) => const ComponentLibraryScreen());
          // case '/':
          //   return MaterialPageRoute(builder: (_) => const SplashScreen());
          // case '/home':
          //   return MaterialPageRoute(builder: (_) => const HomePageScreen());
          default:
            return MaterialPageRoute(builder: (_) => const ComponentLibraryScreen());
        }
      },
      
      // Web-specific configurations for responsive design
      builder: (context, child) {
        return child!;
      },
    );
  }
}

