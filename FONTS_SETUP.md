# YSL Beauty Experience - Font Setup Guide

## 🎯 Required Fonts (From Figma Analysis)

Based on the Figma design analysis, you need these exact fonts:

### **Primary Font: ITC Avant Garde Gothic Pro**
- Used in: 90% of the app (Style Guide, Tests UI/UX, Components)
- Weights needed:
  - **Light (300)** - For subtitles and body text
  - **Regular (400)** - For standard text
  - **Medium (500)** - For emphasized text
  - **SemiBold (600)** - For product names and buttons
  - **Bold (700)** - For headers and titles

### **Display Font: Arial**
- Used in: Brief section for large display text
- Weights needed:
  - **Regular (400)** - For 24px subtitles
  - **Bold (700)** - For 72px brand display text

## 📁 Font File Structure

Place your font files in this structure:

```
assets/fonts/
├── ITC_Avant_Garde_Gothic_Pro/
│   ├── ITCAvantGardeGothicPro-Light.ttf
│   ├── ITCAvantGardeGothicPro-Regular.ttf
│   ├── ITCAvantGardeGothicPro-Medium.ttf
│   ├── ITCAvantGardeGothicPro-SemiBold.ttf
│   └── ITCAvantGardeGothicPro-Bold.ttf
└── Arial/
    ├── Arial-Regular.ttf
    └── Arial-Bold.ttf
```

## 🔍 How to Get These Fonts

### **Option 1: From Your Figma Design**
1. Open your Figma design
2. Go to the Style Guide section
3. Select a text element using ITC Avant Garde Gothic Pro
4. In the right panel, look for font download options
5. If available, download the font files

### **Option 2: From Font Foundries**
- **ITC Avant Garde Gothic Pro**: Purchase from Monotype, Adobe Fonts, or other licensed font providers
- **Arial**: Usually comes with Windows/macOS system fonts, or download from Google Fonts

### **Option 3: License Check**
- Check if your organization already has licenses for these fonts
- Ask your design team if they have the font files
- Check Adobe Creative Cloud if you have access

### **Option 4: System Fonts (Temporary)**
- Arial is usually available on most systems
- For ITC Avant Garde Gothic Pro, we'll use the current fallback system

## ⚠️ Font Licensing

**Important**: Ensure you have proper licensing for commercial use of these fonts:
- ITC Avant Garde Gothic Pro requires a commercial license
- Arial is generally free for most uses
- Always check font licensing before deploying to production

## 🚀 Once You Have the Font Files

1. Place them in `assets/fonts/` following the structure above
2. The `pubspec.yaml` is already configured for these fonts
3. Run `flutter pub get`
4. Restart your app - fonts will automatically load

## 🎨 Current Status

- ✅ **Font names and sizes**: Extracted from Figma (pixel perfect)
- ✅ **Typography hierarchy**: Matches your designs exactly
- ✅ **Font fallbacks**: Working system in place
- ⏳ **Actual font files**: Waiting for you to add them
- ✅ **App configuration**: Ready to use real fonts when available

## 🔧 Testing Font Installation

After adding font files, you can test them by running:

```bash
flutter run --debug
```

Look for any font loading warnings in the debug output.