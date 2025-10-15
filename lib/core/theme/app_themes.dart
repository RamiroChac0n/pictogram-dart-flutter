/// Theme Configuration for Pictogram App
///
/// This file defines the comprehensive theme system for the Pictogram application,
/// implementing Material Design 3 principles with 5 distinct color variants.
///
/// Each theme includes:
/// - ColorScheme generated from a seed color for consistent color harmonies
/// - AppBar configuration with centered titles
/// - Button styles optimized for web and mobile interactions
/// - Icon and tooltip theming for enhanced usability
/// - Accessibility-compliant contrast ratios (WCAG AA)
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: AppThemes.getTheme(AppThemeType.defaultTheme),
///   darkTheme: AppThemes.getDarkTheme(AppThemeType.defaultTheme),
/// )
/// ```

import 'package:flutter/material.dart';

/// Enumeration of available theme variants for the application.
///
/// Each theme provides a distinct visual identity while maintaining
/// consistency with Material Design 3 principles.
enum AppThemeType {
  /// Default purple theme - Professional and modern
  defaultTheme,

  /// Blue-gray theme - Calm and sophisticated
  blueGray,

  /// Gray theme - Neutral and minimalist
  gray,

  /// Teal theme - Fresh and energetic
  teal,

  /// Yellow theme - Warm and optimistic
  yellow,
}

/// Utility class providing theme configurations for the Pictogram application.
///
/// This class contains static methods to generate light and dark theme variants
/// based on the selected [AppThemeType]. All themes follow Material Design 3
/// guidelines and ensure proper accessibility standards.
class AppThemes {
  // Private constructor to prevent instantiation
  AppThemes._();

  /// Returns a human-readable name for the given theme type.
  ///
  /// Useful for displaying theme options in settings UI.
  static String getThemeName(AppThemeType type) {
    switch (type) {
      case AppThemeType.defaultTheme:
        return 'Default Purple';
      case AppThemeType.blueGray:
        return 'Blue Gray';
      case AppThemeType.gray:
        return 'Gray';
      case AppThemeType.teal:
        return 'Teal';
      case AppThemeType.yellow:
        return 'Yellow';
    }
  }

  /// Returns the seed color for the specified theme type.
  ///
  /// The seed color is used to generate a complete Material Design 3 color scheme
  /// with harmonious color relationships across primary, secondary, and tertiary roles.
  static Color _getSeedColor(AppThemeType type) {
    switch (type) {
      case AppThemeType.defaultTheme:
        return const Color(0xFF6750A4); // Deep Purple
      case AppThemeType.blueGray:
        return const Color(0xFF546E7A); // Blue Gray
      case AppThemeType.gray:
        return const Color(0xFF616161); // Gray
      case AppThemeType.teal:
        return const Color(0xFF00897B); // Teal
      case AppThemeType.yellow:
        return const Color(0xFFF9A825); // Yellow
    }
  }

  /// Generates and returns a light theme for the specified theme type.
  ///
  /// The light theme uses bright surfaces with dark text, optimized for
  /// well-lit environments and reduced eye strain during daytime use.
  ///
  /// Parameters:
  ///   - [type]: The theme variant to generate
  ///
  /// Returns:
  ///   A fully configured [ThemeData] instance with Material Design 3 components
  static ThemeData getTheme(AppThemeType type) {
    final seedColor = _getSeedColor(type);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    return _buildTheme(colorScheme);
  }

  /// Generates and returns a dark theme for the specified theme type.
  ///
  /// The dark theme uses dark surfaces with light text, optimized for
  /// low-light environments and OLED displays. Reduces eye strain in
  /// dark environments and can save battery on OLED screens.
  ///
  /// Parameters:
  ///   - [type]: The theme variant to generate
  ///
  /// Returns:
  ///   A fully configured [ThemeData] instance with Material Design 3 dark mode
  static ThemeData getDarkTheme(AppThemeType type) {
    final seedColor = _getSeedColor(type);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    return _buildTheme(colorScheme);
  }

  /// Internal method to build a complete theme from a color scheme.
  ///
  /// This method configures all theme components consistently across
  /// both light and dark themes, ensuring a unified visual experience.
  ///
  /// Parameters:
  ///   - [colorScheme]: The Material Design 3 color scheme to apply
  ///
  /// Returns:
  ///   A fully configured [ThemeData] with all component themes applied
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // AppBar theme configuration
      // Centered titles provide visual balance, especially important for web layouts
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: 24,
        ),
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
      ),

      // Elevated button theme - Primary action buttons
      // Ensures touch targets meet minimum size requirements (48x48dp)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          shadowColor: colorScheme.shadow.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(64, 48), // Accessibility: minimum touch target
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ).copyWith(
          // Hover state for web interactions
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) {
              return colorScheme.primary.withOpacity(0.9);
            }
            if (states.contains(MaterialState.pressed)) {
              return colorScheme.primary.withOpacity(0.85);
            }
            if (states.contains(MaterialState.disabled)) {
              return colorScheme.onSurface.withOpacity(0.12);
            }
            return colorScheme.primary;
          }),
          elevation: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) {
              return 4;
            }
            if (states.contains(MaterialState.pressed)) {
              return 1;
            }
            if (states.contains(MaterialState.disabled)) {
              return 0;
            }
            return 2;
          }),
        ),
      ),

      // Text button theme - Secondary actions
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Outlined button theme - Tertiary actions
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Icon button theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(48, 48), // Accessibility: minimum touch target
          iconSize: 24,
          foregroundColor: colorScheme.onSurface,
        ),
      ),

      // Icon theme - Applied globally to all icons
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 24,
      ),

      // Tooltip theme
      // Extended wait duration provides better UX for keyboard shortcuts
      // and interactive elements that require explanation
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 800),
        showDuration: const Duration(seconds: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        textStyle: TextStyle(
          color: colorScheme.onInverseSurface,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),

      // Card theme - For content containers
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: colorScheme.shadow.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        margin: const EdgeInsets.all(8),
      ),

      // Input decoration theme - For text fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.6)),
      ),

      // Floating action button theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        deleteIconColor: colorScheme.onSurfaceVariant,
        disabledColor: colorScheme.onSurface.withOpacity(0.12),
        selectedColor: colorScheme.secondaryContainer,
        secondarySelectedColor: colorScheme.secondaryContainer,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 14,
        ),
        secondaryLabelStyle: TextStyle(
          color: colorScheme.onSecondaryContainer,
          fontSize: 14,
        ),
        brightness: colorScheme.brightness,
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        elevation: 6,
        shadowColor: colorScheme.shadow.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 16,
          height: 1.5,
        ),
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: colorScheme.onInverseSurface,
          fontSize: 14,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 6,
      ),

      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceVariant,
        circularTrackColor: colorScheme.surfaceVariant,
      ),

      // Navigation rail theme (for desktop layouts)
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        selectedIconTheme: IconThemeData(
          color: colorScheme.onSecondaryContainer,
          size: 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurfaceVariant,
          size: 24,
        ),
        selectedLabelTextStyle: TextStyle(
          color: colorScheme.onSecondaryContainer,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 14,
        ),
        indicatorColor: colorScheme.secondaryContainer,
        labelType: NavigationRailLabelType.selected,
      ),

      // Bottom navigation bar theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        elevation: 3,
        height: 80,
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return IconThemeData(
              color: colorScheme.onSecondaryContainer,
              size: 24,
            );
          }
          return IconThemeData(
            color: colorScheme.onSurfaceVariant,
            size: 24,
          );
        }),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return TextStyle(
              color: colorScheme.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            );
          }
          return TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
          );
        }),
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.outline;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surfaceVariant;
        }),
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(colorScheme.onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurfaceVariant;
        }),
      ),

      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceVariant,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withOpacity(0.12),
        valueIndicatorColor: colorScheme.primary,
        valueIndicatorTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 14,
        ),
      ),

      // Text selection theme
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withOpacity(0.3),
        selectionHandleColor: colorScheme.primary,
      ),

      // Visual density - Comfortable for web and desktop
      visualDensity: VisualDensity.standard,

      // Page transitions - Smooth animations
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
