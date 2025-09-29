import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'screens/splash_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/entering_experience_screen.dart';
import 'screens/component_library_screen.dart';
import 'screens/data_validation_screen.dart';
import 'screens/home_page.dart' as home;

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

      // YSL Beauty themes with enforced ITC Avant Garde font family
      theme: AppTheme.lightTheme.copyWith(
        textTheme: AppTheme.lightTheme.textTheme.apply(
          fontFamily: 'ITC Avant Garde Gothic Pro',
        ),
        primaryTextTheme: AppTheme.lightTheme.primaryTextTheme.apply(
          fontFamily: 'ITC Avant Garde Gothic Pro',
        ),
        // Ensure all Material Design text styles use ITC Avant Garde
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.yslBlack,
          selectionColor: AppColors.overlayLight,
          selectionHandleColor: AppColors.yslBlack,
        ),
      ),
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      // Default to light theme per brand guidelines

      // Remove debug banner for production-ready appearance
      debugShowCheckedModeBanner: false,

      // Routing configuration - Complete user flow
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/loading':
            return MaterialPageRoute(builder: (_) => const LoadingScreen());
          case '/entering':
            return MaterialPageRoute(builder: (_) => const EnteringExperienceScreen());
          case '/home':
            return MaterialPageRoute(
              builder: (_) => home.HomePageScreen(),
            );
          case '/components':
            return MaterialPageRoute(
              builder: (_) => const ComponentLibraryScreen(),
            );
          case '/dev-data':
            return MaterialPageRoute(
              builder: (_) => const DataValidationScreen(),
            );
          default:
            // Default to splash screen instead of component library
            return MaterialPageRoute(
              builder: (_) => const SplashScreen(),
            );
        }
      },

      // Web-specific configurations for responsive design
      builder: (context, child) {
        return child!;
      },
    );
  }
}
