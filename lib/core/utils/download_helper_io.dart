import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';

/// Helper para descargas locales en Windows, macOS y Linux.
class DownloadHelper {
  const DownloadHelper();

  Future<void> downloadImage({
    required Uint8List imageBytes,
    required String fileName,
    required String mimeType,
  }) async {
    try {
      // Detectar extensión
      final ext = fileName.contains('.') ? fileName.split('.').last : _mimeToExt(mimeType);

      // Mapeo de MIME string → MimeType enum soportado
      final mimeEnum = _mapMimeType(mimeType);

      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: imageBytes,
        ext: ext,
        mimeType: mimeEnum,
      );

      print('✅ Archivo guardado: $fileName');
    } catch (e) {
      print('❌ Error guardando archivo: $e');
      rethrow;
    }
  }

  // Mapea el tipo MIME a un valor soportado por FileSaver
  MimeType _mapMimeType(String mimeType) {
    if (mimeType.contains('png')) return MimeType.png;
    if (mimeType.contains('jpeg') || mimeType.contains('jpg')) return MimeType.jpeg;
    if (mimeType.contains('bmp')) return MimeType.bmp;
    if (mimeType.contains('gif')) return MimeType.gif;
    // ⚠️ FileSaver no tiene soporte directo para WEBP → se usa genérico
    if (mimeType.contains('webp')) return MimeType.other;
    return MimeType.other;
  }

  // Mapea la extensión según el MIME
  String _mimeToExt(String mimeType) {
    if (mimeType.contains('png')) return 'png';
    if (mimeType.contains('jpeg') || mimeType.contains('jpg')) return 'jpg';
    if (mimeType.contains('bmp')) return 'bmp';
    if (mimeType.contains('gif')) return 'gif';
    if (mimeType.contains('webp')) return 'webp';
    return 'bin';
  }
}
