import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../entities/thumbnail_entity.dart';
import '../repositories/gallery_repository.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GalleryRepository repository;

  GalleryBloc(this.repository) : super(GalleryInitial()) {
    on<LoadGallery>(_onLoadGallery);
    on<SelectThumbnail>(_onSelectThumbnail);
  }

  Future<void> _onLoadGallery(LoadGallery event, Emitter<GalleryState> emit) async {
    emit(GalleryLoading());
    final thumbnails = <ThumbnailEntity>[];

    for (final file in event.files) {
      final thumb = await repository.generateThumbnail(file['id'], file['name'], file['bytes']);
      thumbnails.add(thumb);
    }

    emit(GalleryLoaded(thumbnails: thumbnails, selectedId: null));
  }

  void _onSelectThumbnail(SelectThumbnail event, Emitter<GalleryState> emit) {
    if (state is GalleryLoaded) {
      emit((state as GalleryLoaded).copyWith(selectedId: event.id));
    }
  }
}
