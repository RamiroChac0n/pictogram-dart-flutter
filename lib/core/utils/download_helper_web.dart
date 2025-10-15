import 'dart:typed_data';
import 'dart:html' as html;

/// Helper para descargas dentro del navegador web (usa Blob API).
class DownloadHelper {
  const DownloadHelper();

  /// Descarga un archivo usando un enlace temporal HTML.
  Future<void> downloadImage({
    required Uint8List imageBytes,
    required String fileName,
    required String mimeType,
  }) async {
    try {
      final blob = html.Blob([imageBytes], mimeType);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url)
        ..download = fileName
        ..style.display = 'none';

      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();

      await Future.delayed(const Duration(milliseconds: 100));
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print('❌ Error descargando en Web: $e');
      rethrow;
    }
  }
}
