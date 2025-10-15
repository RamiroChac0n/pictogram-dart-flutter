import 'dart:typed_data';
import 'package:flutter/material.dart';
import '/../../core/entities/thumbnail_entity.dart';

class ThumbnailItem extends StatelessWidget {
  final ThumbnailEntity entity;
  final bool selected;
  final VoidCallback onTap;

  const ThumbnailItem({
    super.key,
    required this.entity,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(entity.bytes, fit: BoxFit.cover),
          if (selected)
            Container(
              color: Colors.black26,
              child: const Icon(Icons.check_circle, color: Colors.white),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              child: Text(
                entity.filename,
                style: const TextStyle(fontSize: 11, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
