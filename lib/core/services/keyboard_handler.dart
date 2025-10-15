// lib/core/services/keyboard_handler.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../constants/keyboard_shortcuts.dart';
import 'web_tools.dart';// Ensure this is the correct path to the file where KAction is defined

class KeyboardHandler {
  final BuildContext context;
  // Provide callback hooks to integrate with app state (e.g., nextImage, rotate)
  final VoidCallback? onNext;
  final VoidCallback? onPrev;
  final VoidCallback? onRotateLeft;
  final VoidCallback? onRotateRight;
  final VoidCallback? onFlipHorizontal;
  final VoidCallback? onFlipVertical;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onZoomReset;
  final VoidCallback? onFullscreenToggle;
  final VoidCallback? onToggleMenu;
  final VoidCallback? onCloseDialog;

  // For clipboard/download/print we may need image data + filename; keep last selected:
  Uint8List? selectedImageBytes;
  String? selectedFilename;

  KeyboardHandler(this.context, {
    this.onNext,
    this.onPrev,
    this.onRotateLeft,
    this.onRotateRight,
    this.onFlipHorizontal,
    this.onFlipVertical,
    this.onZoomIn,
    this.onZoomOut,
    this.onZoomReset,
    this.onFullscreenToggle,
    this.onToggleMenu,
    this.onCloseDialog,
  });

  Future<void> handleAction(KAction action) async {
    switch (action) {
      case KAction.nextImage:
        onNext?.call();
        break;
      case KAction.prevImage:
        onPrev?.call();
        break;
      case KAction.rotateLeft:
        onRotateLeft?.call();
        break;
      case KAction.rotateRight:
        onRotateRight?.call();
        break;
      case KAction.flipHorizontal:
        onFlipHorizontal?.call();
        break;
      case KAction.flipVertical:
        onFlipVertical?.call();
        break;
      case KAction.saveImage:
        if (selectedImageBytes != null && selectedFilename != null) {
          downloadBytes(selectedImageBytes!, selectedFilename!);
          _showSnack('Descargando $selectedFilename');
        } else {
          _showSnack('No hay imagen seleccionada para descargar');
        }
        break;
      case KAction.copyImage:
        if (selectedImageBytes != null) {
          await copyImageToClipboard(selectedImageBytes!);
          _showSnack('Imagen copiada al portapapeles (data URL fallback).');
        } else {
          _showSnack('No hay imagen seleccionada para copiar');
        }
        break;
      case KAction.printImage:
        printPage();
        break;
      case KAction.zoomIn:
        onZoomIn?.call();
        break;
      case KAction.zoomOut:
        onZoomOut?.call();
        break;
      case KAction.zoomReset:
        onZoomReset?.call();
        break;
      case KAction.fullscreen:
        onFullscreenToggle?.call();
        break;
      case KAction.toggleMenu:
        onToggleMenu?.call();
        break;
      case KAction.closeDialog:
        onCloseDialog?.call();
        break;
      case KAction.copyFilename:
        if (selectedFilename != null) {
          await copyTextToClipboard(selectedFilename!);
          _showSnack('Nombre de archivo copiado');
        } else {
          _showSnack('No hay archivo seleccionado');
        }
        break;
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: Duration(seconds: 1)),
    );
  }
}
