// lib/app.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants/keyboard_shortcuts.dart';
import 'core/services/keyboard_handler.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FocusNode _focusNode = FocusNode();
  late KeyboardHandler _keyboardHandler;

  // Example: selected image data would come from your app's state / provider
  Uint8List? selectedImageBytes;
  String? selectedFilename;
  bool menuVisible = true;

  @override
  void initState() {
    super.initState();
    _keyboardHandler = KeyboardHandler(
      context,
      onNext: _onNext,
      onPrev: _onPrev,
      onRotateLeft: _onRotateLeft,
      onRotateRight: _onRotateRight,
      onFlipHorizontal: _onFlipH,
      onFlipVertical: _onFlipV,
      onZoomIn: _onZoomIn,
      onZoomOut: _onZoomOut,
      onZoomReset: _onZoomReset,
      onFullscreenToggle: _onFullscreen,
      onToggleMenu: _toggleMenu,
      onCloseDialog: _closeDialog,
    );
    // you may want to set initial selected data if available
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: _handleRawKeyEvent,
      child: MaterialApp(
        title: 'Pictogram Web',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Pictogram (Web)'),
            actions: [
              // add toolbar widget (we will create a Toolbar widget later)
            ],
          ),
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        if (menuVisible) _exampleToolbar(),
        Expanded(
          child: Center(
            child: Text('Aquí va tu UI (lista/galería de imágenes).'),
          ),
        ),
      ],
    );
  }

  Widget _exampleToolbar() {
    // placeholder: replace by the toolbar widget file suggested below
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.grey[100],
      child: Row(
        children: [
          Tooltip(
            message: 'Descargar (${KeyboardShortcuts.displayFor(KAction.saveImage)})',
            child: ElevatedButton.icon(
              icon: Icon(Icons.download),
              label: Text('Descargar'),
              onPressed: () async {
                if (selectedImageBytes != null && selectedFilename != null) {
                  // perform download
                }
              },
            ),
          ),
          SizedBox(width: 8),
          Tooltip(
            message: 'Copiar imagen (${KeyboardShortcuts.displayFor(KAction.copyImage)})',
            child: ElevatedButton.icon(
              icon: Icon(Icons.copy),
              label: Text('Copiar'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

 void _handleRawKeyEvent(RawKeyEvent event) {
  if (event is RawKeyDownEvent) {
    final LogicalKeyboardKey key = event.logicalKey;

    // Recolectamos teclas modificadoras
    final isCtrl = event.isControlPressed;
    final isShift = event.isShiftPressed;
    final isAlt = event.isAltPressed;

    // Construimos el conjunto de teclas presionadas
    final pressedKeys = <LogicalKeyboardKey>{
      if (isCtrl) LogicalKeyboardKey.control,
      if (isShift) LogicalKeyboardKey.shift,
      if (isAlt) LogicalKeyboardKey.altLeft,
      key,
    };

    final pressedSet = LogicalKeySet.fromSet(pressedKeys);

    // Buscamos si coincide con alguno de los shortcuts definidos
    for (final entry in KeyboardShortcuts.map.entries) {
      if (_keySetsEqual(entry.value, pressedSet)) {
        _keyboardHandler.selectedImageBytes = selectedImageBytes;
        _keyboardHandler.selectedFilename = selectedFilename;
        _keyboardHandler.handleAction(entry.key);
        break;
      }
    }
  }
}


  bool _keySetsEqual(LogicalKeySet a, LogicalKeySet b) {
    final as = a.keys.toSet();
    final bs = b.keys.toSet();
    return as.length == bs.length && as.containsAll(bs);
  }

  // Example stub handlers - replace with your real logic
  void _onNext() => _show('Siguiente imagen');
  void _onPrev() => _show('Imagen anterior');
  void _onRotateLeft() => _show('Rotar izquierda');
  void _onRotateRight() => _show('Rotar derecha');
  void _onFlipH() => _show('Flip horizontal');
  void _onFlipV() => _show('Flip vertical');
  void _onZoomIn() => _show('Zoom +');
  void _onZoomOut() => _show('Zoom -');
  void _onZoomReset() => _show('Reset zoom');
  void _onFullscreen() => _show('Toggle fullscreen');
  void _toggleMenu() => setState(() => menuVisible = !menuVisible);
  void _closeDialog() => Navigator.of(context, rootNavigator: true).maybePop();

  void _show(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s), duration: Duration(milliseconds: 600)));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
