// lib/core/constants/keyboard_shortcuts.dart
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum KAction {
  prevImage,
  nextImage,
  rotateLeft,
  rotateRight,
  flipHorizontal,
  flipVertical,
  saveImage,
  copyImage,
  printImage,
  zoomIn,
  zoomOut,
  zoomReset,
  fullscreen,
  toggleMenu,
  closeDialog,
  copyFilename,
}

class KeyboardShortcuts {
  // Map from a human key (string id) to a LogicalKeySet
  static final Map<KAction, LogicalKeySet> map = {
    // Navigation images
    KAction.prevImage: LogicalKeySet(LogicalKeyboardKey.arrowLeft),
    KAction.nextImage: LogicalKeySet(LogicalKeyboardKey.arrowRight),

    // Rotate (Ctrl + ← / →)
    KAction.rotateLeft: LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.arrowLeft),
    KAction.rotateRight: LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.arrowRight),

    // Flip (Ctrl+Shift+→/↑) -> using right/up as examples
    KAction.flipHorizontal: LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowRight),
    KAction.flipVertical: LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowUp),

    // Actions
    KAction.saveImage: LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS),
    KAction.copyImage: LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyC),
    KAction.printImage: LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyP),

    // Zoom
    KAction.zoomIn: LogicalKeySet(LogicalKeyboardKey.equal), // '+' often equals with shift, listen to '='
    KAction.zoomOut: LogicalKeySet(LogicalKeyboardKey.minus),
    KAction.zoomReset: LogicalKeySet(LogicalKeyboardKey.digit0),
    KAction.fullscreen: LogicalKeySet(LogicalKeyboardKey.f11),

    // UI
    KAction.toggleMenu: LogicalKeySet(LogicalKeyboardKey.altLeft), // Alt toggle
    KAction.closeDialog: LogicalKeySet(LogicalKeyboardKey.escape),

    // Copy filename
    KAction.copyFilename: LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift, LogicalKeyboardKey.keyC),
  };

  // Friendly display for tooltips / UI
  static String displayFor(KAction action) {
    final set = map[action];
    if (set == null) return '';
    return set.keys.map(_keyLabel).join('+');
  }

  static String _keyLabel(LogicalKeyboardKey k) {
    // prettier labels for common keys
    if (k == LogicalKeyboardKey.control) return 'Ctrl';
    if (k == LogicalKeyboardKey.shift) return 'Shift';
    if (k == LogicalKeyboardKey.altLeft || k == LogicalKeyboardKey.altRight) return 'Alt';
    if (k == LogicalKeyboardKey.arrowLeft) return '←';
    if (k == LogicalKeyboardKey.arrowRight) return '→';
    if (k == LogicalKeyboardKey.arrowUp) return '↑';
    if (k == LogicalKeyboardKey.arrowDown) return '↓';
    if (k == LogicalKeyboardKey.keyS) return 'S';
    if (k == LogicalKeyboardKey.keyC) return 'C';
    if (k == LogicalKeyboardKey.keyP) return 'P';
    if (k == LogicalKeyboardKey.equal) return '+';
    if (k == LogicalKeyboardKey.minus) return '-';
    if (k == LogicalKeyboardKey.digit0) return '0';
    if (k == LogicalKeyboardKey.f11) return 'F11';
    return k.keyLabel.isNotEmpty ? k.keyLabel.toUpperCase() : k.debugName ?? '';
  }
}
