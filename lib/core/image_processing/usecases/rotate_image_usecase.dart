import 'dart:typed_data';
import '../entities/edit_operation.dart';
import '../enums/transformation.dart';
import '../services/image_processor.dart';

class RotateImageUseCase {
  final ImageProcessor processor;
  RotateImageUseCase(this.processor);

  ImageProcessorResult call({
    required Uint8List originalBytes,
    required List<EditOperation> operations,
    required bool right, // true → 90° derecha; false → 90° izquierda
    required OutputFormat targetFormat,
    int? jpgQuality,
  }) {
    final op = EditOperation(
      type: right ? TransformationType.rotateRight : TransformationType.rotateLeft,
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
