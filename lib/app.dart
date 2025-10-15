/// Main Application Widget for Pictogram
///
/// This file contains the root application widget that configures the entire app,
/// including theme management, routing, and the Provider dependency injection.
///
/// Architecture Overview:
/// - Uses the Provider pattern for state management (specifically ChangeNotifierProvider)
/// - ThemeProvider is injected at the root level to enable theme changes throughout the app
/// - Consumer widget is used to reactively rebuild when theme changes occur
/// - MaterialApp is configured with light/dark themes and theme mode support
///
/// Key Components:
/// 1. PictogramApp: The root application widget that sets up the Provider and MaterialApp
/// 2. MainScreen: A temporary placeholder home screen for testing (Phase 1)
///    - Will be replaced with the actual viewer implementation in Phase 2
///    - Currently provides basic UI to test theme switching functionality
///
/// Provider Pattern Explained:
/// - ChangeNotifierProvider creates and provides a ThemeProvider instance to the widget tree
/// - ThemeProvider extends ChangeNotifier, which allows it to notify listeners of changes
/// - Consumer<ThemeProvider> listens to ThemeProvider changes and rebuilds when notified
/// - This creates a reactive system: when theme changes, the UI automatically updates
///
/// Why Consumer is Necessary:
/// - MaterialApp needs to rebuild when theme settings change
/// - Consumer provides efficient, targeted rebuilds only when ThemeProvider notifies
/// - Without Consumer, theme changes wouldn't trigger MaterialApp to rebuild
/// - Alternative approaches (Provider.of with listen: true) would work but Consumer is clearer
///
/// Dependency Injection Integration:
/// - Uses GetIt service locator for dependency management
/// - ThemeProvider is registered in injection_container.dart
/// - Retrieved via sl<ThemeProvider>() from the service locator
///
/// Usage:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Initialize all dependencies (including ThemeProvider)
///   await init();
///
///   runApp(const PictogramApp());
/// }
/// ```
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/theme_provider.dart';
import 'core/navigation/app_router.dart';
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

  @override
  Widget build(BuildContext context) {
    // Retrieve ThemeProvider from the service locator
    // It was initialized and loaded in main.dart
    final themeProvider = sl<ThemeProvider>();

    // ChangeNotifierProvider makes ThemeProvider available throughout the widget tree
    // Using .value constructor since we're passing an existing instance from GetIt
    return ChangeNotifierProvider<ThemeProvider>.value(
      value: themeProvider,

      // Consumer rebuilds only when ThemeProvider notifies listeners
      // This is efficient because only MaterialApp.router rebuilds, not the entire Provider tree
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
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

            // Router configuration using GoRouter
            // Handles all navigation, deep linking, and routing logic
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}

/// Temporary main screen placeholder for Phase 1.
///
/// This screen serves as a basic home page to test the application setup
/// and verify that the theme system is working correctly.
///
/// Features:
/// - AppBar with app title
/// - Welcome message
/// - Theme selection dropdown for testing
/// - Theme mode toggle for testing dark/light mode
/// - Upload instructions placeholder
///
/// This widget will be completely replaced in Phase 2 when we implement
/// the actual image viewer with proper layout and functionality.
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
