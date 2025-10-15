import 'package:flutter/material.dart';

/// Route guards for handling navigation confirmation and validation
class RouteGuards {
  // Prevent instantiation
  RouteGuards._();

  /// Checks if there are unsaved changes and shows confirmation dialog if needed
  ///
  /// Returns null if navigation should proceed, or a redirect path if it should be blocked
  static Future<String?> checkUnsavedChanges(BuildContext context) async {
    // TODO: This will be implemented when EditorBloc is created
    // For now, always allow navigation
    //
    // Implementation will:
    // 1. Check if EditorBloc exists in context
    // 2. Check if there are pending changes
    // 3. Show confirmation dialog if changes exist
    // 4. Return null to proceed or current path to stay

    return null;
  }

  /// Shows a confirmation dialog for unsaved changes
  ///
  /// Returns true if user wants to discard changes, false if they want to stay
  static Future<bool> showUnsavedChangesDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Cambios sin guardar'),
          content: const Text(
            '¿Deseas guardar los cambios antes de continuar?\n\n'
            'Los cambios no guardados se perderán.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Descartar'),
            ),
            FilledButton(
              onPressed: () async {
                // TODO: Trigger save action in EditorBloc
                // For now, just close dialog
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  /// Validates if an imageId parameter is valid
  static bool isValidImageId(String? imageId) {
    if (imageId == null || imageId.isEmpty) {
      return false;
    }
    // Add more validation as needed
    return true;
  }
}
