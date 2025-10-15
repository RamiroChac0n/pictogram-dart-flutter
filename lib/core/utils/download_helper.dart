/// Download utilities for the Pictogram web application.
///
/// This file provides utilities for downloading processed images
/// using the Blob API and anchor element download mechanism.
library;

import 'dart:html' as html;
import 'dart:typed_data';

import '../constants/image_formats.dart';
import '../errors/exceptions.dart';

/// Helper class for downloading files in the web environment.
class DownloadHelper {
  // Private constructor to prevent instantiation
  DownloadHelper._();

  // ============================================================================
  // Image Download Methods
  // ============================================================================

  /// Downloads an image with the specified bytes, filename, and MIME type.
  ///
  /// This method creates a Blob from the image bytes, generates a download URL,
  /// creates an anchor element, triggers the download, and cleans up resources.
  ///
  /// Parameters:
  /// - [imageBytes]: The raw image data as bytes
  /// - [fileName]: The desired filename for the downloaded file
  /// - [mimeType]: The MIME type of the image (e.g., 'image/png')
  ///
  /// Throws [ImageProcessingException] if the download fails.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await DownloadHelper.downloadImage(
  ///     imageBytes: processedImageBytes,
  ///     fileName: 'edited_photo.png',
  ///     mimeType: 'image/png',
  ///   );
  ///   print('Image downloaded successfully');
  /// } catch (e) {
  ///   print('Download failed: $e');
  /// }
  /// ```
  static Future<void> downloadImage({
    required Uint8List imageBytes,
    required String fileName,
    required String mimeType,
  }) async {
    try {
      // Create a Blob from the image bytes
      final blob = html.Blob([imageBytes], mimeType);

      // Generate a download URL for the Blob
      final url = html.Url.createObjectUrlFromBlob(blob);

      try {
        // Create an anchor element for downloading
        final anchor = html.AnchorElement(href: url)
          ..download = fileName
          ..style.display = 'none';

        // Add the anchor to the document
        html.document.body?.append(anchor);

        // Trigger the download
        anchor.click();

        // Remove the anchor from the document
        anchor.remove();

        // Small delay to ensure download starts before cleanup
        await Future.delayed(const Duration(milliseconds: 100));
      } finally {
        // Revoke the object URL to free memory
        html.Url.revokeObjectUrl(url);
      }
    } catch (e) {
      throw ImageProcessingException(
        'Failed to download image: ${e.toString()}',
      );
    }
  }

  /// Downloads an image using a data URL.
  ///
  /// This is an alternative method that works with base64-encoded data URLs.
  ///
  /// Parameters:
  /// - [dataUrl]: The data URL containing the image data
  /// - [fileName]: The desired filename for the downloaded file
  ///
  /// Throws [ImageProcessingException] if the download fails.
  ///
  /// Example:
  /// ```dart
  /// await DownloadHelper.downloadImageFromDataUrl(
  ///   dataUrl: 'data:image/png;base64,...',
  ///   fileName: 'photo.png',
  /// );
  /// ```
  static Future<void> downloadImageFromDataUrl({
    required String dataUrl,
    required String fileName,
  }) async {
    try {
      // Create an anchor element for downloading
      final anchor = html.AnchorElement(href: dataUrl)
        ..download = fileName
        ..style.display = 'none';

      // Add the anchor to the document
      html.document.body?.append(anchor);

      // Trigger the download
      anchor.click();

      // Remove the anchor from the document
      anchor.remove();

      // Small delay to ensure download starts
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      throw ImageProcessingException(
        'Failed to download image from data URL: ${e.toString()}',
      );
    }
  }

  // ============================================================================
  // Filename Utilities
  // ============================================================================

  /// Ensures a filename has the correct extension for the given MIME type.
  ///
  /// If the filename already has a correct extension, it is returned unchanged.
  /// Otherwise, the appropriate extension is added.
  ///
  /// Example:
  /// ```dart
  /// final name = DownloadHelper.ensureCorrectExtension(
  ///   'photo',
  ///   'image/png',
  /// );
  /// print(name); // 'photo.png'
  /// ```
  static String ensureCorrectExtension(String fileName, String mimeType) {
    final format = ImageFormats.getFormatFromMimeType(mimeType);
    if (format == null) {
      return fileName;
    }

    final currentExtension = ImageFormats.getFileExtension(fileName);
    final currentFormat = currentExtension != null
        ? ImageFormats.getFormatFromExtension(currentExtension)
        : null;

    // If the file already has the correct extension, return as is
    if (currentFormat == format) {
      return fileName;
    }

    // Remove existing extension if present
    String baseFileName = fileName;
    if (currentExtension != null) {
      baseFileName = fileName.substring(
        0,
        fileName.length - currentExtension.length,
      );
    }

    // Add the correct extension
    return '$baseFileName${format.extension}';
  }

  /// Adds a suffix to a filename before the extension.
  ///
  /// This is useful for creating modified versions of files
  /// (e.g., "photo.jpg" -> "photo_edited.jpg").
  ///
  /// Example:
  /// ```dart
  /// final name = DownloadHelper.addFilenameSuffix(
  ///   'photo.jpg',
  ///   '_edited',
  /// );
  /// print(name); // 'photo_edited.jpg'
  /// ```
  static String addFilenameSuffix(String fileName, String suffix) {
    final extension = ImageFormats.getFileExtension(fileName);

    if (extension != null) {
      final baseName = fileName.substring(
        0,
        fileName.length - extension.length,
      );
      return '$baseName$suffix$extension';
    }

    return '$fileName$suffix';
  }

  /// Generates a unique filename by adding a timestamp.
  ///
  /// Example:
  /// ```dart
  /// final name = DownloadHelper.generateUniqueFilename('photo.jpg');
  /// print(name); // 'photo_20250315_143022.jpg'
  /// ```
  static String generateUniqueFilename(String fileName) {
    final now = DateTime.now();
    final timestamp = '${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';

    return addFilenameSuffix(fileName, '_$timestamp');
  }

  /// Sanitizes a filename by removing or replacing invalid characters.
  ///
  /// This ensures the filename is safe for use across different platforms.
  ///
  /// Example:
  /// ```dart
  /// final name = DownloadHelper.sanitizeFilename('photo:test?.jpg');
  /// print(name); // 'photo_test_.jpg'
  /// ```
  static String sanitizeFilename(String fileName) {
    // Replace invalid characters with underscores
    final sanitized = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');

    // Remove control characters
    return sanitized.replaceAll(RegExp(r'[\x00-\x1f\x80-\x9f]'), '');
  }

  // ============================================================================
  // Batch Download
  // ============================================================================

  /// Downloads multiple images sequentially.
  ///
  /// This method adds a small delay between downloads to prevent browser
  /// restrictions on simultaneous downloads.
  ///
  /// Parameters:
  /// - [images]: List of image data and metadata for downloading
  /// - [delayBetweenDownloads]: Optional delay between downloads (default: 500ms)
  /// - [onProgress]: Optional callback to track download progress
  ///
  /// Example:
  /// ```dart
  /// await DownloadHelper.downloadMultipleImages(
  ///   images: [
  ///     ImageDownloadData(bytes: bytes1, fileName: 'photo1.jpg', mimeType: 'image/jpeg'),
  ///     ImageDownloadData(bytes: bytes2, fileName: 'photo2.jpg', mimeType: 'image/jpeg'),
  ///   ],
  ///   onProgress: (current, total) {
  ///     print('Downloaded $current of $total');
  ///   },
  /// );
  /// ```
  static Future<void> downloadMultipleImages({
    required List<ImageDownloadData> images,
    Duration delayBetweenDownloads = const Duration(milliseconds: 500),
    void Function(int current, int total)? onProgress,
  }) async {
    for (var i = 0; i < images.length; i++) {
      final image = images[i];

      await downloadImage(
        imageBytes: image.bytes,
        fileName: image.fileName,
        mimeType: image.mimeType,
      );

      if (onProgress != null) {
        onProgress(i + 1, images.length);
      }

      // Add delay between downloads (except after the last one)
      if (i < images.length - 1) {
        await Future.delayed(delayBetweenDownloads);
      }
    }
  }
}

/// Data class for batch image downloads.
class ImageDownloadData {
  /// Creates image download data.
  const ImageDownloadData({
    required this.bytes,
    required this.fileName,
    required this.mimeType,
  });

  /// The raw image data.
  final Uint8List bytes;

  /// The desired filename.
  final String fileName;

  /// The MIME type of the image.
  final String mimeType;
}
