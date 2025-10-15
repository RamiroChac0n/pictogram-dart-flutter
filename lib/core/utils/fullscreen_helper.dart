import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:window_manager/window_manager.dart';
import 'dart:io' show Platform;

/// Helper class for fullscreen functionality
///
/// Provides platform-aware fullscreen toggle:
/// - Desktop (Windows/Linux/macOS): Uses window_manager package
/// - Web: Uses browser fullscreen API (to be implemented)
/// - Mobile: Generally doesn't support fullscreen in the same way
class FullscreenHelper {
  // Prevent instantiation
  FullscreenHelper._();

  // Internal state tracking
  static bool _isFullscreen = false;

  /// Get current fullscreen state
  static bool get isFullscreen => _isFullscreen;

  /// Initialize fullscreen helper
  ///
  /// Should be called once during app initialization (for desktop platforms)
  static Future<void> initialize() async {
    if (kIsWeb || !_isDesktop()) {
      // Web and mobile don't need initialization
      return;
    }

    try {
      // Ensure window manager is initialized
      await windowManager.ensureInitialized();
      debugPrint('[FullscreenHelper] Initialized for desktop');
    } catch (e) {
      debugPrint('[FullscreenHelper] Error initializing: $e');
    }
  }

  /// Toggle fullscreen mode
  ///
  /// Returns the new fullscreen state
  static Future<bool> toggleFullscreen() async {
    if (_isFullscreen) {
      return await exitFullscreen();
    } else {
      return await enterFullscreen();
    }
  }

  /// Enter fullscreen mode
  ///
  /// Returns true if entered fullscreen successfully
  static Future<bool> enterFullscreen() async {
    try {
      if (kIsWeb) {
        return await _enterFullscreenWeb();
      } else if (_isDesktop()) {
        return await _enterFullscreenDesktop();
      } else {
        // Mobile - not implemented
        debugPrint('[FullscreenHelper] Fullscreen not supported on this platform');
        return false;
      }
    } catch (e) {
      debugPrint('[FullscreenHelper] Error entering fullscreen: $e');
      return false;
    }
  }

  /// Exit fullscreen mode
  ///
  /// Returns true if exited fullscreen successfully
  static Future<bool> exitFullscreen() async {
    try {
      if (kIsWeb) {
        return await _exitFullscreenWeb();
      } else if (_isDesktop()) {
        return await _exitFullscreenDesktop();
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('[FullscreenHelper] Error exiting fullscreen: $e');
      return false;
    }
  }

  // ==========================================================================
  // DESKTOP IMPLEMENTATION (Windows, Linux, macOS)
  // ==========================================================================

  static Future<bool> _enterFullscreenDesktop() async {
    try {
      await windowManager.setFullScreen(true);
      _isFullscreen = true;
      debugPrint('[FullscreenHelper] Entered fullscreen (desktop)');
      return true;
    } catch (e) {
      debugPrint('[FullscreenHelper] Error entering fullscreen (desktop): $e');
      return false;
    }
  }

  static Future<bool> _exitFullscreenDesktop() async {
    try {
      await windowManager.setFullScreen(false);
      _isFullscreen = false;
      debugPrint('[FullscreenHelper] Exited fullscreen (desktop)');
      return true;
    } catch (e) {
      debugPrint('[FullscreenHelper] Error exiting fullscreen (desktop): $e');
      return false;
    }
  }

  // ==========================================================================
  // WEB IMPLEMENTATION
  // ==========================================================================

  static Future<bool> _enterFullscreenWeb() async {
    try {
      // TODO: Implement web fullscreen using dart:html
      // This would use: document.documentElement.requestFullscreen()
      debugPrint('[FullscreenHelper] Web fullscreen not yet implemented');
      _isFullscreen = true;
      return false; // Not implemented yet
    } catch (e) {
      debugPrint('[FullscreenHelper] Error entering fullscreen (web): $e');
      return false;
    }
  }

  static Future<bool> _exitFullscreenWeb() async {
    try {
      // TODO: Implement web fullscreen exit using dart:html
      // This would use: document.exitFullscreen()
      debugPrint('[FullscreenHelper] Web fullscreen exit not yet implemented');
      _isFullscreen = false;
      return false; // Not implemented yet
    } catch (e) {
      debugPrint('[FullscreenHelper] Error exiting fullscreen (web): $e');
      return false;
    }
  }

  // ==========================================================================
  // HELPER METHODS
  // ==========================================================================

  /// Check if running on desktop platform
  static bool _isDesktop() {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  /// Check if fullscreen is supported on current platform
  static bool isFullscreenSupported() {
    return kIsWeb || _isDesktop();
  }

  /// Set window size (desktop only)
  ///
  /// Helper method for restoring window size when exiting fullscreen
  static Future<void> setWindowSize({
    required double width,
    required double height,
  }) async {
    if (!_isDesktop()) return;

    try {
      await windowManager.setSize(Size(width, height));
      debugPrint('[FullscreenHelper] Window size set to ${width}x$height');
    } catch (e) {
      debugPrint('[FullscreenHelper] Error setting window size: $e');
    }
  }

  /// Center window (desktop only)
  ///
  /// Useful after exiting fullscreen
  static Future<void> centerWindow() async {
    if (!_isDesktop()) return;

    try {
      await windowManager.center();
      debugPrint('[FullscreenHelper] Window centered');
    } catch (e) {
      debugPrint('[FullscreenHelper] Error centering window: $e');
    }
  }

  /// Set window title (desktop only)
  static Future<void> setWindowTitle(String title) async {
    if (!_isDesktop()) return;

    try {
      await windowManager.setTitle(title);
    } catch (e) {
      debugPrint('[FullscreenHelper] Error setting window title: $e');
    }
  }
}
