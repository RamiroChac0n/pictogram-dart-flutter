import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_themes.dart';
import '../../core/theme/theme_provider.dart';

/// Settings page for theme customization
///
/// Allows users to:
/// - Select theme mode (Light/Dark/System)
/// - Choose between 5 color themes
/// - Preview theme in real-time
/// - Reset to default settings
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ Configuración'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Theme mode section (Light/Dark/System)
              _buildThemeModeSection(context),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 32),

              // Color theme selection
              _buildColorThemeSection(context),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 32),

              // Preview section
              _buildPreviewSection(context),
              const SizedBox(height: 32),

              // Reset button
              _buildResetButton(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the theme mode selector section (Light/Dark/System)
  Widget _buildThemeModeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Modo de Tema',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Selecciona cómo quieres que se vea la aplicación',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('Claro'),
                  icon: Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('Oscuro'),
                  icon: Icon(Icons.dark_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('Sistema'),
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
          'Color del Tema',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Elige el esquema de colores de tu preferencia',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
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
          'Vista Previa',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Así se verá tu tema seleccionado',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Buttons preview
                Text(
                  'Botones',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Elevado'),
                    ),
                    FilledButton(
                      onPressed: () {},
                      child: const Text('Relleno'),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Contorno'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Texto'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Color swatches
                Text(
                  'Paleta de Colores',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _ColorSwatch(
                      color: colorScheme.primary,
                      label: 'Primario',
                    ),
                    _ColorSwatch(
                      color: colorScheme.secondary,
                      label: 'Secundario',
                    ),
                    _ColorSwatch(
                      color: colorScheme.tertiary,
                      label: 'Terciario',
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
              content: Text('✅ Tema restablecido a valores por defecto'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        icon: const Icon(Icons.refresh),
        label: const Text('Restablecer a Predeterminado'),
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

    return SizedBox(
      width: 150,
      height: 110,
      child: Card(
        elevation: isSelected ? 6 : 2,
        color: seedColor,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              // Gradient overlay for better text visibility
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),

              // Theme name
              Positioned(
                left: 12,
                bottom: 12,
                right: 12,
                child: Text(
                  themeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(0, 1),
                        blurRadius: 3,
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
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
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
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
