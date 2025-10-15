import 'package:flutter/widgets.dart';

/// Intent definitions for keyboard shortcuts in the application
///
/// Each Intent represents a specific user action that can be triggered by a keyboard shortcut.
/// These intents are mapped to Actions in keyboard_shortcut_manager.dart

// ============================================================================
// IMAGE TRANSFORMATION INTENTS
// ============================================================================

/// Intent to rotate image 90° clockwise (Ctrl+→)
class RotateRightIntent extends Intent {
  const RotateRightIntent();
}

/// Intent to rotate image 90° counter-clockwise (Ctrl+←)
class RotateLeftIntent extends Intent {
  const RotateLeftIntent();
}

/// Intent to flip image vertically (Ctrl+Shift+↑)
class FlipVerticalIntent extends Intent {
  const FlipVerticalIntent();
}

/// Intent to flip image horizontally (Ctrl+Shift+→)
class FlipHorizontalIntent extends Intent {
  const FlipHorizontalIntent();
}

// ============================================================================
// FILE OPERATION INTENTS
// ============================================================================

/// Intent to save changes (Ctrl+S)
class SaveIntent extends Intent {
  const SaveIntent();
}

/// Intent to copy image to clipboard (Ctrl+C)
class CopyImageIntent extends Intent {
  const CopyImageIntent();
}

/// Intent to print image (Ctrl+P)
class PrintIntent extends Intent {
  const PrintIntent();
}

// ============================================================================
// NAVIGATION INTENTS
// ============================================================================

/// Intent to navigate to next image (→)
class NavigateNextIntent extends Intent {
  const NavigateNextIntent();
}

/// Intent to navigate to previous image (←)
class NavigatePreviousIntent extends Intent {
  const NavigatePreviousIntent();
}

// ============================================================================
// VIEW CONTROL INTENTS
// ============================================================================

/// Intent to toggle fullscreen mode (F11)
class ToggleFullscreenIntent extends Intent {
  const ToggleFullscreenIntent();
}

/// Intent to toggle menu visibility (Alt)
class ToggleMenuIntent extends Intent {
  const ToggleMenuIntent();
}

/// Intent to zoom in (Ctrl++)
class ZoomInIntent extends Intent {
  const ZoomInIntent();
}

/// Intent to zoom out (Ctrl+-)
class ZoomOutIntent extends Intent {
  const ZoomOutIntent();
}

/// Intent to reset zoom to fit viewport (Ctrl+0)
class ResetZoomIntent extends Intent {
  const ResetZoomIntent();
}

// ============================================================================
// ADDITIONAL UTILITY INTENTS
// ============================================================================

/// Intent to open format conversion dialog
class ConvertFormatIntent extends Intent {
  const ConvertFormatIntent();
}

/// Intent to open resize dialog
class ResizeImageIntent extends Intent {
  const ResizeImageIntent();
}

/// Intent to undo last operation (Ctrl+Z)
class UndoIntent extends Intent {
  const UndoIntent();
}

/// Intent to redo last undone operation (Ctrl+Y or Ctrl+Shift+Z)
class RedoIntent extends Intent {
  const RedoIntent();
}
