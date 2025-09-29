# YSL Beauty Experience

A sophisticated Flutter web application that brings the YSL Beauty brand to life through an immersive, gamified experience showcasing Marrakech locations tied to the brand's heritage.

## 🌟 Overview

This project delivers a luxury digital experience that:
- Embodies YSL Beauty's brand aesthetic with pixel-perfect fidelity
- Features an interactive map experience with gamified exploration
- Showcases key locations in Marrakech related to YSL's heritage
- Provides immersive content about products, experiences, and brand story
- Implements sophisticated animations and transitions for a premium feel

## 🎨 Brand Guidelines

This project strictly follows YSL Beauty brand guidelines:

### Visual Identity
- **Colors**: Black and white only; color comes exclusively from images and videos
- **Typography**: YSL's signature ITC Avant Garde Gothic Pro font family
- **Shapes**: Hard-edged rectangles (no rounded corners) - consistent with YSL site/Instagram
- **Imagery**: Realistic photography and video content only
- **Animations**: Intentional, elegant, used to enhance the luxury experience

### Mobile-First Design
- Optimized for mobile devices (375px minimum width)
- Responsive layout that scales elegantly to desktop
- Touch-optimized interactions and gestures
- Performance optimized for smooth 60fps animations

## 🏗️ Architecture

### Project Structure
```
ysl_beauty_experience/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── config/
│   │   └── mapbox_config.dart       # Map configuration
│   ├── constants/
│   │   ├── assets.dart              # Asset paths
│   │   └── svg_assets.dart          # SVG asset paths
│   ├── data/
│   │   └── home_repository.dart     # Data loading/management
│   ├── mappers/
│   │   └── location_mapper.dart     # Data transformations
│   ├── models/                      # Data models
│   │   ├── home_carousel_item.dart
│   │   ├── home_content_card.dart
│   │   ├── home_location.dart
│   │   ├── home_map_config.dart
│   │   ├── home_offer.dart
│   │   ├── home_product.dart
│   │   └── home_quote.dart
│   ├── screens/                     # App screens
│   │   ├── component_library_screen.dart
│   │   ├── data_validation_screen.dart
│   │   ├── entering_experience_screen.dart
│   │   ├── experience_home_screen.dart
│   │   ├── home_page.dart           # Main experience screen
│   │   ├── loading_screen.dart
│   │   └── splash_screen.dart
│   ├── theme/                       # Design system
│   │   ├── app_colors.dart
│   │   ├── app_text.dart
│   │   ├── app_theme.dart
│   │   └── text_theme.dart
│   ├── utils/
│   │   ├── map_animation_utils.dart
│   │   └── responsive_utils.dart
│   └── widgets/                     # Reusable components
│       ├── ysl_app_bar.dart
│       ├── ysl_button.dart
│       ├── ysl_carousel.dart
│       ├── ysl_content_card.dart
│       ├── ysl_exclusive_offer_banner.dart
│       ├── ysl_flight_path_animation.dart
│       ├── ysl_google_map_background.dart
│       ├── ysl_header_v2.dart
│       ├── ysl_home_location_card.dart
│       ├── ysl_location_bottom_sheet.dart
│       ├── ysl_location_card.dart
│       ├── ysl_location_slider.dart
│       ├── ysl_map_background.dart
│       ├── ysl_mapbox_background.dart
│       ├── ysl_offer_card.dart
│       ├── ysl_settings_card.dart
│       └── ysl_toggle_switch.dart
├── assets/
│   ├── fonts/                       # Brand typography
│   │   ├── Arial/
│   │   └── ITC_Avant_Garde_Gothic_Pro/
│   ├── data/                        # JSON data files
│   │   └── home/
│   │       ├── carousel.json
│   │       ├── content.json
│   │       ├── locations.json
│   │       ├── offers.json
│   │       └── products.json
│   ├── images/                      # UI assets
│   ├── svgs/                        # Vector graphics
│   └── [Location folders]/          # Content assets
│       ├── Cafe Le Studio (Activity)/
│       ├── Fragrance (Product Feature)/
│       ├── Jardin Majorelle (Activity)/
│       ├── La Mamounia (Accomodation)/
│       ├── Ourika Gardens (Activity)/
│       └── YSL Museum (Activity)/
└── pubspec.yaml                     # Dependencies
```

## 🚀 Key Features

### 1. Immersive Splash Screen
- Full-screen video background featuring Ourika Gardens
- Elegant fade transitions to main experience
- Brand-aligned typography animations

### 2. Interactive Map Experience
- Google Maps integration with custom YSL styling
- Gamified location exploration with unlock mechanics
- Animated flight paths between locations
- Custom map pins with brand aesthetics
- Two view modes: Map view and List view

### 3. Location Discovery System
- Progressive unlocking of Marrakech locations
- Rich location cards with imagery and details
- Bottom sheet with extended information
- Integration with real location data

### 4. Content Showcase
- Product carousels with smooth animations
- Quote cards featuring brand messaging
- Video content integration
- Exclusive offer banners

### 5. Component Library
- YSL-branded UI components
- Consistent design language
- Reusable widgets following brand guidelines
- Typography showcase demonstrating all text styles

## 🎯 Implemented Screens

### Home Page (`/home`)
- Main experience with interactive map
- Location slider with unlock progression
- Toggle between map and list views
- Animated transitions and micro-interactions

### Component Library (`/components`)
- Showcase of all UI components
- Typography examples
- Color palette demonstration
- Interactive component states

### Data Validation (`/dev-data`)
- Development tool for JSON data validation
- Ensures data integrity across the app

## 🛠️ Technical Implementation

### Dependencies
```yaml
# Core Flutter
flutter:
  sdk: flutter

# UI/UX
cupertino_icons: ^1.0.8
flutter_svg: ^2.0.9
video_player: ^2.8.2
animations: ^2.0.11

# Maps
google_maps_flutter: ^2.5.0
google_maps_flutter_web: ^0.5.4
geolocator: ^12.0.0
```

### Custom Fonts
The project includes authentic YSL brand fonts:
- **ITC Avant Garde Gothic Pro** (multiple weights)
- **Arial** (fallback for specific use cases)

### Animation System
- Sophisticated animation controllers for smooth transitions
- Hero animations for immersive mode switching
- Custom curves and intervals for brand-appropriate motion
- 60fps performance optimization

### Data Management
- JSON-based content system
- Repository pattern for data loading
- Model classes for type safety
- Mapper utilities for data transformation

## 📱 Responsive Design

### Breakpoints
- Mobile: 375px - 767px
- Tablet: 768px - 1023px
- Desktop: 1024px+

### Adaptive Features
- Dynamic layout adjustments
- Touch vs pointer input handling
- Optimized asset loading by screen size
- Responsive typography scaling

## 🎨 Theme System

### Colors
```dart
// Core YSL Brand Colors
AppColors.yslBlack    // #000000
AppColors.yslWhite    // #FFFFFF
AppColors.yslGold     // #C5A46D (luxury accent)

// UI States
AppColors.grey[100-900]  // Neutral palette
AppColors.overlayBlack   // For image overlays
```

### Typography
```dart
// Display
AppText.heroDisplay    // 48px - Splash screens
AppText.titleLarge     // 32px - Section headers
AppText.titleMedium    // 24px - Subsections
AppText.titleSmall     // 18px - Cards

// Body
AppText.bodyLarge      // 16px - Main content
AppText.bodyMedium     // 14px - Secondary
AppText.bodySmall      // 12px - Captions

// Special
AppText.luxuryAccent   // Gold accent text
AppText.imageOverlay   // White text over images
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.9.2)
- Dart SDK (included with Flutter)
- Chrome (for web development)
- VS Code or Android Studio

### Installation
```bash
# Clone the repository
git clone [repository-url]

# Navigate to project
cd ysl_beauty_experience

# Install dependencies
flutter pub get

# Run the app
flutter run -d chrome
```

### Development Commands
```bash
# Run in development
flutter run -d chrome

# Build for production
flutter build web --release

# Run tests
flutter test

# Analyze code
flutter analyze
```

## 🔧 Configuration

### Map Configuration
To use Google Maps, add your API key to `web/index.html`:
```html
<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY"></script>
```

### Asset Management
All assets are organized in the `assets/` directory:
- Place new images in appropriate subdirectories
- Update `pubspec.yaml` with new asset paths
- Use `AssetRes` class for type-safe asset references

## 📝 Development Guidelines

### Code Style
- Follow Flutter style guide
- Use meaningful variable names
- Document complex logic
- Keep widgets focused and reusable

### Git Workflow
- Feature branches from `main`
- Descriptive commit messages
- PR reviews before merging
- Tag releases with semantic versioning

### Performance
- Optimize images (WebP preferred)
- Lazy load heavy assets
- Use const constructors where possible
- Profile regularly with DevTools

## 🎯 Future Enhancements

### Planned Features
- [ ] Augmented Reality product visualization
- [ ] Social sharing capabilities
- [ ] Personalized experience based on preferences
- [ ] Multi-language support
- [ ] Offline mode with cached content

### Technical Improvements
- [ ] State management (Riverpod/Bloc)
- [ ] Automated testing suite
- [ ] CI/CD pipeline
- [ ] Analytics integration
- [ ] Performance monitoring

## 📄 License

This project is proprietary to YSL Beauty. All rights reserved.

---

**Built with ❤️ for YSL Beauty by the Flutter development team**
