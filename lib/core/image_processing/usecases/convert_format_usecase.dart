import 'dart:typed_data';
import '../entities/edit_operation.dart';
import '../enums/transformation.dart';
import '../services/image_processor.dart';

class ConvertFormatUseCase {
  final ImageProcessor processor;
  ConvertFormatUseCase(this.processor);

  ImageProcessorResult call({
    required Uint8List originalBytes,
    required List<EditOperation> operations,
    required OutputFormat newFormat,
    int? jpgQuality,
  }) {
    // Añadimos op para historial, aunque no cambia pixeles.
    final op = EditOperation(type: TransformationType.convertFormat, params: {
      'to': newFormat.name,
    });
    final newOps = [...operations, op];
    return processor.applyPipeline(
      originalBytes: originalBytes,
      operations: newOps,
      targetFormat: newFormat,
      jpgQuality: jpgQuality,
    );
  }
}
