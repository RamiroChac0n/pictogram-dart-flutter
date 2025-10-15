import 'dart:typed_data';

class ThumbnailEntity {
  final String id;
  final String filename;
  final Uint8List bytes;

  ThumbnailEntity({
    required this.id,
    required this.filename,
    required this.bytes,
  });
}
