import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/constants/app_constants.dart';
import '../entities/thumbnail.dart';
import '../repositories/gallery_repository.dart';

/// Use case for generating a thumbnail from an image
///
/// This use case creates 140x120px thumbnails with center cropping
/// for efficient gallery display.
class GenerateThumbnailUseCase {
  final GalleryRepository repository;

  // Default thumbnail dimensions (as per requirements)
  static const int defaultWidth = 140;
  static const int defaultHeight = 120;

  GenerateThumbnailUseCase(this.repository);

  /// Execute the use case
  ///
  /// Parameters:
  /// - imagePath: Path to the original image
  /// - targetWidth: Optional custom width (defaults to 140px)
  /// - targetHeight: Optional custom height (defaults to 120px)
  ///
  /// Returns Either<Failure, Thumbnail>
  Future<Either<Failure, Thumbnail>> call(
    String imagePath, {
    int? targetWidth,
    int? targetHeight,
  }) async {
    if (imagePath.isEmpty) {
      return Left(ValidationFailure('Image path cannot be empty'));
    }

    return await repository.generateThumbnail(
      imagePath,
      targetWidth: targetWidth ?? defaultWidth,
      targetHeight: targetHeight ?? defaultHeight,
    );
  }

  /// Generate thumbnails for multiple images
  ///
  /// This is a batch operation for efficiency
  Future<Either<Failure, Map<String, Thumbnail>>> callBatch(
    List<String> imagePaths, {
    int? targetWidth,
    int? targetHeight,
  }) async {
    if (imagePaths.isEmpty) {
      return Left(ValidationFailure('No image paths provided'));
    }

    return await repository.generateThumbnails(
      imagePaths,
      targetWidth: targetWidth ?? defaultWidth,
      targetHeight: targetHeight ?? defaultHeight,
    );
  }
}
