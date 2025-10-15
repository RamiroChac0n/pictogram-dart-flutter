import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/image_item.dart';
import '../repositories/gallery_repository.dart';

/// Use case for loading multiple images from file paths
///
/// This use case handles loading images that were selected via file picker
/// or drag & drop operations.
class LoadImagesUseCase {
  final GalleryRepository repository;

  LoadImagesUseCase(this.repository);

  /// Execute the use case
  ///
  /// Parameters:
  /// - paths: List of file paths to load
  ///
  /// Returns Either<Failure, List<ImageItem>>
  Future<Either<Failure, List<ImageItem>>> call(List<String> paths) async {
    if (paths.isEmpty) {
      return Left(ValidationFailure('No image paths provided'));
    }

    return await repository.loadImages(paths);
  }
}
