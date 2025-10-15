/// Exception classes for the Pictogram application.
///
/// This file defines custom exceptions used throughout the application.
/// Exceptions are thrown when errors occur and should be caught and
/// converted to Failures at appropriate boundaries.
library;

/// Base class for all custom exceptions in the application.
///
/// All custom exceptions should extend this class to allow for
/// consistent error handling.
abstract class PictogramException implements Exception {
  /// Creates an exception with an optional error message.
  const PictogramException([this.message]);

  /// The error message describing what went wrong.
  final String? message;

  @override
  String toString() => message ?? 'PictogramException';
}

// ==============================================================================
// File Operation Exceptions
// ==============================================================================

/// Exception thrown when file loading operations fail.
///
/// This can occur when:
/// - File picker fails to open
/// - File cannot be read
/// - File is corrupted or inaccessible
///
/// Example:
/// ```dart
/// throw FileLoadException('Failed to read image file');
/// ```
class FileLoadException extends PictogramException {
  /// Creates a file load exception with a message.
  const FileLoadException([super.message = 'Failed to load file']);
}

/// Exception thrown when file validation fails.
///
/// This can occur when:
/// - File type is not supported
/// - File size exceeds limits
/// - File extension doesn't match MIME type
///
/// Example:
/// ```dart
/// throw FileValidationException('File size exceeds 50 MB limit');
/// ```
class FileValidationException extends PictogramException {
  /// Creates a file validation exception with a message.
  const FileValidationException([
    super.message = 'File validation failed',
  ]);
}

/// Exception thrown when file format is not supported.
///
/// Example:
/// ```dart
/// throw UnsupportedFileFormatException('TIFF format is not supported');
/// ```
class UnsupportedFileFormatException extends PictogramException {
  /// Creates an unsupported file format exception with a message.
  const UnsupportedFileFormatException([
    super.message = 'Unsupported file format',
  ]);
}

// ==============================================================================
// Image Processing Exceptions
// ==============================================================================

/// Exception thrown when image processing operations fail.
///
/// This can occur when:
/// - Image decoding fails
/// - Image encoding fails
/// - Image transformation fails
/// - Format conversion fails
///
/// Example:
/// ```dart
/// throw ImageProcessingException('Failed to rotate image');
/// ```
class ImageProcessingException extends PictogramException {
  /// Creates an image processing exception with a message.
  const ImageProcessingException([
    super.message = 'Image processing failed',
  ]);
}

/// Exception thrown when image decoding fails.
///
/// Example:
/// ```dart
/// throw ImageDecodingException('Invalid PNG data');
/// ```
class ImageDecodingException extends ImageProcessingException {
  /// Creates an image decoding exception with a message.
  const ImageDecodingException([super.message = 'Failed to decode image']);
}

/// Exception thrown when image encoding fails.
///
/// Example:
/// ```dart
/// throw ImageEncodingException('Failed to encode as JPEG');
/// ```
class ImageEncodingException extends ImageProcessingException {
  /// Creates an image encoding exception with a message.
  const ImageEncodingException([super.message = 'Failed to encode image']);
}

/// Exception thrown when image transformation operations fail.
///
/// Example:
/// ```dart
/// throw ImageTransformationException('Rotation operation failed');
/// ```
class ImageTransformationException extends ImageProcessingException {
  /// Creates an image transformation exception with a message.
  const ImageTransformationException([
    super.message = 'Image transformation failed',
  ]);
}

/// Exception thrown when image format is invalid or corrupted.
///
/// Example:
/// ```dart
/// throw InvalidImageFormatException('Image data is corrupted');
/// ```
class InvalidImageFormatException extends ImageProcessingException {
  /// Creates an invalid image format exception with a message.
  const InvalidImageFormatException([
    super.message = 'Invalid image format',
  ]);
}

// ==============================================================================
// Storage Exceptions
// ==============================================================================

/// Exception thrown when storage operations fail.
///
/// This can occur when:
/// - Local storage is not available
/// - Data cannot be saved
/// - Data cannot be retrieved
/// - Storage quota is exceeded
///
/// Example:
/// ```dart
/// throw StorageException('Failed to save preferences');
/// ```
class StorageException extends PictogramException {
  /// Creates a storage exception with a message.
  const StorageException([super.message = 'Storage operation failed']);
}

/// Exception thrown when reading from storage fails.
///
/// Example:
/// ```dart
/// throw StorageReadException('Failed to load recent files');
/// ```
class StorageReadException extends StorageException {
  /// Creates a storage read exception with a message.
  const StorageReadException([super.message = 'Failed to read from storage']);
}

/// Exception thrown when writing to storage fails.
///
/// Example:
/// ```dart
/// throw StorageWriteException('Failed to save settings');
/// ```
class StorageWriteException extends StorageException {
  /// Creates a storage write exception with a message.
  const StorageWriteException([super.message = 'Failed to write to storage']);
}

/// Exception thrown when storage quota is exceeded.
///
/// Example:
/// ```dart
/// throw StorageQuotaExceededException('Storage quota exceeded');
/// ```
class StorageQuotaExceededException extends StorageException {
  /// Creates a storage quota exceeded exception with a message.
  const StorageQuotaExceededException([
    super.message = 'Storage quota exceeded',
  ]);
}

// ==============================================================================
// Download Exceptions
// ==============================================================================

/// Exception thrown when download operations fail.
///
/// Example:
/// ```dart
/// throw DownloadException('Failed to download processed image');
/// ```
class DownloadException extends PictogramException {
  /// Creates a download exception with a message.
  const DownloadException([super.message = 'Download failed']);
}

// ==============================================================================
// Clipboard Exceptions
// ==============================================================================

/// Exception thrown when clipboard operations fail.
///
/// Example:
/// ```dart
/// throw ClipboardException('Failed to copy image to clipboard');
/// ```
class ClipboardException extends PictogramException {
  /// Creates a clipboard exception with a message.
  const ClipboardException([super.message = 'Clipboard operation failed']);
}

// ==============================================================================
// Network Exceptions (for future use)
// ==============================================================================

/// Exception thrown when network operations fail.
///
/// This is reserved for future features that may require network access.
///
/// Example:
/// ```dart
/// throw NetworkException('No internet connection');
/// ```
class NetworkException extends PictogramException {
  /// Creates a network exception with a message.
  const NetworkException([super.message = 'Network operation failed']);
}

/// Exception thrown when a network connection timeout occurs.
///
/// Example:
/// ```dart
/// throw NetworkTimeoutException('Connection timed out');
/// ```
class NetworkTimeoutException extends NetworkException {
  /// Creates a network timeout exception with a message.
  const NetworkTimeoutException([super.message = 'Connection timed out']);
}

// ==============================================================================
// Permission Exceptions
// ==============================================================================

/// Exception thrown when required permissions are not granted.
///
/// Example:
/// ```dart
/// throw PermissionException('Storage permission denied');
/// ```
class PermissionException extends PictogramException {
  /// Creates a permission exception with a message.
  const PermissionException([super.message = 'Permission denied']);
}

// ==============================================================================
// Validation Exceptions
// ==============================================================================

/// Exception thrown when input validation fails.
///
/// Example:
/// ```dart
/// throw ValidationException('Invalid zoom level');
/// ```
class ValidationException extends PictogramException {
  /// Creates a validation exception with a message.
  const ValidationException([super.message = 'Validation failed']);
}

/// Exception thrown when required parameters are missing.
///
/// Example:
/// ```dart
/// throw MissingParameterException('Image bytes are required');
/// ```
class MissingParameterException extends ValidationException {
  /// Creates a missing parameter exception with a message.
  const MissingParameterException([
    super.message = 'Required parameter is missing',
  ]);
}

/// Exception thrown when parameters are out of valid range.
///
/// Example:
/// ```dart
/// throw InvalidParameterException('Zoom level must be between 0.1 and 5.0');
/// ```
class InvalidParameterException extends ValidationException {
  /// Creates an invalid parameter exception with a message.
  const InvalidParameterException([
    super.message = 'Invalid parameter value',
  ]);
}

// ==============================================================================
// State Exceptions
// ==============================================================================

/// Exception thrown when an operation is attempted in an invalid state.
///
/// Example:
/// ```dart
/// throw InvalidStateException('No image loaded');
/// ```
class InvalidStateException extends PictogramException {
  /// Creates an invalid state exception with a message.
  const InvalidStateException([super.message = 'Invalid state']);
}

// ==============================================================================
// Unexpected Exceptions
// ==============================================================================

/// Exception thrown when an unexpected error occurs.
///
/// This should be used as a last resort when the specific type
/// of exception cannot be determined.
///
/// Example:
/// ```dart
/// throw UnexpectedException('An unexpected error occurred');
/// ```
class UnexpectedException extends PictogramException {
  /// Creates an unexpected exception with a message.
  const UnexpectedException([
    super.message = 'An unexpected error occurred',
  ]);
}
