/// Main Application Widget for Pictogram
///
/// This file contains the root application widget that configures the entire app,
/// including theme management, routing, and the Provider dependency injection.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'core/theme/theme_provider.dart';
import 'core/theme/app_themes.dart';
import 'core/constants/keyboard_shortcuts.dart';
import 'injection_container.dart';
import 'presentation/editor/editor_page.dart';

// ============================================================================
// CLASES NECESARIAS PARA GESTIONAR KEYBOARD SHORTCUTS
// ============================================================================

class SimpleIntent extends Intent {
  const SimpleIntent(this.keys);
  final LogicalKeySet keys;
}

// ============================================================================
// WIDGET PRINCIPAL: PictogramApp (CORREGIDO Y ESTABLE)
// ============================================================================

/// Root application widget for Pictogram.
class PictogramApp extends StatelessWidget {
  const PictogramApp({super.key});

  /// Crea el mapa de LogicalKeySet a Intent.
  Map<LogicalKeySet, Intent> _buildGlobalShortcuts() {
    return {
      // Usamos el mapa de shortcuts sin 'const'
      KeyboardShortcuts.previousImageKeys: SimpleIntent(KeyboardShortcuts.previousImageKeys),
      KeyboardShortcuts.nextImageKeys: SimpleIntent(KeyboardShortcuts.nextImageKeys),
      KeyboardShortcuts.rotateClockwiseKeys: SimpleIntent(KeyboardShortcuts.rotateClockwiseKeys),
      KeyboardShortcuts.rotateCounterClockwiseKeys: SimpleIntent(KeyboardShortcuts.rotateCounterClockwiseKeys),
      KeyboardShortcuts.flipHorizontalKeys: SimpleIntent(KeyboardShortcuts.flipHorizontalKeys),
      KeyboardShortcuts.flipVerticalKeys: SimpleIntent(KeyboardShortcuts.flipVerticalKeys),
      KeyboardShortcuts.openFilesKeys: SimpleIntent(KeyboardShortcuts.openFilesKeys),
      KeyboardShortcuts.downloadKeys: SimpleIntent(KeyboardShortcuts.downloadKeys),
      KeyboardShortcuts.copyKeys: SimpleIntent(KeyboardShortcuts.copyKeys),
      KeyboardShortcuts.printKeys: SimpleIntent(KeyboardShortcuts.printKeys),
      KeyboardShortcuts.zoomInKeys: SimpleIntent(KeyboardShortcuts.zoomInKeys),
      KeyboardShortcuts.zoomOutKeys: SimpleIntent(KeyboardShortcuts.zoomOutKeys),
      KeyboardShortcuts.zoomResetKeys: SimpleIntent(KeyboardShortcuts.zoomResetKeys),
      KeyboardShortcuts.fitToScreenKeys: SimpleIntent(KeyboardShortcuts.fitToScreenKeys),
      KeyboardShortcuts.toggleFullscreenKeys: SimpleIntent(KeyboardShortcuts.toggleFullscreenKeys),
      KeyboardShortcuts.toggleMenuKeys: SimpleIntent(KeyboardShortcuts.toggleMenuKeys),
      KeyboardShortcuts.closeDialogKeys: SimpleIntent(KeyboardShortcuts.closeDialogKeys),
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = sl<ThemeProvider>();

    return ChangeNotifierProvider<ThemeProvider>.value(
      value: themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          
          return MaterialApp(
            title: 'Pictogram',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            darkTheme: themeProvider.currentDarkTheme,
            themeMode: themeProvider.themeMode,
            
            // 🎯 CORRECCIÓN CLAVE: Cambiado 'child:' a 'home:'.
            home: FocusScope(
              autofocus: true, // Pide el foco al navegador
              child: Shortcuts(
                shortcuts: _buildGlobalShortcuts(),
                child: Actions(
                  actions: <Type, Action<Intent>>{
                    SimpleIntent: CallbackAction<SimpleIntent>(
                      onInvoke: (SimpleIntent intent) {
                        return Actions.maybeInvoke(context, intent) ?? false;
                      },
                    ),
                  },
                  child: const EditorPage(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// WIDGET TEMPORAL: MainScreen (Se mantiene inalterado)
// ============================================================================

/// Temporary main screen placeholder for Phase 1.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme for styling
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      // AppBar with the app name
      appBar: AppBar(
        title: const Text('Pictogram'),

        // Theme mode toggle button in the app bar
        actions: [
          // Show current theme mode icon
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.light
                  ? Icons.light_mode
                  : themeProvider.themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.brightness_auto,
            ),
            tooltip: 'Toggle theme mode',
            onPressed: () {
              // Cycle through theme modes: system -> light -> dark -> system
              switch (themeProvider.themeMode) {
                case ThemeMode.system:
                  themeProvider.setThemeMode(ThemeMode.light);
                  break;
                case ThemeMode.light:
                  themeProvider.setThemeMode(ThemeMode.dark);
                  break;
                case ThemeMode.dark:
                  themeProvider.setThemeMode(ThemeMode.system);
                  break;
              }
            },
          ),
        ],
      ),

      // Main content area
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome icon
              Icon(
                Icons.image_outlined,
                size: 80,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(height: 24),

              // Welcome message
              Text(
                'Welcome to Pictogram',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Instructions
              Text(
                'Drop images here or click to upload',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                '(Image viewer will be implemented in Phase 2)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Theme selection card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section title
                      Text(
                        'Theme Settings',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Theme color selector
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Theme Color:',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Dropdown for theme selection
                          DropdownButton<AppThemeType>(
                            value: themeProvider.currentThemeType,
                            items: AppThemeType.values.map((themeType) {
                              return DropdownMenuItem(
                                value: themeType,
                                child: Text(AppThemes.getThemeName(themeType)),
                              );
                            }).toList(),
                            onChanged: (AppThemeType? newTheme) {
                              if (newTheme != null) {
                                context.read<ThemeProvider>().setTheme(newTheme);
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Theme mode information
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Theme Mode:',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Display current theme mode
                          Text(
                            _getThemeModeName(themeProvider.themeMode),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Helper text
                      Text(
                        'Use the icon in the app bar to toggle between light, dark, and system theme modes.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Test button to verify theme is working
              ElevatedButton.icon(
                onPressed: () {
                  // Show a snackbar to test Material components with current theme
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Theme: ${themeProvider.currentThemeName} '
                        '(${_getThemeModeName(themeProvider.themeMode)})',
                      ),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.palette),
                label: const Text('Test Theme'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to get a human-readable theme mode name
  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
}