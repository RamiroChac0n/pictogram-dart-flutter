import 'dart:typed_data';
import '../entities/edit_operation.dart';
import '../enums/transformation.dart';
import '../services/image_processor.dart';

class ResizeImageUseCase {
  final ImageProcessor processor;
  ResizeImageUseCase(this.processor);

  ImageProcessorResult call({
    required Uint8List originalBytes,
    required List<EditOperation> operations,
    required int? width,
    required int? height, // pasa solo uno para mantener proporción
    required OutputFormat targetFormat,
    int? jpgQuality,
  }) {
    final op = EditOperation(
      type: TransformationType.resize,
      params: {
        if (width != null) 'width': width,
        if (height != null) 'height': height,
      },
    );
    final newOps = [...operations, op];
    return processor.applyPipeline(
      originalBytes: originalBytes,
      operations: newOps,
      targetFormat: targetFormat,
      jpgQuality: jpgQuality,
    );
  }
}
