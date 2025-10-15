// lib/widgets/toolbar.dart
import 'package:flutter/material.dart';
import 'package:pictogram_dart_flutter/core/constants/keyboard_shortcuts.dart';

class PictogramToolbar extends StatelessWidget {
  final VoidCallback? onDownload;
  final VoidCallback? onCopy;
  final VoidCallback? onPrint;
  final VoidCallback? onToggleMenu;

  const PictogramToolbar({
    this.onDownload,
    this.onCopy,
    this.onPrint,
    this.onToggleMenu,
    Key? key,
  }) : super(key: key);

  Widget _button(BuildContext ctx, IconData icon, String label, String shortcut, VoidCallback? onTap) {
    return Tooltip(
      message: '$label\t$shortcut',
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            SizedBox(height: 2),
            Text(shortcut, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: [
        _button(context, Icons.download, 'Descargar', KeyboardShortcuts.displayFor(KAction.saveImage), onDownload),
        _button(context, Icons.copy, 'Copiar', KeyboardShortcuts.displayFor(KAction.copyImage), onCopy),
        _button(context, Icons.print, 'Imprimir', KeyboardShortcuts.displayFor(KAction.printImage), onPrint),
        _button(context, Icons.menu, 'Mostrar/Ocultar menú', KeyboardShortcuts.displayFor(KAction.toggleMenu), onToggleMenu),
        // add more buttons as needed
      ],
    );
  }
}
