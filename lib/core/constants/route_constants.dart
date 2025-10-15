/// Route name constants for the application
///
/// This file contains all route names used throughout the app
/// with GoRouter for type-safe navigation.
class RouteConstants {
  // Prevent instantiation
  RouteConstants._();

  /// Gallery route - Main screen showing image thumbnails
  static const String gallery = '/gallery';

  /// Viewer route - Image viewer with zoom and pan capabilities
  /// Requires imageId parameter
  static const String viewer = '/viewer';

  /// Editor route - Image editor with transformations
  /// Requires imageId parameter
  static const String editor = '/editor';

  /// Settings route - Application settings
  static const String settings = '/settings';

  // Route names (for named navigation)
  static const String galleryName = 'gallery';
  static const String viewerName = 'viewer';
  static const String editorName = 'editor';
  static const String settingsName = 'settings';

  /// Helper to build viewer route with imageId
  static String viewerRoute(String imageId) => '$viewer/$imageId';

  /// Helper to build editor route with imageId
  static String editorRoute(String imageId) => '$editor/$imageId';
}
