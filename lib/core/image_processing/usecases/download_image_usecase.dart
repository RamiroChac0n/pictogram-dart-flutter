import 'dart:typed_data';
import '../services/image_processor.dart';
import '../enums/transformation.dart';
import '../entities/edit_operation.dart';
import '../../utils/download_helper.dart';

class DownloadImageUseCase {
  final ImageProcessor processor;
  final DownloadHelper downloader; // clase concreta (ver utils)

  DownloadImageUseCase(this.processor, this.downloader);

  Future<void> call({
    required Uint8List originalBytes,
    required List<EditOperation> operations,
    required OutputFormat format,
    required String filenameBase,
    int? jpgQuality,
  }) async {
    final res = processor.applyPipeline(
      originalBytes: originalBytes,
      operations: operations,
      targetFormat: format,
      jpgQuality: jpgQuality,
    );
    final name = '$filenameBase.${format.extension}';
    await DownloadHelper.downloadImage(
      imageBytes: res.bytes,
      fileName: name,
      mimeType: format.mimeType,
    );
  }
}
