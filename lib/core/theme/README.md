# Theme System Documentation

## Overview

The Pictogram theme system provides a comprehensive, accessible, and user-friendly theming solution built on Material Design 3 principles. It includes 5 distinct color variants, support for light/dark modes, and persistent theme preferences.

## Features

- **5 Color Variants**: Default Purple, Blue Gray, Gray, Teal, and Yellow
- **Material Design 3**: Built with the latest Material Design guidelines
- **Light & Dark Modes**: Full support for both brightness modes
- **Persistent Storage**: Theme preferences saved using SharedPreferences
- **Reactive Updates**: Uses Provider pattern for efficient rebuilds
- **Accessibility**: WCAG AA compliant contrast ratios, minimum touch targets
- **Web Optimized**: Hover states, proper touch targets, keyboard support

## Files

### `app_themes.dart`
Defines the theme configurations for all 5 color variants. Each theme includes:
- ColorScheme generated from seed colors
- AppBar with centered titles
- Button themes (Elevated, Text, Outlined, Icon)
- Icon and Tooltip themes with extended durations
- Form input theming
- Navigation components (Rail, Bottom Bar)
- Dialog, Card, and Snackbar themes
- Accessibility-compliant configurations

### `theme_provider.dart`
Manages theme state using the Provider pattern:
- Current theme type selection
- Dark/light/system mode toggle
- Persistent storage with SharedPreferences
- Loading saved preferences on app start
- Methods to change themes and modes

### `theme.dart`
Barrel file for convenient imports

## Integration Guide

### Step 1: Initialize Theme Provider

Update your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize theme provider and load saved preferences
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: const PictogramApp(),
    ),
  );
}
```

### Step 2: Configure MaterialApp

```dart
class PictogramApp extends StatelessWidget {
  const PictogramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Pictogram',
          theme: themeProvider.currentTheme,
          darkTheme: themeProvider.currentDarkTheme,
          themeMode: themeProvider.themeMode,
          home: const HomePage(),
        );
      },
    );
  }
}
```

### Step 3: Create Theme Selector UI

#### Option A: Dropdown Menu

```dart
DropdownButton<AppThemeType>(
  value: context.watch<ThemeProvider>().currentThemeType,
  items: ThemeProvider.themeNamesMap.entries.map((entry) {
    return DropdownMenuItem(
      value: entry.key,
      child: Text(entry.value),
    );
  }).toList(),
  onChanged: (theme) {
    if (theme != null) {
      context.read<ThemeProvider>().setTheme(theme);
    }
  },
)
```

#### Option B: List Selection

```dart
ListView.builder(
  itemCount: ThemeProvider.availableThemes.length,
  itemBuilder: (context, index) {
    final themeType = ThemeProvider.availableThemes[index];
    final themeName = AppThemes.getThemeName(themeType);
    final isSelected = context.watch<ThemeProvider>().currentThemeType == themeType;

    return ListTile(
      title: Text(themeName),
      trailing: isSelected ? const Icon(Icons.check) : null,
      selected: isSelected,
      onTap: () {
        context.read<ThemeProvider>().setTheme(themeType);
      },
    );
  },
)
```

#### Option C: Grid of Color Cards

```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    childAspectRatio: 1.5,
  ),
  itemCount: ThemeProvider.availableThemes.length,
  itemBuilder: (context, index) {
    final themeType = ThemeProvider.availableThemes[index];
    final themeName = AppThemes.getThemeName(themeType);
    final seedColor = AppThemes.getTheme(themeType).colorScheme.primary;
    final isSelected = context.watch<ThemeProvider>().currentThemeType == themeType;

    return Card(
      color: seedColor,
      child: InkWell(
        onTap: () {
          context.read<ThemeProvider>().setTheme(themeType);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              themeName,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  },
)
```

### Step 4: Add Dark Mode Toggle

```dart
// Icon button toggle
IconButton(
  icon: Icon(
    context.watch<ThemeProvider>().themeMode == ThemeMode.dark
        ? Icons.light_mode
        : Icons.dark_mode,
  ),
  onPressed: () {
    context.read<ThemeProvider>().toggleThemeMode();
  },
  tooltip: 'Toggle dark mode',
)

// Or a switch
Switch(
  value: context.watch<ThemeProvider>().themeMode == ThemeMode.dark,
  onChanged: (isDark) {
    context.read<ThemeProvider>().setThemeMode(
      isDark ? ThemeMode.dark : ThemeMode.light,
    );
  },
)
```

## Theme Variants

### Default Purple (defaultTheme)
- **Seed Color**: `#6750A4`
- **Character**: Professional, modern, creative
- **Best For**: Default choice, creative applications

### Blue Gray (blueGray)
- **Seed Color**: `#546E7A`
- **Character**: Calm, sophisticated, neutral
- **Best For**: Professional tools, data visualization

### Gray (gray)
- **Seed Color**: `#616161`
- **Character**: Minimalist, elegant, timeless
- **Best For**: Content-focused applications, reading apps

### Teal (teal)
- **Seed Color**: `#00897B`
- **Character**: Fresh, energetic, modern
- **Best For**: Health apps, environmental themes

### Yellow (yellow)
- **Seed Color**: `#F9A825`
- **Character**: Warm, optimistic, cheerful
- **Best For**: Educational apps, creative tools

## Accessibility Features

All themes include:

1. **Color Contrast**: WCAG AA compliant contrast ratios
2. **Touch Targets**: Minimum 48x48dp for all interactive elements
3. **Text Sizing**: Supports dynamic text sizing
4. **Semantic Labels**: Proper labeling for screen readers
5. **Keyboard Support**: Full keyboard navigation support
6. **Tooltip Duration**: Extended duration (800ms) for better discoverability

## Advanced Usage

### Accessing Current Theme

```dart
// Get theme data
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;

// Get theme provider
final themeProvider = context.read<ThemeProvider>();
final currentType = themeProvider.currentThemeType;
```

### Custom Theme Colors

```dart
// Primary colors
Container(color: theme.colorScheme.primary)
Text('Primary', style: TextStyle(color: theme.colorScheme.onPrimary))

// Secondary colors
Container(color: theme.colorScheme.secondary)
Text('Secondary', style: TextStyle(color: theme.colorScheme.onSecondary))

// Surface colors
Container(color: theme.colorScheme.surface)
Text('Surface', style: TextStyle(color: theme.colorScheme.onSurface))

// Error colors
Container(color: theme.colorScheme.error)
Text('Error', style: TextStyle(color: theme.colorScheme.onError))
```

### Reset to Default

```dart
ElevatedButton(
  onPressed: () {
    context.read<ThemeProvider>().resetTheme();
  },
  child: const Text('Reset to Default Theme'),
)
```

## Best Practices

1. **Use Provider**: Always access theme state through Provider for reactivity
2. **Semantic Colors**: Use semantic color names (primary, surface) instead of color values
3. **Theme Consistency**: Apply theme colors consistently across your app
4. **Test All Themes**: Verify your UI works with all 5 theme variants
5. **Dark Mode**: Always test both light and dark modes
6. **Accessibility**: Ensure custom widgets maintain accessibility standards

## Testing

```dart
// Test theme changes
testWidgets('Theme changes update UI', (tester) async {
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: const MyApp(),
    ),
  );

  // Change theme
  themeProvider.setTheme(AppThemeType.teal);
  await tester.pump();

  // Verify theme changed
  expect(themeProvider.currentThemeType, AppThemeType.teal);
});
```

## Troubleshooting

### Theme not persisting
- Ensure `WidgetsFlutterBinding.ensureInitialized()` is called before `loadTheme()`
- Check SharedPreferences permissions
- Verify await on `loadTheme()` before runApp

### Colors not updating
- Use `Consumer<ThemeProvider>` or `context.watch<ThemeProvider>()`
- Don't use `context.read()` in build methods
- Ensure Provider is above MaterialApp in widget tree

### Performance issues
- Use `Consumer` for selective rebuilds
- Consider using `context.select()` for specific values
- Avoid rebuilding entire app tree unnecessarily

## Future Enhancements

Potential improvements:
- Custom color picker for user-defined themes
- Theme preview before applying
- Import/export theme configurations
- High contrast mode for accessibility
- Theme scheduling (auto-switch based on time)
