import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'shortcut_intents.dart';

/// Manager for application-wide keyboard shortcuts
///
/// This class provides:
/// - Centralized shortcut definitions
/// - Default action handlers
/// - Easy integration with Flutter's Shortcuts and Actions widgets
///
/// Usage:
/// ```dart
/// Shortcuts(
///   shortcuts: KeyboardShortcutManager.shortcuts,
///   child: Actions(
///     actions: KeyboardShortcutManager.getActions(context),
///     child: YourWidget(),
///   ),
/// )
/// ```
class KeyboardShortcutManager {
  // Prevent instantiation
  KeyboardShortcutManager._();

  /// Map of keyboard shortcuts to intents
  ///
  /// This defines which key combinations trigger which intents.
  /// The actual behavior is defined in the Actions widget.
  static Map<ShortcutActivator, Intent> get shortcuts => {
        // ====================================================================
        // IMAGE TRANSFORMATIONS
        // ====================================================================

        // Rotate right: Ctrl+→
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.arrowRight,
        ): const RotateRightIntent(),

        // Rotate left: Ctrl+←
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.arrowLeft,
        ): const RotateLeftIntent(),

        // Flip vertical: Ctrl+Shift+↑
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.arrowUp,
        ): const FlipVerticalIntent(),

        // Flip horizontal: Ctrl+Shift+→
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.arrowRight,
        ): const FlipHorizontalIntent(),

        // ====================================================================
        // FILE OPERATIONS
        // ====================================================================

        // Save: Ctrl+S
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyS,
        ): const SaveIntent(),

        // Copy: Ctrl+C
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyC,
        ): const CopyImageIntent(),

        // Print: Ctrl+P
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyP,
        ): const PrintIntent(),

        // ====================================================================
        // NAVIGATION
        // ====================================================================

        // Next image: →
        const SingleActivator(LogicalKeyboardKey.arrowRight):
            const NavigateNextIntent(),

        // Previous image: ←
        const SingleActivator(LogicalKeyboardKey.arrowLeft):
            const NavigatePreviousIntent(),

        // ====================================================================
        // VIEW CONTROLS
        // ====================================================================

        // Fullscreen: F11
        const SingleActivator(LogicalKeyboardKey.f11):
            const ToggleFullscreenIntent(),

        // Toggle menu: Alt
        const SingleActivator(LogicalKeyboardKey.alt):
            const ToggleMenuIntent(),

        // Zoom in: Ctrl++
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.equal, // '+' key
        ): const ZoomInIntent(),

        // Zoom out: Ctrl+-
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.minus,
        ): const ZoomOutIntent(),

        // Reset zoom: Ctrl+0
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.digit0,
        ): const ResetZoomIntent(),

        // ====================================================================
        // ADDITIONAL UTILITIES
        // ====================================================================

        // Undo: Ctrl+Z
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyZ,
        ): const UndoIntent(),

        // Redo: Ctrl+Y
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.keyY,
        ): const RedoIntent(),

        // Redo alternative: Ctrl+Shift+Z
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.shift,
          LogicalKeyboardKey.keyZ,
        ): const RedoIntent(),
      };

  /// Get default action handlers for shortcuts
  ///
  /// These are fallback handlers that show a snackbar with the action name.
  /// Individual pages/features should override these with their own Actions widget.
  ///
  /// Example of overriding in a specific page:
  /// ```dart
  /// Actions(
  ///   actions: {
  ///     RotateRightIntent: CallbackAction<RotateRightIntent>(
  ///       onInvoke: (intent) {
  ///         context.read<EditorBloc>().add(RotateRightEvent());
  ///         return null;
  ///       },
  ///     ),
  ///   },
  ///   child: YourWidget(),
  /// )
  /// ```
  static Map<Type, Action<Intent>> getActions(BuildContext context) => {
        // Transformation actions
        RotateRightIntent: CallbackAction<RotateRightIntent>(
          onInvoke: (intent) => _handleRotateRight(context),
        ),
        RotateLeftIntent: CallbackAction<RotateLeftIntent>(
          onInvoke: (intent) => _handleRotateLeft(context),
        ),
        FlipVerticalIntent: CallbackAction<FlipVerticalIntent>(
          onInvoke: (intent) => _handleFlipVertical(context),
        ),
        FlipHorizontalIntent: CallbackAction<FlipHorizontalIntent>(
          onInvoke: (intent) => _handleFlipHorizontal(context),
        ),

        // File operations
        SaveIntent: CallbackAction<SaveIntent>(
          onInvoke: (intent) => _handleSave(context),
        ),
        CopyImageIntent: CallbackAction<CopyImageIntent>(
          onInvoke: (intent) => _handleCopyImage(context),
        ),
        PrintIntent: CallbackAction<PrintIntent>(
          onInvoke: (intent) => _handlePrint(context),
        ),

        // Navigation
        NavigateNextIntent: CallbackAction<NavigateNextIntent>(
          onInvoke: (intent) => _handleNavigateNext(context),
        ),
        NavigatePreviousIntent: CallbackAction<NavigatePreviousIntent>(
          onInvoke: (intent) => _handleNavigatePrevious(context),
        ),

        // View controls
        ToggleFullscreenIntent: CallbackAction<ToggleFullscreenIntent>(
          onInvoke: (intent) => _handleToggleFullscreen(context),
        ),
        ToggleMenuIntent: CallbackAction<ToggleMenuIntent>(
          onInvoke: (intent) => _handleToggleMenu(context),
        ),
        ZoomInIntent: CallbackAction<ZoomInIntent>(
          onInvoke: (intent) => _handleZoomIn(context),
        ),
        ZoomOutIntent: CallbackAction<ZoomOutIntent>(
          onInvoke: (intent) => _handleZoomOut(context),
        ),
        ResetZoomIntent: CallbackAction<ResetZoomIntent>(
          onInvoke: (intent) => _handleResetZoom(context),
        ),

        // Utilities
        UndoIntent: CallbackAction<UndoIntent>(
          onInvoke: (intent) => _handleUndo(context),
        ),
        RedoIntent: CallbackAction<RedoIntent>(
          onInvoke: (intent) => _handleRedo(context),
        ),
      };

  // ==========================================================================
  // DEFAULT ACTION HANDLERS
  // These are fallback implementations. Each feature should override them.
  // ==========================================================================

  static void _handleRotateRight(BuildContext context) {
    debugPrint('[Shortcut] Rotate Right - Ctrl+→');
    // TODO: Will be implemented when EditorBloc is available
    // context.read<EditorBloc>().add(RotateRightEvent());
  }

  static void _handleRotateLeft(BuildContext context) {
    debugPrint('[Shortcut] Rotate Left - Ctrl+←');
    // TODO: Will be implemented when EditorBloc is available
    // context.read<EditorBloc>().add(RotateLeftEvent());
  }

  static void _handleFlipVertical(BuildContext context) {
    debugPrint('[Shortcut] Flip Vertical - Ctrl+Shift+↑');
    // TODO: Will be implemented when EditorBloc is available
    // context.read<EditorBloc>().add(FlipVerticalEvent());
  }

  static void _handleFlipHorizontal(BuildContext context) {
    debugPrint('[Shortcut] Flip Horizontal - Ctrl+Shift+→');
    // TODO: Will be implemented when EditorBloc is available
    // context.read<EditorBloc>().add(FlipHorizontalEvent());
  }

  static void _handleSave(BuildContext context) {
    debugPrint('[Shortcut] Save - Ctrl+S');
    // TODO: Will be implemented when EditorBloc is available
    // context.read<EditorBloc>().add(SaveChangesEvent());
  }

  static void _handleCopyImage(BuildContext context) {
    debugPrint('[Shortcut] Copy Image - Ctrl+C');
    // TODO: Will use ClipboardHelper when implemented
  }

  static void _handlePrint(BuildContext context) {
    debugPrint('[Shortcut] Print - Ctrl+P');
    // TODO: Will use PrintHelper when implemented
  }

  static void _handleNavigateNext(BuildContext context) {
    debugPrint('[Shortcut] Navigate Next - →');
    // TODO: Will be implemented when NavigationCubit is available
    // context.read<NavigationCubit>().navigateNext();
  }

  static void _handleNavigatePrevious(BuildContext context) {
    debugPrint('[Shortcut] Navigate Previous - ←');
    // TODO: Will be implemented when NavigationCubit is available
    // context.read<NavigationCubit>().navigatePrevious();
  }

  static void _handleToggleFullscreen(BuildContext context) {
    debugPrint('[Shortcut] Toggle Fullscreen - F11');
    // TODO: Will use FullscreenHelper when implemented
  }

  static void _handleToggleMenu(BuildContext context) {
    debugPrint('[Shortcut] Toggle Menu - Alt');
    // TODO: Will toggle toolbar visibility
  }

  static void _handleZoomIn(BuildContext context) {
    debugPrint('[Shortcut] Zoom In - Ctrl++');
    // TODO: Will be implemented when ViewerBloc is available
    // context.read<ViewerBloc>().add(ZoomInEvent());
  }

  static void _handleZoomOut(BuildContext context) {
    debugPrint('[Shortcut] Zoom Out - Ctrl+-');
    // TODO: Will be implemented when ViewerBloc is available
    // context.read<ViewerBloc>().add(ZoomOutEvent());
  }

  static void _handleResetZoom(BuildContext context) {
    debugPrint('[Shortcut] Reset Zoom - Ctrl+0');
    // TODO: Will be implemented when ViewerBloc is available
    // context.read<ViewerBloc>().add(ResetZoomEvent());
  }

  static void _handleUndo(BuildContext context) {
    debugPrint('[Shortcut] Undo - Ctrl+Z');
    // TODO: Will be implemented when EditorBloc is available
    // context.read<EditorBloc>().add(UndoEvent());
  }

  static void _handleRedo(BuildContext context) {
    debugPrint('[Shortcut] Redo - Ctrl+Y / Ctrl+Shift+Z');
    // TODO: Will be implemented when EditorBloc is available
    // context.read<EditorBloc>().add(RedoEvent());
  }

  /// Helper to show a snackbar for testing shortcuts
  static void _showShortcutFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Get human-readable shortcut description for a given intent
  static String getShortcutDescription(Intent intent) {
    if (intent is RotateRightIntent) return 'Ctrl+→';
    if (intent is RotateLeftIntent) return 'Ctrl+←';
    if (intent is FlipVerticalIntent) return 'Ctrl+Shift+↑';
    if (intent is FlipHorizontalIntent) return 'Ctrl+Shift+→';
    if (intent is SaveIntent) return 'Ctrl+S';
    if (intent is CopyImageIntent) return 'Ctrl+C';
    if (intent is PrintIntent) return 'Ctrl+P';
    if (intent is NavigateNextIntent) return '→';
    if (intent is NavigatePreviousIntent) return '←';
    if (intent is ToggleFullscreenIntent) return 'F11';
    if (intent is ToggleMenuIntent) return 'Alt';
    if (intent is ZoomInIntent) return 'Ctrl++';
    if (intent is ZoomOutIntent) return 'Ctrl+-';
    if (intent is ResetZoomIntent) return 'Ctrl+0';
    if (intent is UndoIntent) return 'Ctrl+Z';
    if (intent is RedoIntent) return 'Ctrl+Y';
    return '';
  }
}
