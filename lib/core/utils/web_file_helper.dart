/// Web file handling utilities for the Pictogram application.
///
/// This file provides utilities for working with files in the web environment,
/// including file picking, reading, validation, and conversion to various formats.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import '../constants/app_constants.dart';
import '../constants/image_formats.dart';
import '../errors/exceptions.dart';

/// Helper class for web file operations.
class WebFileHelper {
  // Private constructor to prevent instantiation
  WebFileHelper._();

  // ============================================================================
  // File Picking
  // ============================================================================

  /// Opens a file picker dialog and allows the user to select multiple image files.
  ///
  /// Returns a list of selected HTML File objects.
  /// Returns an empty list if the user cancels the selection.
  ///
  /// Throws [FileLoadException] if there's an error during file selection.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final files = await WebFileHelper.pickImageFiles();
  ///   print('Selected ${files.length} files');
  /// } catch (e) {
  ///   print('Error picking files: $e');
  /// }
  /// ```
  static Future<List<html.File>> pickImageFiles() async {
    try {
      // Create a file input element
      final input = html.FileUploadInputElement();
      input.accept = ImageFormats.fileInputAccept;
      input.multiple = true;

      // Create a completer to wait for file selection
      final completer = Completer<List<html.File>>();

      // Listen for file selection
      input.onChange.listen((event) {
        final files = input.files;
        if (files != null && files.isNotEmpty) {
          completer.complete(files);
        } else {
          completer.complete([]);
        }
      });

      // Trigger the file picker
      input.click();

      // Wait for the result
      return await completer.future;
    } catch (e) {
      throw FileLoadException(
        'Failed to open file picker: ${e.toString()}',
      );
    }
  }

  /// Opens a file picker dialog for a single image file.
  ///
  /// Returns the selected HTML File object, or null if cancelled.
  ///
  /// Throws [FileLoadException] if there's an error during file selection.
  ///
  /// Example:
  /// ```dart
  /// final file = await WebFileHelper.pickImageFile();
  /// if (file != null) {
  ///   print('Selected: ${file.name}');
  /// }
  /// ```
  static Future<html.File?> pickImageFile() async {
    final files = await pickImageFiles();
    return files.isEmpty ? null : files.first;
  }

  // ============================================================================
  // File Reading
  // ============================================================================

  /// Reads a file as a [Uint8List] (byte array).
  ///
  /// This is useful for processing the raw image data.
  ///
  /// Throws [FileLoadException] if there's an error reading the file.
  ///
  /// Example:
  /// ```dart
  /// final bytes = await WebFileHelper.readFileAsBytes(file);
  /// print('Read ${bytes.length} bytes');
  /// ```
  static Future<Uint8List> readFileAsBytes(html.File file) async {
    try {
      final reader = html.FileReader();
      final completer = Completer<Uint8List>();

      reader.onLoad.listen((event) {
        final result = reader.result;
        if (result is Uint8List) {
          completer.complete(result);
        } else if (result is String) {
          // If result is a string, it might be base64 encoded
          completer.completeError(
            FileLoadException('Unexpected result type: String'),
          );
        } else {
          completer.completeError(
            FileLoadException('Unexpected result type: ${result.runtimeType}'),
          );
        }
      });

      reader.onError.listen((event) {
        completer.completeError(
          FileLoadException(
            'Error reading file: ${reader.error?.toString() ?? "Unknown error"}',
          ),
        );
      });

      reader.readAsArrayBuffer(file);

      return await completer.future;
    } catch (e) {
      throw FileLoadException(
        'Failed to read file as bytes: ${e.toString()}',
      );
    }
  }

  /// Reads a file as a data URL (base64-encoded string).
  ///
  /// This is useful for displaying images directly in HTML img tags.
  /// The returned string includes the data URL scheme (e.g., "data:image/png;base64,...").
  ///
  /// Throws [FileLoadException] if there's an error reading the file.
  ///
  /// Example:
  /// ```dart
  /// final dataUrl = await WebFileHelper.readFileAsDataUrl(file);
  /// imageElement.src = dataUrl;
  /// ```
  static Future<String> readFileAsDataUrl(html.File file) async {
    try {
      final reader = html.FileReader();
      final completer = Completer<String>();

      reader.onLoad.listen((event) {
        final result = reader.result;
        if (result is String) {
          completer.complete(result);
        } else {
          completer.completeError(
            FileLoadException('Unexpected result type: ${result.runtimeType}'),
          );
        }
      });

      reader.onError.listen((event) {
        completer.completeError(
          FileLoadException(
            'Error reading file: ${reader.error?.toString() ?? "Unknown error"}',
          ),
        );
      });

      reader.readAsDataUrl(file);

      return await completer.future;
    } catch (e) {
      throw FileLoadException(
        'Failed to read file as data URL: ${e.toString()}',
      );
    }
  }

  // ============================================================================
  // Conversion Methods
  // ============================================================================

  /// Converts a [Uint8List] to a data URL string.
  ///
  /// The MIME type must be provided to create a valid data URL.
  ///
  /// Example:
  /// ```dart
  /// final dataUrl = WebFileHelper.bytesToDataUrl(bytes, 'image/png');
  /// ```
  static String bytesToDataUrl(Uint8List bytes, String mimeType) {
    final base64 = base64Encode(bytes);
    return 'data:$mimeType;base64,$base64';
  }

  /// Converts a data URL string to a [Uint8List].
  ///
  /// The data URL must be in the format "data:[mime];base64,[data]".
  ///
  /// Throws [FileLoadException] if the data URL is invalid.
  ///
  /// Example:
  /// ```dart
  /// final bytes = WebFileHelper.dataUrlToBytes(dataUrl);
  /// ```
  static Uint8List dataUrlToBytes(String dataUrl) {
    try {
      // Extract the base64 data from the data URL
      final base64Data = dataUrl.split(',').last;
      return base64Decode(base64Data);
    } catch (e) {
      throw FileLoadException(
        'Failed to convert data URL to bytes: ${e.toString()}',
      );
    }
  }

  /// Extracts the MIME type from a data URL.
  ///
  /// Returns null if the data URL is invalid or doesn't contain a MIME type.
  ///
  /// Example:
  /// ```dart
  /// final mimeType = WebFileHelper.getMimeTypeFromDataUrl(dataUrl);
  /// print(mimeType); // 'image/png'
  /// ```
  static String? getMimeTypeFromDataUrl(String dataUrl) {
    try {
      if (!dataUrl.startsWith('data:')) return null;

      final parts = dataUrl.split(';');
      if (parts.isEmpty) return null;

      final mimeType = parts.first.substring(5); // Remove 'data:'
      return mimeType.isEmpty ? null : mimeType;
    } catch (e) {
      return null;
    }
  }

  // ============================================================================
  // Validation Methods
  // ============================================================================

  /// Validates an image file based on type and size.
  ///
  /// Returns a [FileValidationResult] with validation status and error message.
  ///
  /// Example:
  /// ```dart
  /// final result = await WebFileHelper.validateImageFile(file);
  /// if (result.isValid) {
  ///   print('File is valid');
  /// } else {
  ///   print('Validation error: ${result.errorMessage}');
  /// }
  /// ```
  static FileValidationResult validateImageFile(html.File file) {
    // Check if file is null or empty
    if (file.size == 0) {
      return FileValidationResult(
        isValid: false,
        errorMessage: 'File is empty',
      );
    }

    // Validate file size
    if (file.size > AppConstants.maxFileSizeBytes) {
      return FileValidationResult(
        isValid: false,
        errorMessage:
            'File size exceeds maximum allowed size of ${AppConstants.maxFileSizeDisplay}',
      );
    }

    // Validate MIME type
    if (!ImageFormats.isMimeTypeSupported(file.type)) {
      return FileValidationResult(
        isValid: false,
        errorMessage:
            'Unsupported file type: ${file.type}. Supported formats: ${ImageFormats.getSupportedFormatsString()}',
      );
    }

    // Validate file extension
    if (!ImageFormats.isFileNameSupported(file.name)) {
      return FileValidationResult(
        isValid: false,
        errorMessage:
            'Unsupported file extension. Supported formats: ${ImageFormats.getSupportedFormatsString()}',
      );
    }

    // Validate that MIME type and extension match
    if (!ImageFormats.validateFile(file.name, file.type)) {
      return FileValidationResult(
        isValid: false,
        errorMessage:
            'File extension and MIME type do not match',
      );
    }

    return FileValidationResult(isValid: true);
  }

  /// Validates multiple image files.
  ///
  /// Returns a list of [FileValidationResult] for each file.
  ///
  /// Example:
  /// ```dart
  /// final results = WebFileHelper.validateImageFiles(files);
  /// for (var i = 0; i < results.length; i++) {
  ///   print('${files[i].name}: ${results[i].isValid}');
  /// }
  /// ```
  static List<FileValidationResult> validateImageFiles(List<html.File> files) {
    return files.map((file) => validateImageFile(file)).toList();
  }

  /// Filters a list of files to include only valid image files.
  ///
  /// Returns a list of valid files and optionally provides error information
  /// for invalid files through the [onInvalidFile] callback.
  ///
  /// Example:
  /// ```dart
  /// final validFiles = WebFileHelper.filterValidFiles(
  ///   files,
  ///   onInvalidFile: (file, error) {
  ///     print('Invalid file ${file.name}: $error');
  ///   },
  /// );
  /// ```
  static List<html.File> filterValidFiles(
    List<html.File> files, {
    void Function(html.File file, String error)? onInvalidFile,
  }) {
    final validFiles = <html.File>[];

    for (final file in files) {
      final result = validateImageFile(file);
      if (result.isValid) {
        validFiles.add(file);
      } else if (onInvalidFile != null && result.errorMessage != null) {
        onInvalidFile(file, result.errorMessage!);
      }
    }

    return validFiles;
  }

  // ============================================================================
  // File Information
  // ============================================================================

  /// Gets file information as a formatted string.
  ///
  /// Example:
  /// ```dart
  /// final info = WebFileHelper.getFileInfo(file);
  /// print(info); // 'photo.jpg (2.5 MB, image/jpeg)'
  /// ```
  static String getFileInfo(html.File file) {
    final size = AppConstants.formatBytes(file.size);
    return '${file.name} ($size, ${file.type})';
  }

  /// Gets the file size in human-readable format.
  ///
  /// Example:
  /// ```dart
  /// final size = WebFileHelper.getFormattedFileSize(file);
  /// print(size); // '2.5 MB'
  /// ```
  static String getFormattedFileSize(html.File file) {
    return AppConstants.formatBytes(file.size);
  }
}

/// Result of file validation.
class FileValidationResult {
  /// Creates a file validation result.
  const FileValidationResult({
    required this.isValid,
    this.errorMessage,
  });

  /// Whether the file passed validation.
  final bool isValid;

  /// Error message if validation failed.
  final String? errorMessage;
}
