/// Application-wide constants for the Pictogram web application.
///
/// This file contains all the core configuration values used throughout
/// the application including limits, dimensions, and timing values.
library;

/// Core application constants.
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ============================================================================
  // Application Information
  // ============================================================================

  /// The name of the application.
  static const String appName = 'Pictogram';

  /// The current version of the application.
  static const String appVersion = '1.0.0';

  /// Application description.
  static const String appDescription =
      'Web-based image viewer and editor with advanced features';

  // ============================================================================
  // File Handling
  // ============================================================================

  /// Maximum file size allowed for image uploads (50 MB in bytes).
  ///
  /// This limit is set for web performance considerations. Files larger
  /// than this will be rejected during the upload process.
  static const int maxFileSizeBytes = 50 * 1024 * 1024; // 50 MB

  /// Maximum file size in human-readable format.
  static const String maxFileSizeDisplay = '50 MB';

  /// Maximum number of files that can be loaded simultaneously.
  static const int maxSimultaneousFiles = 100;

  // ============================================================================
  // Thumbnail Configuration
  // ============================================================================

  /// Default width for thumbnail images.
  static const int thumbnailWidth = 140;

  /// Default height for thumbnail images.
  static const int thumbnailHeight = 120;

  /// Quality for thumbnail generation (0-100).
  static const int thumbnailQuality = 85;

  // ============================================================================
  // Gallery Layout
  // ============================================================================

  /// Number of columns in gallery view for desktop displays.
  static const int galleryColumnsDesktop = 8;

  /// Number of columns in gallery view for tablet displays.
  static const int galleryColumnsTablet = 4;

  /// Number of columns in gallery view for mobile displays.
  static const int galleryColumnsMobile = 2;

  /// Spacing between gallery items in pixels.
  static const double gallerySpacing = 8.0;

  /// Padding around gallery grid in pixels.
  static const double galleryPadding = 16.0;

  // ============================================================================
  // Responsive Breakpoints
  // ============================================================================

  /// Breakpoint for mobile devices (max width in pixels).
  static const double mobileBreakpoint = 600.0;

  /// Breakpoint for tablet devices (max width in pixels).
  static const double tabletBreakpoint = 1024.0;

  /// Breakpoint for desktop devices (min width in pixels).
  static const double desktopBreakpoint = 1025.0;

  // ============================================================================
  // Recent Files
  // ============================================================================

  /// Maximum number of recent files to track and display.
  static const int maxRecentFiles = 5;

  /// Storage key for recent files in local storage.
  static const String recentFilesStorageKey = 'pictogram_recent_files';

  // ============================================================================
  // Zoom Configuration
  // ============================================================================

  /// Default zoom level (100%).
  static const double defaultZoomLevel = 1.0;

  /// Minimum zoom level (10%).
  static const double minZoomLevel = 0.1;

  /// Maximum zoom level (500%).
  static const double maxZoomLevel = 5.0;

  /// Zoom step for increment/decrement operations.
  static const double zoomStep = 0.1;

  /// Zoom step for mouse wheel operations.
  static const double zoomStepWheel = 0.05;

  /// Predefined zoom levels for quick access.
  static const List<double> presetZoomLevels = [
    0.25, // 25%
    0.5, // 50%
    0.75, // 75%
    1.0, // 100%
    1.5, // 150%
    2.0, // 200%
    3.0, // 300%
    4.0, // 400%
  ];

  // ============================================================================
  // Image Rotation
  // ============================================================================

  /// Rotation angle in degrees for rotate operations.
  static const double rotationAngleDegrees = 90.0;

  // ============================================================================
  // Animation Durations
  // ============================================================================

  /// Default animation duration for UI transitions.
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  /// Fast animation duration for quick transitions.
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);

  /// Slow animation duration for emphasized transitions.
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  /// Duration for image loading fade-in effect.
  static const Duration imageLoadFadeDuration = Duration(milliseconds: 200);

  /// Duration for dialog animations.
  static const Duration dialogAnimationDuration = Duration(milliseconds: 250);

  /// Duration for tooltip appearance.
  static const Duration tooltipDuration = Duration(milliseconds: 500);

  /// Duration for snackbar display.
  static const Duration snackbarDuration = Duration(seconds: 3);

  // ============================================================================
  // UI Configuration
  // ============================================================================

  /// Default border radius for UI elements.
  static const double defaultBorderRadius = 8.0;

  /// Border radius for cards.
  static const double cardBorderRadius = 12.0;

  /// Border radius for buttons.
  static const double buttonBorderRadius = 6.0;

  /// Default elevation for cards.
  static const double defaultElevation = 2.0;

  /// Elevation for dialogs.
  static const double dialogElevation = 8.0;

  /// Default icon size.
  static const double defaultIconSize = 24.0;

  /// Large icon size.
  static const double largeIconSize = 32.0;

  /// Small icon size.
  static const double smallIconSize = 16.0;

  // ============================================================================
  // Storage Keys
  // ============================================================================

  /// Storage key for user preferences.
  static const String preferencesStorageKey = 'pictogram_preferences';

  /// Storage key for theme mode.
  static const String themeModeStorageKey = 'pictogram_theme_mode';

  /// Storage key for last used zoom level.
  static const String lastZoomStorageKey = 'pictogram_last_zoom';

  // ============================================================================
  // Image Processing
  // ============================================================================

  /// Default quality for JPEG compression (0-100).
  static const int defaultJpegQuality = 90;

  /// Default quality for PNG compression (0-100).
  static const int defaultPngQuality = 100;

  /// Default quality for WEBP compression (0-100).
  static const int defaultWebpQuality = 85;

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /// Gets the number of gallery columns based on screen width.
  ///
  /// Example:
  /// ```dart
  /// final columns = AppConstants.getGalleryColumns(800.0);
  /// print(columns); // 4 (tablet)
  /// ```
  static int getGalleryColumns(double screenWidth) {
    if (screenWidth <= mobileBreakpoint) {
      return galleryColumnsMobile;
    } else if (screenWidth <= tabletBreakpoint) {
      return galleryColumnsTablet;
    } else {
      return galleryColumnsDesktop;
    }
  }

  /// Formats bytes to human-readable file size.
  ///
  /// Example:
  /// ```dart
  /// final size = AppConstants.formatBytes(1024 * 1024);
  /// print(size); // "1.00 MB"
  /// ```
  static String formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  /// Formats zoom level as percentage string.
  ///
  /// Example:
  /// ```dart
  /// final zoom = AppConstants.formatZoomLevel(1.5);
  /// print(zoom); // "150%"
  /// ```
  static String formatZoomLevel(double zoom) {
    return '${(zoom * 100).toInt()}%';
  }
}
