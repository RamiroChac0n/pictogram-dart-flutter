enum TransformationType {
  rotateRight,
  rotateLeft,
  flipHorizontal,
  flipVertical,
  resize,
  convertFormat,
}

enum OutputFormat { jpg, png, bmp, gif, webp }

extension OutputFormatX on OutputFormat {
  String get extension {
    switch (this) {
      case OutputFormat.jpg: return 'jpg';
      case OutputFormat.png: return 'png';
      case OutputFormat.bmp: return 'bmp';
      case OutputFormat.gif: return 'gif';
      case OutputFormat.webp: return 'webp';
    }
  }

  String get mimeType {
    switch (this) {
      case OutputFormat.jpg: return 'image/jpeg';
      case OutputFormat.png: return 'image/png';
      case OutputFormat.bmp: return 'image/bmp';
      case OutputFormat.gif: return 'image/gif';
      case OutputFormat.webp: return 'image/webp';
    }
  }
}
