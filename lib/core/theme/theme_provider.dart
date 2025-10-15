/// Theme Provider for Pictogram App
///
/// This file implements the theme management system using the Provider pattern.
/// It handles theme selection, persistence, and state management across the application.
///
/// Key features:
/// - Persistent theme storage using SharedPreferences
/// - Automatic theme loading on app initialization
/// - Reactive theme updates that rebuild the UI when themes change
/// - Support for both light and dark theme modes
///
/// Usage:
/// ```dart
/// // In main.dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   final themeProvider = ThemeProvider();
///   await themeProvider.loadTheme();
///
///   runApp(
///     ChangeNotifierProvider.value(
///       value: themeProvider,
///       child: MyApp(),
///     ),
///   );
/// }
///
/// // In MaterialApp
/// Consumer<ThemeProvider>(
///   builder: (context, themeProvider, child) {
///     return MaterialApp(
///       theme: themeProvider.currentTheme,
///       darkTheme: themeProvider.currentDarkTheme,
///       themeMode: themeProvider.themeMode,
///     );
///   },
/// )
///
/// // To change theme
/// context.read<ThemeProvider>().setTheme(AppThemeType.teal);
///
/// // To toggle dark mode
/// context.read<ThemeProvider>().setThemeMode(ThemeMode.dark);
/// ```

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_themes.dart';

/// Provider class that manages the application's theme state.
///
/// This class extends [ChangeNotifier] to provide reactive updates
/// to widgets that depend on theme changes. It handles:
/// - Current theme type selection
/// - Dark/light mode toggle
/// - Theme persistence across app sessions
/// - Initialization and loading of saved preferences
class ThemeProvider extends ChangeNotifier {
  /// The currently selected theme type
  AppThemeType _currentThemeType = AppThemeType.defaultTheme;

  /// The current theme mode (light/dark/system)
  ThemeMode _themeMode = ThemeMode.system;

  /// Flag to track if the theme has been initialized
  bool _isInitialized = false;

  /// SharedPreferences keys for persistent storage
  static const String _themeTypeKey = 'theme_type';
  static const String _themeModeKey = 'theme_mode';

  /// Creates a new [ThemeProvider] instance.
  ///
  /// Note: Call [loadTheme] after construction to load saved preferences
  ThemeProvider();

  /// Gets the current theme type
  AppThemeType get currentThemeType => _currentThemeType;

  /// Gets the current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Gets whether the provider has been initialized
  bool get isInitialized => _isInitialized;

  /// Returns the current light theme based on the selected theme type
  ThemeData get currentTheme => AppThemes.getTheme(_currentThemeType);

  /// Returns the current dark theme based on the selected theme type
  ThemeData get currentDarkTheme => AppThemes.getDarkTheme(_currentThemeType);

  /// Gets the human-readable name of the current theme
  String get currentThemeName => AppThemes.getThemeName(_currentThemeType);

  /// Determines if dark mode is currently active
  ///
  /// This considers both the theme mode setting and system preferences
  /// when [ThemeMode.system] is selected.
  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.dark) return true;
    if (_themeMode == ThemeMode.light) return false;
    // ThemeMode.system
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  /// Loads the saved theme preferences from persistent storage.
  ///
  /// This method should be called during app initialization, before
  /// the widget tree is built. It reads the saved theme type and mode
  /// from SharedPreferences and updates the provider state.
  ///
  /// Example:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   final themeProvider = ThemeProvider();
  ///   await themeProvider.loadTheme();
  ///   runApp(MyApp(themeProvider: themeProvider));
  /// }
  /// ```
  ///
  /// Returns:
  ///   A [Future] that completes when the theme has been loaded
  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load theme type
      final themeTypeString = prefs.getString(_themeTypeKey);
      if (themeTypeString != null) {
        _currentThemeType = AppThemeType.values.firstWhere(
          (type) => type.name == themeTypeString,
          orElse: () => AppThemeType.defaultTheme,
        );
      }

      // Load theme mode
      final themeModeString = prefs.getString(_themeModeKey);
      if (themeModeString != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.name == themeModeString,
          orElse: () => ThemeMode.system,
        );
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // If loading fails, use default values
      debugPrint('Error loading theme preferences: $e');
      _currentThemeType = AppThemeType.defaultTheme;
      _themeMode = ThemeMode.system;
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Changes the current theme type and persists the selection.
  ///
  /// This method updates the theme type, saves it to SharedPreferences,
  /// and notifies all listening widgets to rebuild with the new theme.
  ///
  /// Parameters:
  ///   - [themeType]: The new theme type to apply
  ///
  /// Example:
  /// ```dart
  /// // From within a widget with access to context
  /// context.read<ThemeProvider>().setTheme(AppThemeType.teal);
  ///
  /// // Or using Provider.of
  /// Provider.of<ThemeProvider>(context, listen: false)
  ///   .setTheme(AppThemeType.blueGray);
  /// ```
  Future<void> setTheme(AppThemeType themeType) async {
    if (_currentThemeType == themeType) return;

    _currentThemeType = themeType;
    notifyListeners();

    // Persist the selection
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeTypeKey, themeType.name);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  /// Changes the theme mode (light/dark/system) and persists the selection.
  ///
  /// This method updates the theme mode, saves it to SharedPreferences,
  /// and notifies all listening widgets to rebuild.
  ///
  /// Parameters:
  ///   - [mode]: The new theme mode to apply
  ///
  /// Example:
  /// ```dart
  /// // Switch to dark mode
  /// context.read<ThemeProvider>().setThemeMode(ThemeMode.dark);
  ///
  /// // Switch to light mode
  /// context.read<ThemeProvider>().setThemeMode(ThemeMode.light);
  ///
  /// // Use system preference
  /// context.read<ThemeProvider>().setThemeMode(ThemeMode.system);
  /// ```
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    // Persist the selection
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeModeKey, mode.name);
    } catch (e) {
      debugPrint('Error saving theme mode preference: $e');
    }
  }

  /// Toggles between light and dark modes.
  ///
  /// If currently in system mode, switches to light mode.
  /// If in light mode, switches to dark mode.
  /// If in dark mode, switches to light mode.
  ///
  /// This is a convenience method for implementing theme toggle buttons.
  ///
  /// Example:
  /// ```dart
  /// IconButton(
  ///   icon: Icon(Icons.brightness_6),
  ///   onPressed: () {
  ///     context.read<ThemeProvider>().toggleThemeMode();
  ///   },
  /// )
  /// ```
  void toggleThemeMode() {
    switch (_themeMode) {
      case ThemeMode.system:
      case ThemeMode.dark:
        setThemeMode(ThemeMode.light);
        break;
      case ThemeMode.light:
        setThemeMode(ThemeMode.dark);
        break;
    }
  }

  /// Resets the theme to default settings.
  ///
  /// This sets the theme type to [AppThemeType.defaultTheme] and
  /// the theme mode to [ThemeMode.system], then persists these changes.
  ///
  /// Useful for providing a "Reset to Default" option in settings.
  ///
  /// Example:
  /// ```dart
  /// TextButton(
  ///   onPressed: () {
  ///     context.read<ThemeProvider>().resetTheme();
  ///   },
  ///   child: Text('Reset to Default'),
  /// )
  /// ```
  Future<void> resetTheme() async {
    _currentThemeType = AppThemeType.defaultTheme;
    _themeMode = ThemeMode.system;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeTypeKey, AppThemeType.defaultTheme.name);
      await prefs.setString(_themeModeKey, ThemeMode.system.name);
    } catch (e) {
      debugPrint('Error resetting theme preferences: $e');
    }
  }

  /// Returns a list of all available theme types.
  ///
  /// Useful for building theme selection UI, such as a list or grid
  /// of theme options.
  ///
  /// Example:
  /// ```dart
  /// ListView.builder(
  ///   itemCount: ThemeProvider.availableThemes.length,
  ///   itemBuilder: (context, index) {
  ///     final themeType = ThemeProvider.availableThemes[index];
  ///     return ListTile(
  ///       title: Text(AppThemes.getThemeName(themeType)),
  ///       onTap: () {
  ///         context.read<ThemeProvider>().setTheme(themeType);
  ///       },
  ///     );
  ///   },
  /// )
  /// ```
  static List<AppThemeType> get availableThemes => AppThemeType.values;

  /// Returns a map of theme types to their display names.
  ///
  /// Convenient for building theme selection dropdowns or other UI elements
  /// that need both the theme type and its human-readable name.
  ///
  /// Example:
  /// ```dart
  /// DropdownButton<AppThemeType>(
  ///   value: context.watch<ThemeProvider>().currentThemeType,
  ///   items: ThemeProvider.themeNamesMap.entries.map((entry) {
  ///     return DropdownMenuItem(
  ///       value: entry.key,
  ///       child: Text(entry.value),
  ///     );
  ///   }).toList(),
  ///   onChanged: (theme) {
  ///     if (theme != null) {
  ///       context.read<ThemeProvider>().setTheme(theme);
  ///     }
  ///   },
  /// )
  /// ```
  static Map<AppThemeType, String> get themeNamesMap {
    return {
      for (var type in AppThemeType.values) type: AppThemes.getThemeName(type)
    };
  }

  /// Clears all saved theme preferences from persistent storage.
  ///
  /// This removes the stored theme type and mode but does not reset
  /// the current in-memory values. Call [resetTheme] to also reset
  /// the current values.
  ///
  /// Primarily useful for testing or providing a complete app reset.
  Future<void> clearPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_themeTypeKey);
      await prefs.remove(_themeModeKey);
    } catch (e) {
      debugPrint('Error clearing theme preferences: $e');
    }
  }
}
