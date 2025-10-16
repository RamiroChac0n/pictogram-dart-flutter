import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/../core/bloc/gallery_bloc.dart';
import 'widgets/thumbnail_grid.dart';
import 'widgets/gallery_header.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GalleryBloc, GalleryState>(
      builder: (context, state) {
        if (state is GalleryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GalleryLoaded) {
          return Column(
            children: [
              GalleryHeader(
                total: state.thumbnails.length,
                path: "Galería virtual",
              ),
              Expanded(
                child: ThumbnailGrid(
                  thumbnails: state.thumbnails,
                  selectedId: state.selectedId,
                ),
              ),
            ],
          );
        }

        return const Center(child: Text('Cargando galería...'));
      },
    );
  }
}
