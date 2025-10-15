# Theme System Integration Example

## Quick Start: Update main.dart

Replace your current `main.dart` with this implementation to integrate the theme system:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Create and initialize theme provider
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  runApp(
    // Provide theme state to entire app
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: const PictogramApp(),
    ),
  );
}

class PictogramApp extends StatelessWidget {
  const PictogramApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to theme changes and rebuild MaterialApp
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Pictogram',
          debugShowCheckedModeBanner: false,

          // Apply light theme
          theme: themeProvider.currentTheme,

          // Apply dark theme
          darkTheme: themeProvider.currentDarkTheme,

          // Control which theme to use
          themeMode: themeProvider.themeMode,

          // Your home page
          home: const HomePage(),
        );
      },
    );
  }
}

// Example home page with theme controls
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pictogram'),
        actions: [
          // Dark mode toggle button
          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleThemeMode();
            },
            tooltip: 'Toggle theme mode',
          ),

          // Settings button to access theme selector
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to theme settings
              // Navigator.push(context, MaterialPageRoute(
              //   builder: (_) => const ThemeSettingsPage(),
              // ));
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Pictogram',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),

            // Show current theme
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Text(
                  'Current Theme: ${themeProvider.currentThemeName}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),
            const SizedBox(height: 48),

            // Quick theme selector
            _buildQuickThemeSelector(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickThemeSelector(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: ThemeProvider.availableThemes.map((themeType) {
        final themeName = AppThemes.getThemeName(themeType);
        final seedColor = AppThemes.getTheme(themeType).colorScheme.primary;
        final isSelected = context.watch<ThemeProvider>().currentThemeType == themeType;

        return Tooltip(
          message: themeName,
          child: InkWell(
            onTap: () {
              context.read<ThemeProvider>().setTheme(themeType);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: seedColor,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 3,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    )
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
```

## What This Does

1. **Initializes Theme System**: Loads saved theme preferences before app starts
2. **Provides Theme State**: Makes theme state available throughout the app
3. **Reactive Updates**: UI automatically updates when theme changes
4. **Persistent Preferences**: Theme choices are saved and restored
5. **Demo Interface**: Shows theme name and quick color selector

## Next Steps

1. **Copy the code above** into your `main.dart`
2. **Run the app**: `flutter run -d chrome` (for web)
3. **Test themes**: Click on the colored squares to change themes
4. **Toggle dark mode**: Use the sun/moon icon in the app bar
5. **Verify persistence**: Close and reopen the app to see saved theme

## Adding to Existing App

If you already have content in your app, just:

1. Wrap your existing app with the Provider
2. Update MaterialApp with Consumer
3. Add theme controls where needed

## Using Theme Colors in Your Widgets

```dart
// In any widget, access theme colors:
final theme = Theme.of(context);
final colors = theme.colorScheme;

// Use semantic colors
Container(
  color: colors.primary,
  child: Text(
    'Primary Container',
    style: TextStyle(color: colors.onPrimary),
  ),
)

// Access theme-aware styles
Text(
  'Headline',
  style: theme.textTheme.headlineLarge,
)

// Use theme-aware components
ElevatedButton(
  onPressed: () {},
  child: const Text('Themed Button'),
)
```

## Troubleshooting

### Theme not loading
- Check that `WidgetsFlutterBinding.ensureInitialized()` is called
- Ensure `await themeProvider.loadTheme()` completes before runApp
- Verify SharedPreferences dependency in pubspec.yaml

### Colors not changing
- Make sure Consumer<ThemeProvider> wraps MaterialApp
- Use `context.watch<ThemeProvider>()` for reactive updates
- Don't use `context.read()` in build methods

### App crashes on start
- Add `async` to main function
- Add `await` before `themeProvider.loadTheme()`
- Check that Provider is properly imported

## Additional Resources

- See `example_theme_settings.dart` for full settings page example
- See `README.md` for complete documentation
- Check Material Design 3 guidelines: https://m3.material.io/
