/// Main entry point for the Pictogram application.
///
/// This file initializes the app, sets up dependency injection, and loads
/// the theme provider before launching the application widget tree.
///
/// Initialization sequence:
/// 1. Ensure Flutter bindings are initialized (required for async operations before runApp)
/// 2. Initialize the dependency injection container (registers all dependencies)
/// 3. Retrieve ThemeProvider from the service locator
/// 4. Load saved theme preferences from persistent storage
/// 5. Launch the app with the initialized theme provider
///
/// The async main function is necessary because we need to load user preferences
/// before building the widget tree to avoid theme flickering on startup.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pictogram_dart_flutter/core/bloc/gallery_bloc.dart';
import 'package:pictogram_dart_flutter/core/repositories/gallery_repository.dart';

import 'app.dart';
import 'core/theme/theme_provider.dart';
import 'injection_container.dart' as di;

void main() async {
  // Ensure that Flutter bindings are initialized before running async operations
  // This is required when calling async code before runApp()
  final galleryRepo = GalleryRepository();
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the dependency injection container
  // This registers all dependencies (SharedPreferences, ThemeProvider, etc.)
  await di.init();

  // Retrieve the theme provider from the service locator
  final themeProvider = di.sl<ThemeProvider>();

  // Load saved theme preferences from SharedPreferences
  // This ensures the app starts with the user's last selected theme
  // instead of always defaulting to the system theme
  await themeProvider.loadTheme();

  // Run the app (PictogramApp will retrieve ThemeProvider from DI container)
runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GalleryBloc(galleryRepo)),
      ],
      child: MyApp(),
    ),
  );
}
