part of 'gallery_bloc.dart';

abstract class GalleryEvent {}

class LoadGallery extends GalleryEvent {
  final List<Map<String, dynamic>> files;
  LoadGallery(this.files);
}

class SelectThumbnail extends GalleryEvent {
  final String id;
  SelectThumbnail(this.id);
}
