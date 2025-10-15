import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/route_constants.dart';
import 'route_guards.dart';
import '../../presentation/editor/editor_page.dart';

/// Application router configuration using GoRouter
///
/// This class handles all routing logic, including:
/// - Route definitions
/// - Navigation guards
/// - Error handling
/// - Deep linking support
class AppRouter {
  // Root navigator key for managing navigation stack
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  /// GoRouter instance with all route configurations
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstants.gallery,
    debugLogDiagnostics: true,

    // Error page builder
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Ruta: ${state.uri.path}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go(RouteConstants.gallery),
              icon: const Icon(Icons.home),
              label: const Text('Ir al inicio'),
            ),
          ],
        ),
      ),
    ),

    // Route definitions
    routes: [
      // Gallery route - Main page with image thumbnails
      GoRoute(
        path: RouteConstants.gallery,
        name: RouteConstants.galleryName,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: _GalleryPlaceholder(),
        ),
      ),

      // Viewer route - Image viewer with zoom/pan
      GoRoute(
        path: '${RouteConstants.viewer}/:imageId',
        name: RouteConstants.viewerName,
        pageBuilder: (context, state) {
          final imageId = state.pathParameters['imageId'];

          if (!RouteGuards.isValidImageId(imageId)) {
            return MaterialPage(
              key: state.pageKey,
              child: _ErrorPage(message: 'ID de imagen inválido'),
            );
          }

          return MaterialPage(
            key: state.pageKey,
            child: _ViewerPlaceholder(imageId: imageId!),
          );
        },
      ),

      // Editor route - Image editor with transformations
      GoRoute(
        path: '${RouteConstants.editor}/:imageId',
        name: RouteConstants.editorName,
        pageBuilder: (context, state) {
          final imageId = state.pathParameters['imageId'];

          if (!RouteGuards.isValidImageId(imageId)) {
            return MaterialPage(
              key: state.pageKey,
              child: _ErrorPage(message: 'ID de imagen inválido'),
            );
          }

          // TODO: Update EditorPage to accept imageId parameter
          // For now, using existing EditorPage
          return MaterialPage(
            key: state.pageKey,
            child: const EditorPage(),
          );
        },
      ),

      // Settings route - Application settings
      GoRoute(
        path: RouteConstants.settings,
        name: RouteConstants.settingsName,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: _SettingsPlaceholder(),
        ),
      ),
    ],
  );
}

// ============================================================================
// PLACEHOLDER WIDGETS (to be replaced with actual implementations)
// ============================================================================

/// Temporary placeholder for Gallery page
/// TODO: Replace with actual GalleryPage from features/gallery
class _GalleryPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galería'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(RouteConstants.settings),
            tooltip: 'Configuración',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.photo_library, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Galería (En desarrollo)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('La galería de imágenes se implementará en FASE 2'),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.push('${RouteConstants.editor}/temp'),
              icon: const Icon(Icons.edit),
              label: const Text('Ir al Editor (demo)'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Open file picker to load images
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cargar imágenes (en desarrollo)')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Cargar imágenes'),
      ),
    );
  }
}

/// Temporary placeholder for Viewer page
/// TODO: Replace with actual ViewerPage from features/viewer
class _ViewerPlaceholder extends StatelessWidget {
  final String imageId;

  const _ViewerPlaceholder({required this.imageId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push(RouteConstants.editorRoute(imageId)),
            tooltip: 'Editar',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Visor de Imágenes (En desarrollo)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Image ID: $imageId'),
            const SizedBox(height: 8),
            const Text('El visor se implementará en FASE 3'),
          ],
        ),
      ),
    );
  }
}

/// Temporary placeholder for Settings page
/// TODO: Replace with actual SettingsPage from features/settings
class _SettingsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.settings, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Configuración (En desarrollo)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('La página de configuración se implementará en FASE 6'),
          ],
        ),
      ),
    );
  }
}

/// Error page for invalid routes or parameters
class _ErrorPage extends StatelessWidget {
  final String message;

  const _ErrorPage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go(RouteConstants.gallery),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
