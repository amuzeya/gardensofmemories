// Build-time feature flags for YSL Beauty Experience
// Use with: flutter run/build --dart-define=YSL_DISABLE_LOCKS=true

class FeatureFlags {
  // When true, disables progression locks (all locations and reward are accessible)
  static const bool disableLocks = bool.fromEnvironment(
    'YSL_DISABLE_LOCKS',
    defaultValue: false,
  );
}