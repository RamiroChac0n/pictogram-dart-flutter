import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/image_item.dart';
import '../entities/thumbnail.dart';

/// Repository interface for gallery operations
///
/// Defines the contract for loading images and generating thumbnails.
/// Implementation will be provided in the data layer.
abstract class GalleryRepository {
  /// Load multiple images from file paths
  ///
  /// Returns a list of ImageItem entities or a Failure
  Future<Either<Failure, List<ImageItem>>> loadImages(List<String> paths);

  /// Load all images from a folder path
  ///
  /// Returns a list of ImageItem entities or a Failure
  Future<Either<Failure, List<ImageItem>>> loadFolder(String folderPath);

  /// Generate thumbnail for an image
  ///
  /// Parameters:
  /// - imagePath: Path to the original image
  /// - targetWidth: Desired thumbnail width (default 140)
  /// - targetHeight: Desired thumbnail height (default 120)
  ///
  /// Returns a Thumbnail entity or a Failure
  Future<Either<Failure, Thumbnail>> generateThumbnail(
    String imagePath, {
    int targetWidth = 140,
    int targetHeight = 120,
  });

  /// Generate thumbnails for multiple images
  ///
  /// Returns a map of image paths to thumbnails
  Future<Either<Failure, Map<String, Thumbnail>>> generateThumbnails(
    List<String> imagePaths, {
    int targetWidth = 140,
    int targetHeight = 120,
  });

  /// Get image metadata without loading full image data
  ///
  /// Useful for quickly getting image dimensions and format
  Future<Either<Failure, ImageItem>> getImageMetadata(String imagePath);
}
