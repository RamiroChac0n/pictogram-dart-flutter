import 'dart:typed_data';
import 'package:path/path.dart' as p;
import '../constants/image_formats.dart';

/// Utility functions for file operations
///
/// Provides helpers for:
/// - File name manipulation
/// - Path operations
/// - File validation
/// - Extension handling
class FileUtils {
  // Prevent instantiation
  FileUtils._();

  /// Extract filename from full path
  ///
  /// Example: '/path/to/image.png' -> 'image.png'
  static String getFileName(String path) {
    return p.basename(path);
  }

  /// Extract filename without extension
  ///
  /// Example: '/path/to/image.png' -> 'image'
  static String getFileNameWithoutExtension(String path) {
    return p.basenameWithoutExtension(path);
  }

  /// Get file extension
  ///
  /// Example: '/path/to/image.png' -> '.png'
  /// Returns lowercase extension with dot
  static String getExtension(String path) {
    return p.extension(path).toLowerCase();
  }

  /// Get directory path from full path
  ///
  /// Example: '/path/to/image.png' -> '/path/to'
  static String getDirectory(String path) {
    return p.dirname(path);
  }

  /// Join path components
  ///
  /// Example: joinPath('/path/to', 'image.png') -> '/path/to/image.png'
  static String joinPath(String part1, String part2, [String? part3]) {
    if (part3 != null) {
      return p.join(part1, part2, part3);
    }
    return p.join(part1, part2);
  }

  /// Change file extension
  ///
  /// Example: changeExtension('/path/to/image.png', '.jpg') -> '/path/to/image.jpg'
  static String changeExtension(String path, String newExtension) {
    final dir = getDirectory(path);
    final nameWithoutExt = getFileNameWithoutExtension(path);
    final ext = newExtension.startsWith('.') ? newExtension : '.$newExtension';
    return p.join(dir, '$nameWithoutExt$ext');
  }

  /// Add suffix to filename
  ///
  /// Example: addSuffix('/path/to/image.png', '-resize') -> '/path/to/image-resize.png'
  static String addSuffix(String path, String suffix) {
    final dir = getDirectory(path);
    final nameWithoutExt = getFileNameWithoutExtension(path);
    final ext = getExtension(path);
    return p.join(dir, '$nameWithoutExt$suffix$ext');
  }

  /// Sanitize filename for safe file system use
  ///
  /// Removes or replaces invalid characters
  static String sanitizeFileName(String fileName) {
    // Replace invalid characters with underscore
    return fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
  }

  /// Check if path is absolute
  static bool isAbsolute(String path) {
    return p.isAbsolute(path);
  }

  /// Normalize path (resolve .., ., etc.)
  static String normalize(String path) {
    return p.normalize(path);
  }

  /// Check if file extension is a supported image format
  static bool isSupportedImageFormat(String path) {
    final ext = getExtension(path);
    return ImageFormats.supportedExtensions.contains(ext);
  }

  /// Get image format from file extension
  ///
  /// Returns null if not a recognized image format
  static String? getImageFormat(String path) {
    final ext = getExtension(path);
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return 'JPG';
      case '.png':
        return 'PNG';
      case '.gif':
        return 'GIF';
      case '.bmp':
        return 'BMP';
      case '.webp':
        return 'WEBP';
      default:
        return null;
    }
  }

  /// Format file size in human-readable format
  ///
  /// Example: formatFileSize(1536) -> '1.5 KB'
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Check if file size is within allowed limit
  ///
  /// Uses AppConstants.maxFileSizeBytes as the limit
  static bool isFileSizeValid(int bytes, int maxBytes) {
    return bytes <= maxBytes;
  }

  /// Generate unique filename if file already exists
  ///
  /// Example: 'image.png' -> 'image (1).png' -> 'image (2).png'
  static String generateUniqueFileName(String basePath, List<String> existingFiles) {
    final fileName = getFileName(basePath);

    if (!existingFiles.contains(fileName)) {
      return fileName;
    }

    final nameWithoutExt = getFileNameWithoutExtension(basePath);
    final ext = getExtension(basePath);

    int counter = 1;
    String newFileName;

    do {
      newFileName = '$nameWithoutExt ($counter)$ext';
      counter++;
    } while (existingFiles.contains(newFileName));

    return newFileName;
  }

  /// Validate filename (no invalid characters, not empty)
  static bool isValidFileName(String fileName) {
    if (fileName.isEmpty) return false;

    // Check for invalid characters
    final invalidChars = RegExp(r'[<>:"/\\|?*]');
    if (invalidChars.hasMatch(fileName)) return false;

    // Check for reserved names on Windows
    final reservedNames = ['CON', 'PRN', 'AUX', 'NUL', 'COM1', 'COM2', 'COM3',
                           'COM4', 'COM5', 'COM6', 'COM7', 'COM8', 'COM9',
                           'LPT1', 'LPT2', 'LPT3', 'LPT4', 'LPT5', 'LPT6',
                           'LPT7', 'LPT8', 'LPT9'];
    final nameUpper = getFileNameWithoutExtension(fileName).toUpperCase();
    if (reservedNames.contains(nameUpper)) return false;

    return true;
  }

  /// Extract MIME type from extension
  static String? getMimeType(String path) {
    final ext = getExtension(path);
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.bmp':
        return 'image/bmp';
      case '.webp':
        return 'image/webp';
      default:
        return null;
    }
  }

  /// Create download filename with timestamp
  ///
  /// Example: createDownloadFileName('image', '.png') -> 'image_2025-01-15_143022.png'
  static String createDownloadFileName(String baseName, String extension) {
    final now = DateTime.now();
    final timestamp = '${now.year}-${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';

    final ext = extension.startsWith('.') ? extension : '.$extension';
    return '${baseName}_$timestamp$ext';
  }

  /// Compare file extensions (case-insensitive)
  static bool extensionsMatch(String ext1, String ext2) {
    final e1 = ext1.toLowerCase();
    final e2 = ext2.toLowerCase();

    // Handle extensions with or without dot
    final normalizedE1 = e1.startsWith('.') ? e1 : '.$e1';
    final normalizedE2 = e2.startsWith('.') ? e2 : '.$e2';

    return normalizedE1 == normalizedE2;
  }

  /// Get all files with specific extensions from a list of paths
  static List<String> filterByExtensions(
    List<String> paths,
    List<String> extensions,
  ) {
    return paths.where((path) {
      final ext = getExtension(path);
      return extensions.any((e) => extensionsMatch(ext, e));
    }).toList();
  }

  /// Sort file paths alphabetically by filename
  static List<String> sortByName(List<String> paths, {bool descending = false}) {
    final sorted = List<String>.from(paths);
    sorted.sort((a, b) {
      final nameA = getFileName(a).toLowerCase();
      final nameB = getFileName(b).toLowerCase();
      return descending ? nameB.compareTo(nameA) : nameA.compareTo(nameB);
    });
    return sorted;
  }
}
