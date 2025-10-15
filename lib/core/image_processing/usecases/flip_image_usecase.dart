import 'dart:typed_data';
import '../entities/edit_operation.dart';
import '../enums/transformation.dart';
import '../services/image_processor.dart';

class FlipImageUseCase {
  final ImageProcessor processor;
  FlipImageUseCase(this.processor);

  ImageProcessorResult call({
    required Uint8List originalBytes,
    required List<EditOperation> operations,
    required bool horizontal, // true → flipH; false → flipV
    required OutputFormat targetFormat,
    int? jpgQuality,
  }) {
    final op = EditOperation(
      type: horizontal ? TransformationType.flipHorizontal : TransformationType.flipVertical,
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
