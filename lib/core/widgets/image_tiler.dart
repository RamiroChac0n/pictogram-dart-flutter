// lib/widgets/image_tile.dart
import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pictogram_dart_flutter/core/constants/keyboard_shortcuts.dart';
import '../widgets/context_menu.dart';

class ImageTile extends StatelessWidget {
  final Uint8List imageBytes;
  final String filename;
  final VoidCallback? onSelect;

  const ImageTile({
    required this.imageBytes,
    required this.filename,
    this.onSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        // Right click / secondary button
        if (event.buttons == kSecondaryMouseButton) {
          showImageContextMenu(
            context: context,
            globalPosition: event.position,
            imageBytes: imageBytes,
            filename: filename,
          );
        }
      },
      child: GestureDetector(
        onTap: onSelect,
        child: Tooltip(
          message: 'Abrir • ${KeyboardShortcuts.displayFor(KAction.nextImage)} / ${KeyboardShortcuts.displayFor(KAction.prevImage)}\nClick derecho para más acciones',
          child: Card(
            child: Column(
              children: [
                Expanded(
                  child: Image.memory(imageBytes, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(filename, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
