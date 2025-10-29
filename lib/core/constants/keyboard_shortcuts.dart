/// Keyboard shortcuts for the Pictogram application.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Categories for organizing keyboard shortcuts.
enum ShortcutCategory {
  /// Navigation shortcuts (moving between images)
  navigation,

  /// Image editing shortcuts (rotate, flip, etc.)
  editing,

  /// Action shortcuts (save, copy, print)
  actions,

  /// Zoom and view shortcuts
  zoom,

  /// UI control shortcuts
  ui,
}

/// Keyboard shortcuts configuration for the Pictogram application.
class KeyboardShortcuts {
  KeyboardShortcuts._();

  // ============================================================================
  // Navigation Shortcuts
  // ============================================================================
  static final LogicalKeySet previousImageKeys =
      LogicalKeySet(LogicalKeyboardKey.arrowLeft);
  static const String previousImageDescription = 'Previous image (←)';

  static final LogicalKeySet nextImageKeys =
      LogicalKeySet(LogicalKeyboardKey.arrowRight);
  static const String nextImageDescription = 'Next image (→)';
  
  static final LogicalKeySet firstImageKeys =
      LogicalKeySet(LogicalKeyboardKey.home);
  static const String firstImageDescription = 'First image (Home)';

  static final LogicalKeySet lastImageKeys =
      LogicalKeySet(LogicalKeyboardKey.end);
  static const String lastImageDescription = 'Last image (End)';

  // ============================================================================
  // Editing Shortcuts (USANDO LETRAS SIMPLES PARA MÁXIMA COMPATIBILIDAD)
  // ============================================================================

  /// Keys for rotating image clockwise (R)
  static final LogicalKeySet rotateClockwiseKeys = 
      LogicalKeySet(LogicalKeyboardKey.keyR);
  static const String rotateClockwiseDescription = 'Rotate clockwise (R)';

  /// Keys for rotating image counter-clockwise (L)
  static final LogicalKeySet rotateCounterClockwiseKeys = 
      LogicalKeySet(LogicalKeyboardKey.keyL);
  static const String rotateCounterClockwiseDescription =
      'Rotate counter-clockwise (L)';

  /// Keys for flipping image horizontally (H)
  static final LogicalKeySet flipHorizontalKeys = 
      LogicalKeySet(LogicalKeyboardKey.keyH);
  static const String flipHorizontalDescription =
      'Flip horizontally (H)';

  /// Keys for flipping image vertically (V)
  static final LogicalKeySet flipVerticalKeys = 
      LogicalKeySet(LogicalKeyboardKey.keyV);
  static const String flipVerticalDescription =
      'Flip vertically (V)';

  // ============================================================================
  // Action Shortcuts 
  // ============================================================================

  /// Keys for opening files (Ctrl+O)
  static final LogicalKeySet openFilesKeys = LogicalKeySet(
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.keyO,
  );
  static const String openFilesDescription = 'Open files (Ctrl+O)';

  /// Keys for downloading/saving image (Ctrl+S)
  static final LogicalKeySet downloadKeys = LogicalKeySet(
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.keyS,
  );
  static const String downloadDescription = 'Download image (Ctrl+S)';

  /// Keys for copying image (Ctrl+C)
  static final LogicalKeySet copyKeys = LogicalKeySet(
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.keyC,
  );
  static const String copyDescription = 'Copy image (Ctrl+C)';

  /// Keys for printing image (Ctrl+P)
  static final LogicalKeySet printKeys = LogicalKeySet(
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.keyP,
  );
  static const String printDescription = 'Print image (Ctrl+P)';

  /// Keys for deleting image (Delete)
  static final LogicalKeySet deleteImageKeys =
      LogicalKeySet(LogicalKeyboardKey.delete);
  static const String deleteImageDescription = 'Delete image (Delete)';

  // ============================================================================
  // Zoom Shortcuts
  // ============================================================================

  static final LogicalKeySet zoomInKeys =
      LogicalKeySet(LogicalKeyboardKey.equal); 
  static const String zoomInDescription = 'Zoom in (+)';

  static final LogicalKeySet zoomOutKeys =
      LogicalKeySet(LogicalKeyboardKey.minus);
  static const String zoomOutDescription = 'Zoom out (-)';

  static final LogicalKeySet zoomResetKeys =
      LogicalKeySet(LogicalKeyboardKey.digit0);
  static const String zoomResetDescription = 'Reset zoom (0)';

  static final LogicalKeySet fitToScreenKeys = LogicalKeySet(
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.digit0,
  );
  static const String fitToScreenDescription = 'Fit to screen (Ctrl+0)';

  // ============================================================================
  // UI Control Shortcuts
  // ============================================================================

  /// Keys for toggling menu (Alt)
  static final LogicalKeySet toggleMenuKeys =
      LogicalKeySet(LogicalKeyboardKey.alt);
  static const String toggleMenuDescription = 'Toggle menu (Alt)';

  /// Keys for toggling gallery (G)
  static final LogicalKeySet toggleGalleryKeys =
      LogicalKeySet(LogicalKeyboardKey.keyG);
  static const String toggleGalleryDescription = 'Toggle gallery (G)';

  /// Keys for closing dialog (Esc)
  static final LogicalKeySet closeDialogKeys =
      LogicalKeySet(LogicalKeyboardKey.escape);
  static const String closeDialogDescription = 'Close dialog (Esc)';

  /// Keys for toggling fullscreen (F11)
  static final LogicalKeySet toggleFullscreenKeys =
      LogicalKeySet(LogicalKeyboardKey.f11);
  static const String toggleFullscreenDescription = 'Toggle fullscreen (F11)';

  /// Keys for showing help (F1)
  static final LogicalKeySet showHelpKeys =
      LogicalKeySet(LogicalKeyboardKey.f1);
  static const String showHelpDescription = 'Show help (F1)';

  // ============================================================================
  // Helper Methods
  // ============================================================================

  static String getCategoryName(ShortcutCategory category) {
    switch (category) {
      case ShortcutCategory.navigation:
        return 'Navigation';
      case ShortcutCategory.editing:
        return 'Editing';
      case ShortcutCategory.actions:
        return 'Actions';
      case ShortcutCategory.zoom:
        return 'Zoom & View';
      case ShortcutCategory.ui:
        return 'UI Controls';
    }
  }

  static String getDisplayString(LogicalKeySet keySet) {
    final keys = keySet.keys.toList();
    final parts = <String>[];

    for (final key in keys) {
      if (key == LogicalKeyboardKey.control ||
          key == LogicalKeyboardKey.controlLeft ||
          key == LogicalKeyboardKey.controlRight) {
        parts.add('Ctrl');
      } else if (key == LogicalKeyboardKey.shift ||
          key == LogicalKeyboardKey.shiftLeft ||
          key == LogicalKeyboardKey.shiftRight) {
        parts.add('Shift');
      } else if (key == LogicalKeyboardKey.alt ||
          key == LogicalKeyboardKey.altLeft ||
          key == LogicalKeyboardKey.altRight) {
        parts.add('Alt');
      } else if (key == LogicalKeyboardKey.arrowLeft) {
        parts.add('←');
      } else if (key == LogicalKeyboardKey.arrowRight) {
        parts.add('→');
      } else if (key == LogicalKeyboardKey.arrowUp) {
        parts.add('↑');
      } else if (key == LogicalKeyboardKey.arrowDown) {
        parts.add('↓');
      } else if (key == LogicalKeyboardKey.escape) {
        parts.add('Esc');
      } else if (key == LogicalKeyboardKey.f11) {
        parts.add('F11');
      } else if (key == LogicalKeyboardKey.digit0 ||
          key == LogicalKeyboardKey.numpad0) {
        parts.add('0');
      } else if (key == LogicalKeyboardKey.equal ||
          key == LogicalKeyboardKey.add) {
        parts.add('+');
      } else if (key == LogicalKeyboardKey.minus) {
        parts.add('-');
      } else {
        parts.add(key.keyLabel.toUpperCase());
      }
    }

    return parts.join('+');
  }
}

extension ShortcutCategoryExtension on ShortcutCategory {
  String get displayName => KeyboardShortcuts.getCategoryName(this);
}