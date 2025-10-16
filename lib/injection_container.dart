/// Dependency Injection Container for Pictogram Web App
///
/// This file configures the GetIt service locator for dependency injection
/// throughout the application. It manages the registration and lifecycle of
/// all dependencies, ensuring proper initialization order and clean architecture.
///
/// ## What is Dependency Injection?
///
/// Dependency Injection (DI) is a design pattern that helps achieve loose coupling
/// between classes and their dependencies. Instead of classes creating their own
/// dependencies, they receive them from an external source (the service locator).
///
/// ## Benefits:
/// - Testability: Easy to mock dependencies in unit tests
/// - Maintainability: Changes to dependencies don't affect dependent classes
/// - Flexibility: Easy to swap implementations
/// - Single Responsibility: Classes focus on their core logic, not dependency creation
///
/// ## Registration Types:
///
/// GetIt supports different registration types for different use cases:
///
/// ### 1. Factory (factory)
/// ```dart
/// sl.registerFactory(() => MyClass(sl()));
/// ```
/// - Creates a NEW instance every time it's requested
/// - Use for: BLoCs, Cubits, and other stateful components that should not be shared
/// - Example: Each screen gets its own BLoC instance with fresh state
/// - Memory: Instance is garbage collected when no longer referenced
///
/// ### 2. Lazy Singleton (registerLazySingleton)
/// ```dart
/// sl.registerLazySingleton(() => MyService());
/// ```
/// - Creates ONE instance the FIRST TIME it's requested
/// - Reuses that same instance for all subsequent requests
/// - Use for: Utilities, helpers, and stateless services
/// - Memory: Instance persists for the app's lifetime
/// - Lazy: Only created when actually needed, not at registration time
///
/// ### 3. Singleton (registerSingleton)
/// ```dart
/// sl.registerSingleton(myInstance);
/// ```
/// - Registers an ALREADY CREATED instance
/// - Use for: Pre-initialized objects (like SharedPreferences)
/// - Memory: Instance persists for the app's lifetime
/// - Eager: Instance must exist before registration
///
/// ## Registration Order Matters!
///
/// Dependencies must be registered BEFORE the classes that depend on them.
/// Our registration order:
/// 1. External dependencies (SharedPreferences) - no dependencies
/// 2. Providers (ThemeProvider) - depends on SharedPreferences
/// 3. Core utilities (WebFileHelper, DownloadHelper) - no dependencies
/// 4. Data sources - depend on external dependencies
/// 5. Repositories - depend on data sources
/// 6. Use cases - depend on repositories
/// 7. BLoCs/Cubits - depend on use cases
///
/// ## How to Access Dependencies:
///
/// ```dart
/// // Import the service locator
/// import 'package:pictogram_dart_flutter/injection_container.dart';
///
/// // Access a dependency
/// final themeProvider = sl<ThemeProvider>();
/// final webFileHelper = sl<WebFileHelper>();
///
/// // In BLoC constructors
/// class MyBloc extends Bloc<MyEvent, MyState> {
///   MyBloc({
///     required MyUseCase useCase,
///   }) : _useCase = useCase;
///
///   final MyUseCase _useCase;
/// }
///
/// // Register the BLoC with dependencies
/// sl.registerFactory(() => MyBloc(useCase: sl()));
/// ```
///
/// ## Usage in main.dart:
///
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   // Initialize all dependencies
///   await init();
///
///   runApp(MyApp());
/// }
/// ```
///
/// ## Testing:
///
/// For testing, you can reset and re-register dependencies:
/// ```dart
/// setUp(() async {
///   await sl.reset();
///   await init();
///
///   // Override with mocks
///   sl.unregister<MyRepository>();
///   sl.registerLazySingleton<MyRepository>(() => MockMyRepository());
/// });
/// ```
library;

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/theme_provider.dart';

/// The global service locator instance.
///
/// Use this to access registered dependencies throughout the app:
/// ```dart
/// final dependency = sl<DependencyType>();
/// ```
final sl = GetIt.instance;

/// Initializes all dependencies in the correct order.
///
/// This function must be called in main() before runApp():
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await init();
///   runApp(MyApp());
/// }
/// ```
///
/// The initialization process:
/// 1. Registers external dependencies (async operations)
/// 2. Registers providers and utilities
/// 3. Placeholder registrations for future features (commented)
///
/// Returns a Future that completes when all dependencies are registered.
Future<void> init() async {
  // ==========================================================================
  // EXTERNAL DEPENDENCIES
  // ==========================================================================
  // External dependencies are third-party libraries that need async initialization.
  // These must be registered first as they have no dependencies on our code.

  // SharedPreferences - Used for persistent storage (localStorage in web)
  // Registered as singleton because there should only be one instance
  // Must be async because getInstance() fetches from storage
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // ==========================================================================
  // PROVIDERS
  // ==========================================================================
  // Providers manage application-wide state and should be singletons.
  // They are registered after external dependencies they might need.

  // ThemeProvider - Manages theme selection and persistence
  // Uses SharedPreferences internally for saving theme preferences
  // Registered as lazy singleton because:
  // - Only one theme state should exist across the app
  // - It will be accessed by MaterialApp and settings UI
  // - Lazy initialization is fine since MaterialApp loads after init()
  sl.registerLazySingleton<ThemeProvider>(() => ThemeProvider());

  // ==========================================================================
  // CORE UTILITIES
  // ==========================================================================
  // Core utilities are stateless helper classes with static methods.
  // These are registered as lazy singletons for consistency, though they
  // could also be used directly as static classes.

  // WebFileHelper - Handles file picking, reading, and validation for web
  // Provides methods for working with HTML File API
  // Note: Uses private constructor, so we can't actually instantiate it
  // These registrations are commented out as these are utility classes
  // with static methods only. Access them directly: WebFileHelper.pickImageFile()

  // sl.registerLazySingleton<WebFileHelper>(() => WebFileHelper._());
  // sl.registerLazySingleton<DownloadHelper>(() => DownloadHelper._());

  // Note: WebFileHelper and DownloadHelper use private constructors and static methods.
  // They don't need to be registered in the DI container. Use them directly:
  // - WebFileHelper.pickImageFile()
  // - DownloadHelper.downloadImage(...)

  // ==========================================================================
  // FUTURE FEATURES - PHASE 2: IMAGE VIEWER
  // ==========================================================================
  // The Image Viewer feature will allow users to view uploaded images with
  // zoom, pan, and navigation capabilities.
  //
  // Dependencies to register when implementing Phase 2:
  //
  // Data Layer:
  // - ImageLocalDataSource (lazy singleton)
  //   Handles loading image data from memory/cache
  //
  // - ImageRepository (lazy singleton)
  //   Implements IImageRepository interface
  //   Depends on: ImageLocalDataSource
  //   Provides: Image data to use cases
  //
  // Domain Layer (Use Cases):
  // - LoadImageUseCase (lazy singleton)
  //   Loads image from repository
  //   Depends on: ImageRepository
  //
  // - NavigateImagesUseCase (lazy singleton)
  //   Handles next/previous image navigation
  //   Depends on: ImageRepository
  //
  // Presentation Layer:
  // - ViewerBloc (factory - NEW instance for each viewer)
  //   Manages image viewer state
  //   Depends on: LoadImageUseCase, NavigateImagesUseCase
  //   Why factory? Each viewer screen should have independent state
  //
  // Example registrations:
  // sl.registerLazySingleton<ImageLocalDataSource>(() => ImageLocalDataSourceImpl());
  // sl.registerLazySingleton<ImageRepository>(() => ImageRepositoryImpl(dataSource: sl()));
  // sl.registerLazySingleton<LoadImageUseCase>(() => LoadImageUseCase(repository: sl()));
  // sl.registerLazySingleton<NavigateImagesUseCase>(() => NavigateImagesUseCase(repository: sl()));
  // sl.registerFactory<ViewerBloc>(() => ViewerBloc(
  //   loadImage: sl(),
  //   navigateImages: sl(),
  // ));

  // ==========================================================================
  // FUTURE FEATURES - PHASE 3: GALLERY
  // ==========================================================================
  // The Gallery feature will display a grid of thumbnails for uploaded images,
  // allowing users to select and manage multiple images.
  //
  // Dependencies to register when implementing Phase 3:
  //
  // Data Layer:
  // - GalleryLocalDataSource (lazy singleton)
  //   Manages gallery data in memory
  //
  // - GalleryRepository (lazy singleton)
  //   Implements IGalleryRepository interface
  //   Depends on: GalleryLocalDataSource
  //
  // Domain Layer (Use Cases):
  // - GenerateThumbnailsUseCase (lazy singleton)
  //   Creates thumbnail versions of images for efficient gallery display
  //   Depends on: GalleryRepository
  //
  // - LoadGalleryUseCase (lazy singleton)
  //   Loads all images in the gallery
  //   Depends on: GalleryRepository
  //
  // - AddToGalleryUseCase (lazy singleton)
  //   Adds new images to the gallery
  //   Depends on: GalleryRepository
  //
  // - RemoveFromGalleryUseCase (lazy singleton)
  //   Removes images from the gallery
  //   Depends on: GalleryRepository
  //
  // Presentation Layer:
  // - GalleryBloc (factory - NEW instance per gallery view)
  //   Manages gallery state, selection, and operations
  //   Depends on: LoadGalleryUseCase, AddToGalleryUseCase, RemoveFromGalleryUseCase
  //   Why factory? Different gallery views might need independent state
  //
  // Utilities:
  // - ThumbnailGenerator (lazy singleton)
  //   Generates optimized thumbnail images
  //   Uses image processing library to create smaller versions
  //
  // Example registrations:
  // sl.registerLazySingleton<ThumbnailGenerator>(() => ThumbnailGeneratorImpl());
  // sl.registerLazySingleton<GalleryLocalDataSource>(() => GalleryLocalDataSourceImpl());
  // sl.registerLazySingleton<GalleryRepository>(() => GalleryRepositoryImpl(dataSource: sl()));
  // sl.registerLazySingleton<GenerateThumbnailsUseCase>(() => GenerateThumbnailsUseCase(
  //   repository: sl(),
  //   generator: sl(),
  // ));
  // sl.registerLazySingleton<LoadGalleryUseCase>(() => LoadGalleryUseCase(repository: sl()));
  // sl.registerLazySingleton<AddToGalleryUseCase>(() => AddToGalleryUseCase(repository: sl()));
  // sl.registerLazySingleton<RemoveFromGalleryUseCase>(() => RemoveFromGalleryUseCase(repository: sl()));
  // sl.registerFactory<GalleryBloc>(() => GalleryBloc(
  //   loadGallery: sl(),
  //   addToGallery: sl(),
  //   removeFromGallery: sl(),
  // ));

  // ==========================================================================
  // FUTURE FEATURES - PHASE 4: IMAGE EDITOR
  // ==========================================================================
  // The Image Editor feature provides tools for transforming and processing images,
  // including rotation, flipping, resizing, and format conversion.
  //
  // Dependencies to register when implementing Phase 4:
  //
  // Data Layer:
  // - ImageProcessorDataSource (lazy singleton)
  //   Handles low-level image processing using the 'image' package
  //   Performs actual pixel manipulation
  //
  // - EditorRepository (lazy singleton)
  //   Implements IEditorRepository interface
  //   Depends on: ImageProcessorDataSource
  //   Manages image processing operations
  //
  // Domain Layer (Use Cases):
  // - RotateImageUseCase (lazy singleton)
  //   Rotates image by specified angle (90°, 180°, 270°)
  //   Depends on: EditorRepository
  //
  // - FlipImageUseCase (lazy singleton)
  //   Flips image horizontally or vertically
  //   Depends on: EditorRepository
  //
  // - ResizeImageUseCase (lazy singleton)
  //   Resizes image to specified dimensions
  //   Depends on: EditorRepository
  //
  // - ConvertFormatUseCase (lazy singleton)
  //   Converts image between formats (PNG, JPEG, WebP, etc.)
  //   Depends on: EditorRepository
  //
  // - DownloadImageUseCase (lazy singleton)
  //   Handles image download using DownloadHelper
  //   Depends on: EditorRepository
  //
  // Presentation Layer:
  // - EditorBloc (factory - NEW instance per editor session)
  //   Manages editor state and operations
  //   Depends on: All editor use cases
  //   Why factory? Each editing session should have independent state/history
  //
  // Utilities:
  // - ImageProcessor (lazy singleton)
  //   Core image processing functionality
  //   Wraps the 'image' package with app-specific logic
  //
  // Example registrations:
  // sl.registerLazySingleton<ImageProcessor>(() => ImageProcessorImpl());
  // sl.registerLazySingleton<ImageProcessorDataSource>(() => ImageProcessorDataSourceImpl(processor: sl()));
  // sl.registerLazySingleton<EditorRepository>(() => EditorRepositoryImpl(dataSource: sl()));
  // sl.registerLazySingleton<RotateImageUseCase>(() => RotateImageUseCase(repository: sl()));
  // sl.registerLazySingleton<FlipImageUseCase>(() => FlipImageUseCase(repository: sl()));
  // sl.registerLazySingleton<ResizeImageUseCase>(() => ResizeImageUseCase(repository: sl()));
  // sl.registerLazySingleton<ConvertFormatUseCase>(() => ConvertFormatUseCase(repository: sl()));
  // sl.registerLazySingleton<DownloadImageUseCase>(() => DownloadImageUseCase(repository: sl()));
  // sl.registerFactory<EditorBloc>(() => EditorBloc(
  //   rotateImage: sl(),
  //   flipImage: sl(),
  //   resizeImage: sl(),
  //   convertFormat: sl(),
  //   downloadImage: sl(),
  // ));

  // ==========================================================================
  // FUTURE FEATURES - PHASE 6: RECENT FILES
  // ==========================================================================
  // The Recent Files feature tracks recently accessed images for quick access,
  // similar to "Recent Documents" in desktop applications.
  //
  // Dependencies to register when implementing Phase 6:
  //
  // Data Layer:
  // - RecentFilesLocalDataSource (lazy singleton)
  //   Stores recent files data using SharedPreferences
  //   Depends on: SharedPreferences (already registered)
  //
  // - RecentFilesRepository (lazy singleton)
  //   Implements IRecentFilesRepository interface
  //   Depends on: RecentFilesLocalDataSource
  //   Manages recent files list with max size constraints
  //
  // Domain Layer (Use Cases):
  // - AddRecentFileUseCase (lazy singleton)
  //   Adds a file to recent files list (automatically removes oldest if limit reached)
  //   Depends on: RecentFilesRepository
  //
  // - GetRecentFilesUseCase (lazy singleton)
  //   Retrieves the list of recent files
  //   Depends on: RecentFilesRepository
  //
  // - ClearRecentFilesUseCase (lazy singleton)
  //   Clears all recent files
  //   Depends on: RecentFilesRepository
  //
  // - RemoveRecentFileUseCase (lazy singleton)
  //   Removes a specific file from recent files
  //   Depends on: RecentFilesRepository
  //
  // Presentation Layer:
  // - RecentFilesCubit (factory - NEW instance per view)
  //   Manages recent files state
  //   Depends on: GetRecentFilesUseCase, AddRecentFileUseCase, ClearRecentFilesUseCase
  //   Why factory? Different views might show recent files independently
  //   Why Cubit? Simple state management without complex events
  //
  // Example registrations:
  // sl.registerLazySingleton<RecentFilesLocalDataSource>(
  //   () => RecentFilesLocalDataSourceImpl(sharedPreferences: sl()),
  // );
  // sl.registerLazySingleton<RecentFilesRepository>(
  //   () => RecentFilesRepositoryImpl(dataSource: sl()),
  // );
  // sl.registerLazySingleton<AddRecentFileUseCase>(
  //   () => AddRecentFileUseCase(repository: sl()),
  // );
  // sl.registerLazySingleton<GetRecentFilesUseCase>(
  //   () => GetRecentFilesUseCase(repository: sl()),
  // );
  // sl.registerLazySingleton<ClearRecentFilesUseCase>(
  //   () => ClearRecentFilesUseCase(repository: sl()),
  // );
  // sl.registerLazySingleton<RemoveRecentFileUseCase>(
  //   () => RemoveRecentFileUseCase(repository: sl()),
  // );
  // sl.registerFactory<RecentFilesCubit>(() => RecentFilesCubit(
  //   getRecentFiles: sl(),
  //   addRecentFile: sl(),
  //   clearRecentFiles: sl(),
  //   removeRecentFile: sl(),
  // ));

  // ==========================================================================
  // FUTURE FEATURES - PHASE 7: SETTINGS
  // ==========================================================================
  // The Settings feature manages user preferences including theme, image quality,
  // default format, auto-save options, and other configurable behaviors.
  //
  // Dependencies to register when implementing Phase 7:
  //
  // Data Layer:
  // - SettingsLocalDataSource (lazy singleton)
  //   Stores settings data using SharedPreferences
  //   Depends on: SharedPreferences (already registered)
  //
  // - SettingsRepository (lazy singleton)
  //   Implements ISettingsRepository interface
  //   Depends on: SettingsLocalDataSource
  //   Manages all app settings with validation
  //
  // Domain Layer (Use Cases):
  // - SaveSettingsUseCase (lazy singleton)
  //   Saves individual or bulk settings
  //   Depends on: SettingsRepository
  //
  // - LoadSettingsUseCase (lazy singleton)
  //   Loads all settings from storage
  //   Depends on: SettingsRepository
  //
  // - ResetSettingsUseCase (lazy singleton)
  //   Resets all settings to default values
  //   Depends on: SettingsRepository
  //
  // - GetSettingUseCase (lazy singleton)
  //   Gets a specific setting value
  //   Depends on: SettingsRepository
  //
  // Presentation Layer:
  // - SettingsCubit (factory - typically one instance, but factory for testing)
  //   Manages settings state
  //   Depends on: SaveSettingsUseCase, LoadSettingsUseCase, ResetSettingsUseCase
  //   Why factory? Allows easy testing and potential multiple settings views
  //   Why Cubit? Settings are simple state without complex event flows
  //
  // Models:
  // - AppSettings (value object)
  //   Contains all app settings with defaults
  //   Fields: imageQuality, defaultFormat, autoSave, gridSize, etc.
  //
  // Example registrations:
  // sl.registerLazySingleton<SettingsLocalDataSource>(
  //   () => SettingsLocalDataSourceImpl(sharedPreferences: sl()),
  // );
  // sl.registerLazySingleton<SettingsRepository>(
  //   () => SettingsRepositoryImpl(dataSource: sl()),
  // );
  // sl.registerLazySingleton<SaveSettingsUseCase>(
  //   () => SaveSettingsUseCase(repository: sl()),
  // );
  // sl.registerLazySingleton<LoadSettingsUseCase>(
  //   () => LoadSettingsUseCase(repository: sl()),
  // );
  // sl.registerLazySingleton<ResetSettingsUseCase>(
  //   () => ResetSettingsUseCase(repository: sl()),
  // );
  // sl.registerLazySingleton<GetSettingUseCase>(
  //   () => GetSettingUseCase(repository: sl()),
  // );
  // sl.registerFactory<SettingsCubit>(() => SettingsCubit(
  //   saveSettings: sl(),
  //   loadSettings: sl(),
  //   resetSettings: sl(),
  // ));

  // ==========================================================================
  // INITIALIZATION COMPLETE
  // ==========================================================================
  // All dependencies are now registered and ready to use.
  // Access them via: sl<DependencyType>()
}
