import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../enums/transformation.dart';
import '../entities/edit_operation.dart';

class ImageProcessorResult {
  final Uint8List bytes;
  final int width;
  final int height;
  final OutputFormat format;

  ImageProcessorResult({
    required this.bytes,
    required this.width,
    required this.height,
    required this.format,
  });
}

class ImageProcessor {
  img.Image _decodeFirstFrame(Uint8List bytes) {
    final gif = img.decodeGif(bytes);
    if (gif != null && gif.numFrames > 0) return gif.frames.first;

    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw StateError('Formato no soportado o bytes inválidos');
    }
    return decoded;
  }

  ImageProcessorResult applyPipeline({
    required Uint8List originalBytes,
    required List<EditOperation> operations,
    required OutputFormat targetFormat,
    int? jpgQuality,
  }) {
    img.Image current = _decodeFirstFrame(originalBytes);

    for (final op in operations) {
      switch (op.type) {
        case TransformationType.rotateRight:
          current = img.copyRotate(current, angle: 90);
          break;
        case TransformationType.rotateLeft:
          current = img.copyRotate(current, angle: -90);
          break;
        case TransformationType.flipHorizontal:
          current = img.flipHorizontal(current);
          break;
        case TransformationType.flipVertical:
          current = img.flipVertical(current);
          break;
        case TransformationType.resize:
          final w = op.params['width'] as int?;
          final h = op.params['height'] as int?;
          if (w == null && h == null) break;
          current = img.copyResize(
            current,
            width: w,
            height: h,
            interpolation: img.Interpolation.linear,
          );
          break;
        case TransformationType.convertFormat:
          // Solo afecta al encoder final
          break;
      }
    }

    final encoded = _encode(current, targetFormat, jpgQuality: jpgQuality);
    return ImageProcessorResult(
      bytes: Uint8List.fromList(encoded),
      width: current.width,
      height: current.height,
      format: targetFormat,
    );
  }

  List<int> _encode(
    img.Image image,
    OutputFormat format, {
    int? jpgQuality,
  }) {
    final q = (jpgQuality ?? 90).clamp(1, 100);
    switch (format) {
      case OutputFormat.jpg:
        return img.encodeJpg(image, quality: q);
      case OutputFormat.png:
        return img.encodePng(image);
      case OutputFormat.bmp:
        return img.encodeBmp(image);
      case OutputFormat.gif:
        return img.encodeGif(image);
      case OutputFormat.webp:
        // ⚠️ WebP encode no disponible en tu build → fallback temporal a PNG.
        // Sugerencia: deshabilitar opción WEBP en el diálogo de formato (ver abajo).
        return img.encodePng(image);
    }
  }
}
