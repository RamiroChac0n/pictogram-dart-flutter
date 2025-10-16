/// Example Theme Settings Page
///
/// This file demonstrates how to create a theme settings UI using
/// the Pictogram theme system. You can use this as a reference or
/// starting point for your own settings implementation.
///
/// This is an example file and can be customized to fit your app's
/// design and requirements.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_themes.dart';
import 'theme_provider.dart';

/// Example settings page showing theme selection UI
class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme mode section (Light/Dark/System)
          _buildThemeModeSection(context),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Color theme selection
          _buildColorThemeSection(context),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Preview section
          _buildPreviewSection(context),
          const SizedBox(height: 24),

          // Reset button
          _buildResetButton(context),
        ],
      ),
    );
  }

  /// Builds the theme mode selector section (Light/Dark/System)
  Widget _buildThemeModeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Brightness',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Light'),
                  icon: Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Dark'),
                  icon: Icon(Icons.dark_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('System'),
                  icon: Icon(Icons.brightness_auto),
                ),
              ],
              selected: {themeProvider.themeMode},
              onSelectionChanged: (Set<ThemeMode> selection) {
                themeProvider.setThemeMode(selection.first);
              },
            );
          },
        ),
      ],
    );
  }

  /// Builds the color theme selection section with cards
  Widget _buildColorThemeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color Theme',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ThemeProvider.availableThemes.map((themeType) {
                return _ThemeColorCard(
                  themeType: themeType,
                  isSelected: themeProvider.currentThemeType == themeType,
                  onTap: () => themeProvider.setTheme(themeType),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  /// Builds a preview section showing current theme colors
  Widget _buildPreviewSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preview',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Buttons preview
                Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Elevated'),
                  ),
                  FilledButton(
                    onPressed: () {},
                    child: const Text('Filled'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Outlined'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Text'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Color swatches
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ColorSwatch(
                    color: colorScheme.primary,
                    label: 'Primary',
                  ),
                  _ColorSwatch(
                    color: colorScheme.secondary,
                    label: 'Secondary',
                  ),
                  _ColorSwatch(
                    color: colorScheme.tertiary,
                    label: 'Tertiary',
                  ),
                  _ColorSwatch(
                    color: colorScheme.error,
                    label: 'Error',
                  ),
                ],
              ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the reset button
  Widget _buildResetButton(BuildContext context) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: () {
          context.read<ThemeProvider>().resetTheme();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Theme reset to default'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(Icons.refresh),
        label: const Text('Reset to Default'),
      ),
    );
  }
}

/// Widget representing a selectable theme color card
class _ThemeColorCard extends StatelessWidget {
  final AppThemeType themeType;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeColorCard({
    required this.themeType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeName = AppThemes.getThemeName(themeType);
    final seedColor = AppThemes.getTheme(themeType).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 140,
      height: 100,
      child: Card(
        elevation: isSelected ? 4 : 1,
        color: seedColor,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              // Theme name
              Positioned(
                left: 12,
                bottom: 12,
                right: 12,
                child: Text(
                  themeName,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),

              // Selection indicator
              if (isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check,
                      color: seedColor,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget showing a color swatch with label
class _ColorSwatch extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorSwatch({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
