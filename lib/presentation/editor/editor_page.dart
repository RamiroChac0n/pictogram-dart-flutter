import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pictogram_dart_flutter/core/image_processing/enums/transformation.dart';
import '../../core/image_processing/services/image_processor.dart';
import '../../core/image_processing/entities/edit_operation.dart';
import '../../core/utils/download_helper.dart';
import '../../core/image_processing/usecases/download_image_usecase.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  Uint8List? _imageBytes;
  final List<EditOperation> _operations = [];
  final ImageProcessor _processor = ImageProcessor();
  final DownloadHelper _downloader = DownloadHelper();

  OutputFormat _currentFormat = OutputFormat.png;
  String _fileName = 'edited_image';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🖼️ Editor de Imágenes'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Cargar imagen',
            icon: const Icon(Icons.upload_file),
            onPressed: _pickImage,
          ),
          IconButton(
            tooltip: 'Rotar derecha',
            icon: const Icon(Icons.rotate_right),
            onPressed: () => _apply(TransformationType.rotateRight),
          ),
          IconButton(
            tooltip: 'Rotar izquierda',
            icon: const Icon(Icons.rotate_left),
            onPressed: () => _apply(TransformationType.rotateLeft),
          ),
          IconButton(
            tooltip: 'Flip horizontal',
            icon: const Icon(Icons.flip),
            onPressed: () => _apply(TransformationType.flipHorizontal),
          ),
          IconButton(
            tooltip: 'Flip vertical',
            icon: const Icon(Icons.flip_camera_android),
            onPressed: () => _apply(TransformationType.flipVertical),
          ),
          IconButton(
            tooltip: 'Descargar',
            icon: const Icon(Icons.download),
            onPressed: _downloadEdited,
          ),
        ],
      ),
      body: Center(
        child: _imageBytes == null
            ? const Text(
                'Cargá una imagen para empezar a editar',
                style: TextStyle(fontSize: 18),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.memory(_imageBytes!),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Transformaciones: ${_operations.length}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }

  // ========================== FUNCIONES PRINCIPALES ==========================

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _imageBytes = result.files.single.bytes!;
        _fileName = result.files.single.name.split('.').first;
        _operations.clear();
      });
    }
  }

  void _apply(TransformationType type) {
    if (_imageBytes == null) return;

    setState(() {
      _operations.add(EditOperation(type: type, params: {}));

      // vista previa inmediata
      final res = _processor.applyPipeline(
        originalBytes: _imageBytes!,
        operations: _operations,
        targetFormat: _currentFormat,
      );
      _imageBytes = res.bytes;
    });
  }

  Future<void> _downloadEdited() async {
    if (_imageBytes == null) return;

    final useCase = DownloadImageUseCase(_processor, _downloader);

    await useCase.call(
      originalBytes: _imageBytes!,
      operations: _operations,
      format: _currentFormat,
      filenameBase: _fileName,
      jpgQuality: 90,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Imagen descargada con éxito')),
      );
    }
  }
}
