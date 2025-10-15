/// Image format constants and utilities for the Pictogram application.
///
/// This file defines all supported image formats, their MIME types,
/// file extensions, and provides helper methods for format validation.
library;

/// Supported image formats in the application.
enum ImageFormat {
  /// JPEG image format
  jpeg,

  /// PNG image format
  png,

  /// GIF image format
  gif,

  /// BMP image format
  bmp,

  /// WebP image format
  webp,
}

/// Extension methods for ImageFormat enum.
extension ImageFormatExtension on ImageFormat {
  /// Gets the display name for the image format.
  String get displayName {
    switch (this) {
      case ImageFormat.jpeg:
        return 'JPEG';
      case ImageFormat.png:
        return 'PNG';
      case ImageFormat.gif:
        return 'GIF';
      case ImageFormat.bmp:
        return 'BMP';
      case ImageFormat.webp:
        return 'WebP';
    }
  }

  /// Gets the primary MIME type for the image format.
  String get mimeType {
    switch (this) {
      case ImageFormat.jpeg:
        return 'image/jpeg';
      case ImageFormat.png:
        return 'image/png';
      case ImageFormat.gif:
        return 'image/gif';
      case ImageFormat.bmp:
        return 'image/bmp';
      case ImageFormat.webp:
        return 'image/webp';
    }
  }

  /// Gets the primary file extension for the image format (with dot).
  String get extension {
    switch (this) {
      case ImageFormat.jpeg:
        return '.jpg';
      case ImageFormat.png:
        return '.png';
      case ImageFormat.gif:
        return '.gif';
      case ImageFormat.bmp:
        return '.bmp';
      case ImageFormat.webp:
        return '.webp';
    }
  }

  /// Gets all possible file extensions for the image format.
  List<String> get allExtensions {
    switch (this) {
      case ImageFormat.jpeg:
        return ['.jpg', '.jpeg', '.jpe', '.jfif'];
      case ImageFormat.png:
        return ['.png'];
      case ImageFormat.gif:
        return ['.gif'];
      case ImageFormat.bmp:
        return ['.bmp', '.dib'];
      case ImageFormat.webp:
        return ['.webp'];
    }
  }
}

/// Image format constants and validation utilities.
class ImageFormats {
  // Private constructor to prevent instantiation
  ImageFormats._();

  // ============================================================================
  // Supported Formats
  // ============================================================================

  /// List of all supported image formats.
  static const List<ImageFormat> supportedFormats = [
    ImageFormat.jpeg,
    ImageFormat.png,
    ImageFormat.gif,
    ImageFormat.bmp,
    ImageFormat.webp,
  ];

  // ============================================================================
  // MIME Type Mappings
  // ============================================================================

  /// Map of MIME types to image formats.
  static const Map<String, ImageFormat> mimeTypeToFormat = {
    'image/jpeg': ImageFormat.jpeg,
    'image/jpg': ImageFormat.jpeg,
    'image/png': ImageFormat.png,
    'image/gif': ImageFormat.gif,
    'image/bmp': ImageFormat.bmp,
    'image/x-ms-bmp': ImageFormat.bmp,
    'image/webp': ImageFormat.webp,
  };

  /// Map of image formats to their primary MIME type.
  static const Map<ImageFormat, String> formatToMimeType = {
    ImageFormat.jpeg: 'image/jpeg',
    ImageFormat.png: 'image/png',
    ImageFormat.gif: 'image/gif',
    ImageFormat.bmp: 'image/bmp',
    ImageFormat.webp: 'image/webp',
  };

  /// List of all supported MIME types.
  static const List<String> supportedMimeTypes = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/gif',
    'image/bmp',
    'image/x-ms-bmp',
    'image/webp',
  ];

  // ============================================================================
  // File Extension Mappings
  // ============================================================================

  /// Map of file extensions to image formats.
  /// Extensions are lowercase and include the dot.
  static const Map<String, ImageFormat> extensionToFormat = {
    '.jpg': ImageFormat.jpeg,
    '.jpeg': ImageFormat.jpeg,
    '.jpe': ImageFormat.jpeg,
    '.jfif': ImageFormat.jpeg,
    '.png': ImageFormat.png,
    '.gif': ImageFormat.gif,
    '.bmp': ImageFormat.bmp,
    '.dib': ImageFormat.bmp,
    '.webp': ImageFormat.webp,
  };

  /// Map of image formats to their primary file extension.
  static const Map<ImageFormat, String> formatToExtension = {
    ImageFormat.jpeg: '.jpg',
    ImageFormat.png: '.png',
    ImageFormat.gif: '.gif',
    ImageFormat.bmp: '.bmp',
    ImageFormat.webp: '.webp',
  };

  /// List of all supported file extensions (lowercase with dot).
  static const List<String> supportedExtensions = [
    '.jpg',
    '.jpeg',
    '.jpe',
    '.jfif',
    '.png',
    '.gif',
    '.bmp',
    '.dib',
    '.webp',
  ];

  // ============================================================================
  // Accept Strings for File Input
  // ============================================================================

  /// Accept string for HTML file input (comma-separated MIME types).
  static const String fileInputAccept =
      'image/jpeg,image/png,image/gif,image/bmp,image/webp';

  /// Accept string with file extensions for HTML file input.
  static const String fileInputAcceptExtensions =
      '.jpg,.jpeg,.jpe,.jfif,.png,.gif,.bmp,.dib,.webp';

  // ============================================================================
  // Validation Methods
  // ============================================================================

  /// Checks if a MIME type is supported.
  ///
  /// Example:
  /// ```dart
  /// final isValid = ImageFormats.isMimeTypeSupported('image/jpeg');
  /// print(isValid); // true
  /// ```
  static bool isMimeTypeSupported(String mimeType) {
    return supportedMimeTypes.contains(mimeType.toLowerCase());
  }

  /// Checks if a file extension is supported.
  ///
  /// The extension can be provided with or without a leading dot.
  /// The check is case-insensitive.
  ///
  /// Example:
  /// ```dart
  /// final isValid = ImageFormats.isExtensionSupported('jpg');
  /// print(isValid); // true
  /// ```
  static bool isExtensionSupported(String extension) {
    final normalizedExt = extension.toLowerCase().startsWith('.')
        ? extension.toLowerCase()
        : '.$extension'.toLowerCase();
    return supportedExtensions.contains(normalizedExt);
  }

  /// Checks if a filename has a supported image extension.
  ///
  /// Example:
  /// ```dart
  /// final isValid = ImageFormats.isFileNameSupported('photo.jpg');
  /// print(isValid); // true
  /// ```
  static bool isFileNameSupported(String fileName) {
    final extension = getFileExtension(fileName);
    return extension != null && isExtensionSupported(extension);
  }

  /// Gets the file extension from a filename.
  ///
  /// Returns null if no extension is found.
  /// The returned extension includes the dot and is lowercase.
  ///
  /// Example:
  /// ```dart
  /// final ext = ImageFormats.getFileExtension('photo.JPG');
  /// print(ext); // '.jpg'
  /// ```
  static String? getFileExtension(String fileName) {
    final lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex == -1 || lastDotIndex == fileName.length - 1) {
      return null;
    }
    return fileName.substring(lastDotIndex).toLowerCase();
  }

  /// Gets the image format from a MIME type.
  ///
  /// Returns null if the MIME type is not supported.
  ///
  /// Example:
  /// ```dart
  /// final format = ImageFormats.getFormatFromMimeType('image/png');
  /// print(format?.displayName); // 'PNG'
  /// ```
  static ImageFormat? getFormatFromMimeType(String mimeType) {
    return mimeTypeToFormat[mimeType.toLowerCase()];
  }

  /// Gets the image format from a file extension.
  ///
  /// Returns null if the extension is not supported.
  /// The extension can be provided with or without a leading dot.
  ///
  /// Example:
  /// ```dart
  /// final format = ImageFormats.getFormatFromExtension('.jpg');
  /// print(format?.displayName); // 'JPEG'
  /// ```
  static ImageFormat? getFormatFromExtension(String extension) {
    final normalizedExt = extension.toLowerCase().startsWith('.')
        ? extension.toLowerCase()
        : '.$extension'.toLowerCase();
    return extensionToFormat[normalizedExt];
  }

  /// Gets the image format from a filename.
  ///
  /// Returns null if the filename has no extension or an unsupported extension.
  ///
  /// Example:
  /// ```dart
  /// final format = ImageFormats.getFormatFromFileName('photo.png');
  /// print(format?.displayName); // 'PNG'
  /// ```
  static ImageFormat? getFormatFromFileName(String fileName) {
    final extension = getFileExtension(fileName);
    if (extension == null) return null;
    return getFormatFromExtension(extension);
  }

  /// Gets the MIME type for a given file extension.
  ///
  /// Returns null if the extension is not supported.
  ///
  /// Example:
  /// ```dart
  /// final mimeType = ImageFormats.getMimeTypeFromExtension('.png');
  /// print(mimeType); // 'image/png'
  /// ```
  static String? getMimeTypeFromExtension(String extension) {
    final format = getFormatFromExtension(extension);
    return format?.mimeType;
  }

  /// Gets the MIME type for a given filename.
  ///
  /// Returns null if the filename has no extension or an unsupported extension.
  ///
  /// Example:
  /// ```dart
  /// final mimeType = ImageFormats.getMimeTypeFromFileName('photo.jpg');
  /// print(mimeType); // 'image/jpeg'
  /// ```
  static String? getMimeTypeFromFileName(String fileName) {
    final extension = getFileExtension(fileName);
    if (extension == null) return null;
    return getMimeTypeFromExtension(extension);
  }

  /// Gets a human-readable string of supported formats.
  ///
  /// Example:
  /// ```dart
  /// final formats = ImageFormats.getSupportedFormatsString();
  /// print(formats); // 'JPEG, PNG, GIF, BMP, WebP'
  /// ```
  static String getSupportedFormatsString() {
    return supportedFormats.map((f) => f.displayName).join(', ');
  }

  /// Gets a human-readable string of supported file extensions.
  ///
  /// Example:
  /// ```dart
  /// final extensions = ImageFormats.getSupportedExtensionsString();
  /// print(extensions); // '.jpg, .jpeg, .jpe, .jfif, .png, .gif, .bmp, .dib, .webp'
  /// ```
  static String getSupportedExtensionsString() {
    return supportedExtensions.join(', ');
  }

  /// Validates if a file is a supported image based on both extension and MIME type.
  ///
  /// Returns true only if both the filename extension and MIME type are supported
  /// and match the same image format.
  ///
  /// Example:
  /// ```dart
  /// final isValid = ImageFormats.validateFile('photo.jpg', 'image/jpeg');
  /// print(isValid); // true
  /// ```
  static bool validateFile(String fileName, String mimeType) {
    final formatFromName = getFormatFromFileName(fileName);
    final formatFromMime = getFormatFromMimeType(mimeType);

    if (formatFromName == null || formatFromMime == null) {
      return false;
    }

    // Both should identify the same format
    return formatFromName == formatFromMime;
  }
}
