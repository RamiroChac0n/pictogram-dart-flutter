import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/image_item.dart';
import '../repositories/gallery_repository.dart';

/// Use case for loading all images from a folder
///
/// This use case handles loading entire folders of images,
/// useful for batch operations.
class LoadFolderUseCase {
  final GalleryRepository repository;

  LoadFolderUseCase(this.repository);

  /// Execute the use case
  ///
  /// Parameters:
  /// - folderPath: Path to the folder containing images
  ///
  /// Returns Either<Failure, List<ImageItem>>
  Future<Either<Failure, List<ImageItem>>> call(String folderPath) async {
    if (folderPath.isEmpty) {
      return Left(ValidationFailure('Folder path cannot be empty'));
    }

    return await repository.loadFolder(folderPath);
  }
}
