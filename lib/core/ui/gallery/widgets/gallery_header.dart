import 'package:flutter/material.dart';

class GalleryHeader extends StatelessWidget {
  final int total;
  final String path;

  const GalleryHeader({super.key, required this.total, required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(path, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text("Imágenes: $total", style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
