import 'dart:typed_data';
import 'package:equatable/equatable.dart';

/// Thumbnail entity representing a small preview of an image
///
/// This entity contains the thumbnail data and metadata
/// for efficient display in gallery grid views.
class Thumbnail extends Equatable {
  /// Thumbnail image bytes (already resized to thumbnail dimensions)
  final Uint8List bytes;

  /// Width of the thumbnail in pixels
  final int width;

  /// Height of the thumbnail in pixels
  final int height;

  /// Format of the thumbnail (usually PNG for quality)
  final String format;

  /// Size of the thumbnail in bytes
  int get sizeInBytes => bytes.length;

  const Thumbnail({
    required this.bytes,
    required this.width,
    required this.height,
    this.format = 'PNG',
  });

  @override
  List<Object?> get props => [bytes, width, height, format];

  /// Create a copy with modified fields
  Thumbnail copyWith({
    Uint8List? bytes,
    int? width,
    int? height,
    String? format,
  }) {
    return Thumbnail(
      bytes: bytes ?? this.bytes,
      width: width ?? this.width,
      height: height ?? this.height,
      format: format ?? this.format,
    );
  }

  @override
  String toString() {
    return 'Thumbnail(${width}x$height, ${format}, ${sizeInBytes} bytes)';
  }
}
