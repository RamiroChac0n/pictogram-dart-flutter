part of 'gallery_bloc.dart';

abstract class GalleryState {}

class GalleryInitial extends GalleryState {}
class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<ThumbnailEntity> thumbnails;
  final String? selectedId;

  GalleryLoaded({required this.thumbnails, this.selectedId});

  GalleryLoaded copyWith({List<ThumbnailEntity>? thumbnails, String? selectedId}) {
    return GalleryLoaded(
      thumbnails: thumbnails ?? this.thumbnails,
      selectedId: selectedId ?? this.selectedId,
    );
  }
}
