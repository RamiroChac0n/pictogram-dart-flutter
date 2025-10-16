// lib/core/services/web_tools.dart
import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

/// Copia texto plano al portapapeles (web).
Future<void> copyTextToClipboard(String text) async {
  try {
    await html.window.navigator.clipboard?.writeText(text);
  } catch (e) {
    // fallback
    final ta = html.TextAreaElement()..value = text;
    html.document.body!.append(ta);
    ta.select();
    html.document.execCommand('copy');
    ta.remove();
  }
}

/// Copia una imagen dada como bytes al clipboard (web).
/// imageBytes: bytes de la imagen (PNG/JPEG)
Future<void> copyImageToClipboard(Uint8List imageBytes, {String mime = 'image/png'}) async {
  // Use Clipboard API with ClipboardItem if available
  try {
    final blob = html.Blob([imageBytes], mime);
    // dart:html does not have ClipboardItem type, so use JS interop via setData? We'll try to use navigator.clipboard.write with a map via JS.
    // Create object URL and fetch it as blob via clipboard.write with ClipboardItem is not directly available in dart:html.
    // Use legacy approach: write to an invisible img element and use execCommand('copy') which might not work for images in all browsers.
    // Best-effort:
    final data = <String, html.Blob>{mime: blob};
    // @dart:html lacks types for ClipboardItem, but we can use JS interop via `html.window.navigator.clipboard!.write` through js interop
    final dynamic navigator = html.window.navigator;
    if (navigator != null && navigator.clipboard != null && navigator.clipboard.write != null) {
      // Try to call via JS: navigator.clipboard.write([new ClipboardItem({ 'image/png': blob })])
      // We'll use `callMethod` on jsObject if available
      // Fallback: write image URL to clipboard as text (data URL)
      final reader = html.FileReader();
      final completer = Completer<void>();
      reader.onLoad.listen((_) async {
        final dataUrl = reader.result as String;
        try {
          await navigator.clipboard.writeText(dataUrl);
        } catch (_) {
          // fallback to write text
          await copyTextToClipboard(dataUrl);
        }
        completer.complete();
      });
      reader.readAsDataUrl(blob);
      return completer.future;
    } else {
      // fallback: write data URL text
      final reader = html.FileReader();
      final completer = Completer<void>();
      reader.onLoad.listen((_) async {
        final dataUrl = reader.result as String;
        await copyTextToClipboard(dataUrl);
        completer.complete();
      });
      reader.readAsDataUrl(blob);
      return completer.future;
    }
  } catch (e) {
    rethrow;
  }
}

/// Descarga un archivo (nombre + bytes)
void downloadBytes(Uint8List bytes, String filename, {String mime = 'application/octet-stream'}) {
  final blob = html.Blob([bytes], mime);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..download = filename
    ..style.display = 'none';
  html.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
}

/// Imprime la página (o image overlay) en web
void printPage() {
  html.window.print();
}
