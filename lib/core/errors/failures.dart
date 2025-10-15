/// Failure classes for error handling in the Pictogram application.
///
/// This file defines abstract and concrete failure classes used for
/// error handling following clean architecture principles.
/// Failures represent errors that have been caught and handled.
library;

/// Abstract base class for all failures in the application.
///
/// Failures are used to represent errors in a type-safe way,
/// allowing for better error handling and separation from exceptions.
abstract class Failure {
  /// Creates a failure with an optional error message.
  const Failure([this.message]);

  /// The error message describing what went wrong.
  final String? message;

  @override
  String toString() => message ?? 'An error occurred';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure &&
        other.runtimeType == runtimeType &&
        other.message == message;
  }

  @override
  int get hashCode => message.hashCode ^ runtimeType.hashCode;
}

// ==============================================================================
// File Operation Failures
// ==============================================================================

/// Failure that occurs when loading or reading files.
///
/// This can happen when:
/// - File picker fails to open
/// - File cannot be read
/// - File validation fails
/// - File is corrupted or inaccessible
///
/// Example:
/// ```dart
/// return Left(FileLoadFailure('Failed to read image file'));
/// ```
class FileLoadFailure extends Failure {
  /// Creates a file load failure with a message.
  const FileLoadFailure([super.message = 'Failed to load file']);
}

/// Failure that occurs when validating files.
///
/// This can happen when:
/// - File type is not supported
/// - File size exceeds limits
/// - File extension doesn't match MIME type
///
/// Example:
/// ```dart
/// return Left(FileValidationFailure('File size exceeds 50 MB limit'));
/// ```
class FileValidationFailure extends Failure {
  /// Creates a file validation failure with a message.
  const FileValidationFailure([super.message = 'File validation failed']);
}

// ==============================================================================
// Image Processing Failures
// ==============================================================================

/// Failure that occurs during image processing operations.
///
/// This can happen when:
/// - Image decoding fails
/// - Image encoding fails
/// - Image transformation fails (rotate, flip, resize)
/// - Format conversion fails
///
/// Example:
/// ```dart
/// return Left(ImageProcessingFailure('Failed to rotate image'));
/// ```
class ImageProcessingFailure extends Failure {
  /// Creates an image processing failure with a message.
  const ImageProcessingFailure([
    super.message = 'Failed to process image',
  ]);
}

/// Failure that occurs when decoding image data.
///
/// Example:
/// ```dart
/// return Left(ImageDecodingFailure('Invalid PNG data'));
/// ```
class ImageDecodingFailure extends Failure {
  /// Creates an image decoding failure with a message.
  const ImageDecodingFailure([super.message = 'Failed to decode image']);
}

/// Failure that occurs when encoding image data.
///
/// Example:
/// ```dart
/// return Left(ImageEncodingFailure('Failed to encode as JPEG'));
/// ```
class ImageEncodingFailure extends Failure {
  /// Creates an image encoding failure with a message.
  const ImageEncodingFailure([super.message = 'Failed to encode image']);
}

/// Failure that occurs during image transformation operations.
///
/// Example:
/// ```dart
/// return Left(ImageTransformationFailure('Rotation failed'));
/// ```
class ImageTransformationFailure extends Failure {
  /// Creates an image transformation failure with a message.
  const ImageTransformationFailure([
    super.message = 'Failed to transform image',
  ]);
}

// ==============================================================================
// Storage Failures
// ==============================================================================

/// Failure that occurs during storage operations.
///
/// This can happen when:
/// - Local storage is not available
/// - Data cannot be saved
/// - Data cannot be retrieved
/// - Storage quota is exceeded
///
/// Example:
/// ```dart
/// return Left(StorageFailure('Failed to save preferences'));
/// ```
class StorageFailure extends Failure {
  /// Creates a storage failure with a message.
  const StorageFailure([super.message = 'Storage operation failed']);
}

/// Failure that occurs when reading from storage.
///
/// Example:
/// ```dart
/// return Left(StorageReadFailure('Failed to load recent files'));
/// ```
class StorageReadFailure extends StorageFailure {
  /// Creates a storage read failure with a message.
  const StorageReadFailure([super.message = 'Failed to read from storage']);
}

/// Failure that occurs when writing to storage.
///
/// Example:
/// ```dart
/// return Left(StorageWriteFailure('Failed to save settings'));
/// ```
class StorageWriteFailure extends StorageFailure {
  /// Creates a storage write failure with a message.
  const StorageWriteFailure([super.message = 'Failed to write to storage']);
}

// ==============================================================================
// Download Failures
// ==============================================================================

/// Failure that occurs during file download operations.
///
/// Example:
/// ```dart
/// return Left(DownloadFailure('Failed to download processed image'));
/// ```
class DownloadFailure extends Failure {
  /// Creates a download failure with a message.
  const DownloadFailure([super.message = 'Failed to download file']);
}

// ==============================================================================
// Clipboard Failures
// ==============================================================================

/// Failure that occurs during clipboard operations.
///
/// Example:
/// ```dart
/// return Left(ClipboardFailure('Failed to copy image to clipboard'));
/// ```
class ClipboardFailure extends Failure {
  /// Creates a clipboard failure with a message.
  const ClipboardFailure([super.message = 'Clipboard operation failed']);
}

// ==============================================================================
// Network Failures (for future use)
// ==============================================================================

/// Failure that occurs during network operations.
///
/// This is reserved for future features that may require network access.
///
/// Example:
/// ```dart
/// return Left(NetworkFailure('No internet connection'));
/// ```
class NetworkFailure extends Failure {
  /// Creates a network failure with a message.
  const NetworkFailure([super.message = 'Network operation failed']);
}

// ==============================================================================
// Permission Failures
// ==============================================================================

/// Failure that occurs when required permissions are not granted.
///
/// Example:
/// ```dart
/// return Left(PermissionFailure('Storage permission denied'));
/// ```
class PermissionFailure extends Failure {
  /// Creates a permission failure with a message.
  const PermissionFailure([super.message = 'Permission denied']);
}

// ==============================================================================
// Unexpected Failures
// ==============================================================================

/// Failure that occurs when an unexpected error happens.
///
/// This should be used as a last resort when the specific type
/// of failure cannot be determined.
///
/// Example:
/// ```dart
/// return Left(UnexpectedFailure('An unexpected error occurred'));
/// ```
class UnexpectedFailure extends Failure {
  /// Creates an unexpected failure with a message.
  const UnexpectedFailure([super.message = 'An unexpected error occurred']);
}
