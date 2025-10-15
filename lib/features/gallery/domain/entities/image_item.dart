import 'package:equatable/equatable.dart';
import 'thumbnail.dart';

/// Image item entity representing a single image in the gallery
///
/// This entity contains all metadata about an image including its
/// thumbnail for grid display.
class ImageItem extends Equatable {
  /// Unique identifier for the image (typically the file path)
  final String id;

  /// Full file path to the image
  final String path;

  /// File name (without path)
  final String name;

  /// Image width in pixels
  final int width;

  /// Image height in pixels
  final int height;

  /// Image format (JPG, PNG, GIF, BMP, WEBP)
  final String format;

  /// File size in bytes
  final int sizeInBytes;

  /// Last modified date
  final DateTime lastModified;

  /// Optional thumbnail for gallery display
  final Thumbnail? thumbnail;

  /// Whether this image is currently selected
  final bool isSelected;

  /// Aspect ratio (width / height)
  double get aspectRatio => width / height;

  /// File extension (derived from format)
  String get extension {
    switch (format.toUpperCase()) {
      case 'JPG':
      case 'JPEG':
        return '.jpg';
      case 'PNG':
        return '.png';
      case 'GIF':
        return '.gif';
      case 'BMP':
        return '.bmp';
      case 'WEBP':
        return '.webp';
      default:
        return '.jpg';
    }
  }

  /// Check if thumbnail is available
  bool get hasThumbnail => thumbnail != null;

  const ImageItem({
    required this.id,
    required this.path,
    required this.name,
    required this.width,
    required this.height,
    required this.format,
    required this.sizeInBytes,
    required this.lastModified,
    this.thumbnail,
    this.isSelected = false,
  });

  @override
  List<Object?> get props => [
        id,
        path,
        name,
        width,
        height,
        format,
        sizeInBytes,
        lastModified,
        thumbnail,
        isSelected,
      ];

  /// Create a copy with modified fields
  ImageItem copyWith({
    String? id,
    String? path,
    String? name,
    int? width,
    int? height,
    String? format,
    int? sizeInBytes,
    DateTime? lastModified,
    Thumbnail? thumbnail,
    bool? isSelected,
  }) {
    return ImageItem(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      width: width ?? this.width,
      height: height ?? this.height,
      format: format ?? this.format,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      lastModified: lastModified ?? this.lastModified,
      thumbnail: thumbnail ?? this.thumbnail,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  String toString() {
    return 'ImageItem(id: $id, name: $name, ${width}x$height, $format, '
        'thumbnail: ${hasThumbnail ? "yes" : "no"})';
  }

  /// Format file size in human-readable format
  String get formattedSize {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// Format dimensions as string
  String get formattedDimensions => '${width}x$height';
}
