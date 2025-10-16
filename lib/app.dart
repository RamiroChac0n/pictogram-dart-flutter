// lib/app.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter/services.dart';
import 'core/constants/keyboard_shortcuts.dart';
import 'core/services/keyboard_handler.dart';
=======
import 'package:provider/provider.dart';
import 'presentation/editor/editor_page.dart';

import 'core/theme/theme_provider.dart';
import 'core/theme/app_themes.dart';
import 'injection_container.dart';

/// Root application widget for Pictogram.
///
/// This widget serves as the entry point of the application and configures:
/// - Theme management through Provider + GetIt
/// - MaterialApp with theme support
/// - Initial routing and navigation
///
/// Dependencies are resolved from the GetIt service locator.
/// The ThemeProvider should be initialized and loaded in main.dart before
/// creating this widget to prevent theme flickering.
class PictogramApp extends StatelessWidget {
  const PictogramApp({super.key});
>>>>>>> 0f08bfdbc2f765d0c6845182c19823b43610e65e

class MyApp extends StatefulWidget {
  @override
<<<<<<< HEAD
  State<MyApp> createState() => _MyAppState();
=======
  Widget build(BuildContext context) {
    // Retrieve ThemeProvider from the service locator
    // It was initialized and loaded in main.dart
    final themeProvider = sl<ThemeProvider>();

    // ChangeNotifierProvider makes ThemeProvider available throughout the widget tree
    // Using .value constructor since we're passing an existing instance from GetIt
    return ChangeNotifierProvider<ThemeProvider>.value(
      value: themeProvider,

      // Consumer rebuilds only when ThemeProvider notifies listeners
      // This is efficient because only MaterialApp rebuilds, not the entire Provider tree
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            // Application title (shown in task switcher on some platforms)
            title: 'Pictogram',

            // Disable the debug banner in the top-right corner
            debugShowCheckedModeBanner: false,

            // Light theme - used when themeMode is light or system (in light mode)
            theme: themeProvider.currentTheme,

            // Dark theme - used when themeMode is dark or system (in dark mode)
            darkTheme: themeProvider.currentDarkTheme,

            // Current theme mode (light, dark, or system)
            // MaterialApp automatically switches between theme and darkTheme based on this
            themeMode: themeProvider.themeMode,

            // Initial route - currently showing temporary MainScreen
            // This will be replaced with proper routing in Phase 2
            home: const EditorPage(),
          );
        },
      ),
    );
  }
>>>>>>> 0f08bfdbc2f765d0c6845182c19823b43610e65e
}

class _MyAppState extends State<MyApp> {
  final FocusNode focusNode = FocusNode();
  late KeyboardHandler keyboardHandler;

  // Example: selected image data would come from your app's state / provider
  Uint8List? selectedImageBytes;
  String? selectedFilename;
  bool menuVisible = true;

  @override
  void initState() {
    super.initState();
    keyboardHandler = KeyboardHandler(
      context,
      onNext: onNext,
      onPrev: onPrev,
      onRotateLeft: onRotateLeft,
      onRotateRight: onRotateRight,
      onFlipHorizontal: onFlipH,
      onFlipVertical: onFlipV,
      onZoomIn: onZoomIn,
      onZoomOut: onZoomOut,
      onZoomReset: onZoomReset,
      onFullscreenToggle: onFullscreen,
      onToggleMenu: toggleMenu,
      onCloseDialog: closeDialog,
    );
    // you may want to set initial selected data if available
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKey: handleRawKeyEvent,
      child: MaterialApp(
        title: 'Pictogram Web',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Pictogram (Web)'),
            actions: [
              // add toolbar widget (we will create a Toolbar widget later)
            ],
          ),
          body: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        if (menuVisible) exampleToolbar(),
        Expanded(
          child: Center(
            child: Text('Aquí va tu UI (lista/galería de imágenes).'),
          ),
        ),
      ],
    );
  }

  Widget exampleToolbar() {
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

 void handleRawKeyEvent(RawKeyEvent event) {
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
      if (keySetsEqual(entry.value, pressedSet)) {
        keyboardHandler.selectedImageBytes = selectedImageBytes;
        keyboardHandler.selectedFilename = selectedFilename;
        keyboardHandler.handleAction(entry.key);
        break;
      }
    }
  }
}


  bool keySetsEqual(LogicalKeySet a, LogicalKeySet b) {
    final as = a.keys.toSet();
    final bs = b.keys.toSet();
    return as.length == bs.length && as.containsAll(bs);
  }

  // Example stub handlers - replace with your real logic
  void onNext() => show('Siguiente imagen');
  void onPrev() => show('Imagen anterior');
  void onRotateLeft() => show('Rotar izquierda');
  void onRotateRight() => show('Rotar derecha');
  void onFlipH() => show('Flip horizontal');
  void onFlipV() => show('Flip vertical');
  void onZoomIn() => show('Zoom +');
  void onZoomOut() => show('Zoom -');
  void onZoomReset() => show('Reset zoom');
  void onFullscreen() => show('Toggle fullscreen');
  void toggleMenu() => setState(() => menuVisible = !menuVisible);
  void closeDialog() => Navigator.of(context, rootNavigator: true).maybePop();

  void show(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s), duration: Duration(milliseconds: 600)));
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}
