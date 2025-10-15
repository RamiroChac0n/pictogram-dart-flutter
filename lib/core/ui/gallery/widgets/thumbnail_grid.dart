import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pictogram_dart_flutter/core/bloc/gallery_bloc.dart';
import '/../core/entities/thumbnail_entity.dart';
import 'thumbnail_item.dart';

class ThumbnailGrid extends StatelessWidget {
  final List<ThumbnailEntity> thumbnails;
  final String? selectedId;

  const ThumbnailGrid({
    super.key,
    required this.thumbnails,
    this.selectedId,
  });

  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 8; // Desktop
    if (width > 800) return 6;  // Tablet
    if (width > 600) return 4;
    return 2; // Mobile
    }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: thumbnails.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _calculateCrossAxisCount(context),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 140 / 120,
      ),
      itemBuilder: (context, index) {
        final thumb = thumbnails[index];
        final selected = thumb.id == selectedId;
        return ThumbnailItem(
          entity: thumb,
          selected: selected,
          onTap: () {
            context.read<GalleryBloc>().add(SelectThumbnail(thumb.id));
          },
        );
      },
    );
  }
}
