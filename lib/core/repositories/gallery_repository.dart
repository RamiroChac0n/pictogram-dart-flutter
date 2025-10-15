import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../entities/thumbnail_entity.dart';

class GalleryRepository {
  final Map<String, Uint8List> _cache = {};

  Future<ThumbnailEntity> generateThumbnail(String id, String filename, Uint8List originalBytes) async {
    if (_cache.containsKey(id)) {
      return ThumbnailEntity(id: id, filename: filename, bytes: _cache[id]!);
    }

    final image = img.decodeImage(originalBytes);
    if (image == null) throw Exception("No se pudo decodificar la imagen");

    // Redimensionar a 140x120 (crop centrado)
    final cropped = img.copyCrop(
      image,
      x: (image.width - 140) ~/ 2,
      y: (image.height - 120) ~/ 2,
      width: 140,
      height: 120,
    );

    final resized = img.copyResize(cropped, width: 140, height: 120);

    final bytes = Uint8List.fromList(img.encodePng(resized));
    _cache[id] = bytes;

    return ThumbnailEntity(id: id, filename: filename, bytes: bytes);
  }

  int get cacheCount => _cache.length;
  void clearCache() => _cache.clear();
}
