import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:clipboard/clipboard.dart';

/// Helper class for clipboard operations
///
/// Provides functionality to:
/// - Copy images to clipboard
/// - Copy text (file paths) to clipboard
/// - Handle clipboard operations across platforms (Web, Desktop, Mobile)
class ClipboardHelper {
  // Prevent instantiation
  ClipboardHelper._();

  /// Copy image bytes to clipboard
  ///
  /// Note: Image copying to clipboard has platform limitations:
  /// - Desktop (Windows/Linux/macOS): Supported
  /// - Web: Limited support, depends on browser
  /// - Mobile: Limited support
  ///
  /// Returns true if successful, false otherwise
  static Future<bool> copyImageToClipboard(Uint8List imageBytes) async {
    try {
      // TODO: Implement actual image copying
      // The 'clipboard' package primarily handles text
      // For images, we might need platform-specific implementations

      // For now, we can show a message that image was "prepared for clipboard"
      debugPrint('[ClipboardHelper] Image copy requested (${imageBytes.length} bytes)');

      // Platform-specific implementation would go here
      // For web: use Blob API and navigator.clipboard
      // For desktop: use platform channels or packages like super_clipboard

      return false; // Not fully implemented yet
    } catch (e) {
      debugPrint('[ClipboardHelper] Error copying image: $e');
      return false;
    }
  }

  /// Copy text to clipboard
  ///
  /// This works reliably across all platforms.
  /// Commonly used for copying file paths.
  ///
  /// Returns true if successful, false otherwise
  static Future<bool> copyTextToClipboard(String text) async {
    try {
      await FlutterClipboard.copy(text);
      debugPrint('[ClipboardHelper] Text copied to clipboard: $text');
      return true;
    } catch (e) {
      debugPrint('[ClipboardHelper] Error copying text: $e');
      return false;
    }
  }

  /// Copy file path to clipboard
  ///
  /// Convenience method for copying image file paths
  static Future<bool> copyPathToClipboard(String path) async {
    return await copyTextToClipboard(path);
  }

  /// Paste text from clipboard
  ///
  /// Returns the clipboard text content, or null if unavailable
  static Future<String?> pasteFromClipboard() async {
    try {
      final text = await FlutterClipboard.paste();
      debugPrint('[ClipboardHelper] Text pasted from clipboard');
      return text;
    } catch (e) {
      debugPrint('[ClipboardHelper] Error pasting from clipboard: $e');
      return null;
    }
  }

  /// Check if clipboard has content
  ///
  /// Note: This is a simplified check for text content
  static Future<bool> hasClipboardContent() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      return data != null && data.text != null && data.text!.isNotEmpty;
    } catch (e) {
      debugPrint('[ClipboardHelper] Error checking clipboard: $e');
      return false;
    }
  }
}
