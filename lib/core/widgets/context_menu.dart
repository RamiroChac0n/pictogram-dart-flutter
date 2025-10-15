// lib/widgets/context_menu.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pictogram_dart_flutter/core/constants/keyboard_shortcuts.dart';
import 'package:pictogram_dart_flutter/core/services/web_tools.dart';

Future<void> showImageContextMenu({
  required BuildContext context,
  required Offset globalPosition,
  required Uint8List? imageBytes,
  required String? filename,
}) async {
  final selected = await showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(globalPosition.dx, globalPosition.dy, globalPosition.dx, globalPosition.dy),
    items: [
      PopupMenuItem(value: 'copy-image', child: Text('Copiar imagen\t${KeyboardShortcuts.displayFor(KAction.copyImage)}')),
      PopupMenuItem(value: 'copy-filename', child: Text('Copiar nombre\t${KeyboardShortcuts.displayFor(KAction.copyFilename)}')),
      PopupMenuItem(value: 'download', child: Text('Descargar\t${KeyboardShortcuts.displayFor(KAction.saveImage)}')),
      PopupMenuItem(value: 'print', child: Text('Imprimir\t${KeyboardShortcuts.displayFor(KAction.printImage)}')),
    ],
  );

  if (selected == null) return;

  switch (selected) {
    case 'copy-image':
      if (imageBytes != null) {
        await copyImageToClipboard(imageBytes);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imagen copiada al portapapeles')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No hay imagen seleccionada')));
      }
      break;
    case 'copy-filename':
      if (filename != null) {
        await copyTextToClipboard(filename);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nombre copiado')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No hay nombre disponible')));
      }
      break;
    case 'download':
      if (imageBytes != null && filename != null) {
        downloadBytes(imageBytes, filename);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No hay imagen para descargar')));
      }
      break;
    case 'print':
      printPage();
      break;
  }
}
