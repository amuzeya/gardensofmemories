# YSL Beauty Experience

A Flutter web application that embodies the YSL Beauty brand aesthetic - sophisticated, elegant, and consistent with the YSL Beauty website and Instagram presence.

## Brand Guidelines

This project strictly follows YSL Beauty brand guidelines:

### Visual Identity
- **Colors**: Black and white only; color comes exclusively from images and videos
- **Typography**: Same font family as YSL website, all titles in UPPERCASE
- **Shapes**: Hard-edged rectangles (no rounded corners) - consistent with YSL site/Instagram
- **Imagery**: Realistic photography and graphics only (no illustrations or cartoon styles)
- **Animations**: Intentional, elegant, used sparingly at key UX moments

### Mobile-First Design
- Optimized for mobile devices with minimum 375px width support
- Responsive layout that scales beautifully to larger screens
- Built with Flutter Web for elegant, performant experiences

## Theme System

The app uses a comprehensive theme system that ensures brand consistency:

### Colors (`lib/theme/app_colors.dart`)
```dart
// Core YSL Brand Colors
AppColors.yslBlack    // #000000 - Primary brand color
AppColors.yslWhite    // #FFFFFF - Primary background
AppColors.yslGold     // #C5A46D - Luxury accent (used sparingly)

// Functional greys for UI states
AppColors.grey100 through AppColors.grey900

// System colors (minimal, as per brand)
AppColors.error, AppColors.success, etc.
```

### Typography (`lib/theme/app_text.dart`)
Typography system using Google Fonts (Montserrat) as fallback for YSL brand fonts:

```dart
// Hero Typography
AppText.heroDisplay    // 48px, for splash screens and major brand moments
AppText.titleLarge     // 32px, section headers (ALL CAPS per brand)
AppText.titleMedium    // 24px, subsection headers
AppText.titleSmall     // 18px, card headers

// Body Typography  
AppText.bodyLarge      // 16px, main content
AppText.bodyMedium     // 14px, secondary content
AppText.bodySmall      // 12px, captions and labels

// Special Typography
AppText.productName    // Product card names
AppText.productPrice   // Pricing displays
AppText.luxuryAccent   // Premium highlights (with gold color)
AppText.imageOverlay   // Text over images/videos (white)
```

### Comprehensive Theme (`lib/theme/app_theme.dart`)
Complete Material Design theme configuration:

```dart
AppTheme.lightTheme    // Primary YSL experience (white bg, black text)
AppTheme.darkTheme     // Premium night mode (black bg, white text)
```

Features:
- Hard-edged UI components (no rounded corners)
- High contrast color schemes
- Elegant button styles with proper hover states
- Mobile-optimized touch targets
- System UI overlay configurations for different contexts

## Usage Examples

### Basic Text Styling
```dart
Text('DISCOVER', style: AppText.titleLarge.copyWith(letterSpacing: 2.0))
Text('Product description', style: AppText.bodyLarge)
```

### Color Usage
```dart
Container(
  color: AppColors.yslWhite,
  child: Text('Content', style: TextStyle(color: AppColors.yslBlack)),
)
```

### Buttons
```dart
ElevatedButton(
  onPressed: () {},
  child: Text('SHOP NOW'), // Uses theme automatically
)
```

### Image Overlays
```dart
Stack([
  Image(...),
  Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [Colors.transparent, AppColors.overlayBlack]),
    ),
    child: Text('OVERLAY TEXT', style: AppText.imageOverlay),
  ),
])
```

## Project Structure

```
lib/
├── main.dart              # App entry point with theme configuration
├── theme/                 # Theme system
│   ├── app_colors.dart    # Brand color palette and color schemes
│   ├── app_text.dart      # Typography system with Google Fonts
│   └── app_theme.dart     # Complete Material Design theme
└── pages/                 # App pages and screens
    └── app_root.dart      # Main homepage (temporary showcase)
```

## Development Guidelines

### Adding New Components
1. Use `AppColors` constants for all color values
2. Use `AppText` styles for all typography
3. Ensure hard-edged shapes (BorderRadius.zero) per brand guidelines
4. Test on mobile breakpoints (375px minimum width)

### Typography Guidelines
- All section headers should be UPPERCASE per brand identity
- Use appropriate letter spacing for luxury feel
- Prefer `AppText.luxuryAccent` for premium product highlights
- Use `AppText.imageOverlay` for text over media content

### Color Usage Rules
- **Primary content**: Use only black and white
- **Accent touches**: Use gold sparingly for premium elements
- **Images/videos**: Only source of color in the experience
- **Interactive states**: Use greys for disabled/hover states

### Testing
```bash
flutter analyze    # Must pass with no issues
flutter test      # All tests must pass  
flutter build web # Must build successfully
```

## Assets and Resources

### Fonts
- Primary: ITC Avant Garde Gothic Pro (YSL brand font)
- Fallback: Google Fonts Montserrat (loaded automatically)

### Future Asset Integration
The theme system is prepared for:
- Custom YSL brand fonts (when available)
- Product images and videos
- Brand iconography and graphics

## Figma Integration

This project includes theme extraction from Figma design systems:
- Colors extracted from YSL style guides
- Typography based on YSL brand specifications
- Component structures aligned with Figma component library

---

**Note**: This is a mobile-first project designed for the web. The theme system ensures the experience feels like a seamless extension of YSL Beauty's existing ecommerce and social presence.
