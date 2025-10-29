import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import '../../core/image_processing/enums/transformation.dart';
import '../../core/image_processing/services/image_processor.dart';
import '../../core/image_processing/entities/edit_operation.dart';
import '../../core/utils/download_helper.dart';
import '../../core/image_processing/usecases/download_image_usecase.dart';
import '../../core/constants/keyboard_shortcuts.dart';
import '../../app.dart'; 

import '../settings/settings_page.dart';
import 'widgets/resize_dialog.dart';
import 'widgets/convert_format_dialog.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  Uint8List? _originalImageBytes;
  Uint8List? _previewImageBytes;

  final List<EditOperation> _operations = [];
  final ImageProcessor _processor = ImageProcessor();
  final DownloadHelper _downloader = DownloadHelper();
  final DownloadImageUseCase _downloadUseCase = DownloadImageUseCase(ImageProcessor(), DownloadHelper());

  OutputFormat _currentFormat = OutputFormat.png;
  String _fileName = 'edited_image';
  bool _shouldAddResizeSuffix = false;
  int _currentJpgQuality = 90;
  bool _isMenuVisible = true;
  
  // CORRECCIÓN CLAVE: Inicializar un FocusNode aquí para el área de contenido
  final FocusNode _contentFocusNode = FocusNode();


  @override
  void dispose() {
    _contentFocusNode.dispose();
    super.dispose();
  }

  // FUNCIÓN DE MANEJO DE SHORTCUTS (Mantiene la lógica de letras)
  void _handleShortcutIntent(LogicalKeySet keys) {
    
    // ----------------- Comandos UI y Archivo que siempre deben funcionar -----------------
    if (keys == KeyboardShortcuts.toggleMenuKeys) {
      setState(() {
        _isMenuVisible = !_isMenuVisible;
      });
      return;
    } 
    
    if (keys == KeyboardShortcuts.openFilesKeys) {
       _pickImage();
       return;
    }

    // ----------------- Bloqueo para comandos que requieren IMAGEN -----------------
    if (_originalImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Necesitas cargar una imagen (Ctrl+O) para editar.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // ----------------- Edición (NUEVOS ATAJOS DE LETRA) -----------------
    if (keys == KeyboardShortcuts.rotateClockwiseKeys) {
      _apply(TransformationType.rotateRight); // Atajo 'R'
    } else if (keys == KeyboardShortcuts.rotateCounterClockwiseKeys) {
      _apply(TransformationType.rotateLeft); // Atajo 'L'
    } else if (keys == KeyboardShortcuts.flipHorizontalKeys) {
      _apply(TransformationType.flipHorizontal); // Atajo 'H'
    } else if (keys == KeyboardShortcuts.flipVerticalKeys) {
      _apply(TransformationType.flipVertical); // Atajo 'V'
    } 
    
    // ----------------- Acciones de Imagen -----------------
    else if (keys == KeyboardShortcuts.downloadKeys) {
      _downloadEdited(); // Atajo 'Ctrl+S'
    } else if (keys == KeyboardShortcuts.copyKeys) {
      _copyImageToClipboard(); // Atajo 'Ctrl+C'
    } else if (keys == KeyboardShortcuts.printKeys) {
      _showNotImplementedSnackbar('Imprimir (Ctrl+P)');
    } 
    
    // ----------------- Zoom y Fullscreen (Pendientes) -----------------
    else if (keys == KeyboardShortcuts.toggleFullscreenKeys) {
      _showNotImplementedSnackbar('Fullscreen (F11)');
    } else if (keys == KeyboardShortcuts.zoomInKeys || keys == KeyboardShortcuts.zoomOutKeys || keys == KeyboardShortcuts.zoomResetKeys || keys == KeyboardShortcuts.fitToScreenKeys) {
       _showNotImplementedSnackbar('Zoom (${KeyboardShortcuts.getDisplayString(keys)})');
    }
  }

  // MODIFICACIÓN: Wrapper para construir el widget con manejo de shortcuts
  Widget _buildWithShortcuts() {
    final actions = <Type, Action<Intent>>{
      SimpleIntent: CallbackAction<SimpleIntent>(
        onInvoke: (SimpleIntent intent) {
          _handleShortcutIntent(intent.keys);
          return true;
        },
      ),
    };

    return Actions(
      actions: actions,
      child: Scaffold(
        appBar: _isMenuVisible ? AppBar(
          title: const Text('🖼️ Editor de Imágenes'),
          centerTitle: true,
          actions: [
            _buildActionIcon(
              'Cargar imagen',
              Icons.upload_file,
              _pickImage,
              KeyboardShortcuts.openFilesKeys, 
            ),
            _buildActionIcon(
              'Rotar derecha',
              Icons.rotate_right,
              () => _apply(TransformationType.rotateRight),
              KeyboardShortcuts.rotateClockwiseKeys, // Ahora es R
            ),
            _buildActionIcon(
              'Rotar izquierda',
              Icons.rotate_left,
              () => _apply(TransformationType.rotateLeft),
              KeyboardShortcuts.rotateCounterClockwiseKeys, // Ahora es L
            ),
            _buildActionIcon(
              'Flip horizontal',
              Icons.flip,
              () => _apply(TransformationType.flipHorizontal),
              KeyboardShortcuts.flipHorizontalKeys, // Ahora es H
            ),
            _buildActionIcon(
              'Flip vertical',
              Icons.flip_camera_android,
              () => _apply(TransformationType.flipVertical),
              KeyboardShortcuts.flipVerticalKeys, // Ahora es V
            ),
            _buildActionIcon(
              'Redimensionar',
              Icons.photo_size_select_large,
              _showResizeDialog,
              null,
            ),
            _buildActionIcon(
              'Convertir formato',
              Icons.transform,
              _showConvertFormatDialog,
              null,
            ),
            _buildActionIcon(
              'Descargar',
              Icons.download,
              _downloadEdited,
              KeyboardShortcuts.downloadKeys,
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Configuración',
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ) : null,

        // CORRECCIÓN CLAVE: Usamos un Focus, no solo GestureDetector.
        body: Focus(
          focusNode: _contentFocusNode,
          autofocus: true,
          onKey: (FocusNode node, RawKeyEvent event) {
            // Este onKey es un mecanismo de respaldo muy agresivo. 
            // Si llega aquí un RawKeyEvent, es probable que la tecla no esté mapeada, 
            // pero le pedimos que se asegure de solicitar el foco.
            if (event is RawKeyDownEvent) {
              node.requestFocus();
            }
            return KeyEventResult.ignored; // Dejamos que el sistema Actions lo maneje.
          },
          child: GestureDetector(
            onSecondaryTapDown: _showContextMenu,
            onTap: () {
              // Si el usuario hace clic, le damos el foco al área de contenido
              _contentFocusNode.requestFocus();
            },
            child: Center(
              child: _previewImageBytes == null
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
                            child: Image.memory(_previewImageBytes!),
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
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  CORRECCIÓN CLAVE: Forzamos la solicitud de foco al iniciar.
    // Esto es vital para asegurar que la EditorPage sea el target de los eventos.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_contentFocusNode.hasFocus) {
        _contentFocusNode.requestFocus();
      }
    });

    return _buildWithShortcuts();
  }

  // Widget auxiliar para la Toolbar
  Widget _buildActionIcon(
    String description,
    IconData icon,
    VoidCallback? onPressed,
    LogicalKeySet? shortcutKeys,
  ) {
    final shortcutText = shortcutKeys != null
        ? ' (${KeyboardShortcuts.getDisplayString(shortcutKeys)})'
        : '';

    return IconButton(
      tooltip: '$description$shortcutText',
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }

  // Implementación del Menú Contextual
  void _showContextMenu(TapDownDetails details) {
    if (_originalImageBytes == null) return;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        details.globalPosition & const Size(40, 40),
        Offset.zero & MediaQuery.of(context).size,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'copy_image',
          child: ListTile(
            leading: const Icon(Icons.copy),
            title: Text('Copiar Imagen ${KeyboardShortcuts.getDisplayString(KeyboardShortcuts.copyKeys)}'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'copy_filename',
          child: ListTile(
            leading: const Icon(Icons.file_copy_outlined),
            title: const Text('Copiar Nombre de Archivo'),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'download',
          child: ListTile(
            leading: const Icon(Icons.download),
            title: Text('Descargar ${KeyboardShortcuts.getDisplayString(KeyboardShortcuts.downloadKeys)}'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'print',
          child: ListTile(
            leading: const Icon(Icons.print),
            title: Text('Imprimir ${KeyboardShortcuts.getDisplayString(KeyboardShortcuts.printKeys)}'),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'copy_image') {
        _copyImageToClipboard();
      } else if (value == 'copy_filename') {
        _copyFilenameToClipboard();
      } else if (value == 'download') {
        _downloadEdited();
      } else if (value == 'print') {
        _showNotImplementedSnackbar('Imprimir');
      }
    });
  }

  // Lógica de copiado al clipboard
  void _copyImageToClipboard() async {
    if (_previewImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(' Carga una imagen para copiar.')),
      );
      return;
    }
    try {
      final image = img.decodeImage(_previewImageBytes!);
      if (image == null) throw Exception("No se pudo decodificar la imagen.");
      
      final pngBytes = img.encodePng(image);

      await Clipboard.setData(
        ClipboardData(
          text: 'data:image/png;base64,${base64Encode(pngBytes)}',
        ),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(' Imagen copiada al portapapeles (como Base64).')),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(' Error al copiar imagen: ${e.toString()}')),
        );
      }
    }
  }

  // Lógica de copiado de nombre de archivo
  void _copyFilenameToClipboard() {
    Clipboard.setData(ClipboardData(text: _fileName));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(' Nombre de archivo ("$_fileName") copiado.')),
    );
  }

  void _showNotImplementedSnackbar(String feature) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🚧 Funcionalidad "$feature" no implementada en este momento.'),
          backgroundColor: Colors.blueGrey,
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
        _originalImageBytes = result.files.single.bytes!;
        _previewImageBytes = result.files.single.bytes!;
        _fileName = result.files.single.name.split('.').first;
        _operations.clear();
      });
    }
  }

  void _apply(TransformationType type) {
    if (_originalImageBytes == null) return;

    setState(() {
      _operations.add(EditOperation(type: type, params: {}));

      final res = _processor.applyPipeline(
        originalBytes: _originalImageBytes!,
        operations: _operations,
        targetFormat: _currentFormat,
      );

      _previewImageBytes = res.bytes;
    });
  }

  Future<void> _downloadEdited() async {
    if (_originalImageBytes == null) return;

    final finalFileName = _shouldAddResizeSuffix
        ? '$_fileName-resize'
        : _fileName;

    await _downloadUseCase.call(
      originalBytes: _originalImageBytes!,
      operations: _operations,
      format: _currentFormat,
      filenameBase: finalFileName,
      jpgQuality: _currentJpgQuality,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(' Imagen descargada con éxito')),
      );
    }
  }

  // === Diálogos y Redimensionamiento ===

  Future<void> _showResizeDialog() async {
     if (_originalImageBytes == null) {
       _showNotImplementedSnackbar('Primero cargá una imagen');
       return;
     }

     final decodedImage = img.decodeImage(_originalImageBytes!);
     if (decodedImage == null) {
       _showNotImplementedSnackbar('Error al obtener dimensiones de la imagen');
       return;
     }

     final result = await showDialog<ResizeDialogResult>(
       context: context,
       builder: (context) => ResizeDialog(
         originalWidth: decodedImage.width,
         originalHeight: decodedImage.height,
         currentFormat: _currentFormat,
       ),
     );

     if (result != null) {
       _applyResize(
         width: result.width,
         height: result.height, // Se agregó el parámetro faltante
         jpgQuality: result.jpgQuality,
         overwriteFile: result.overwriteFile,
       );
     }
  }

  // CORRECCIÓN: Definición de la función con 'height' y sin 'required' duplicado
  void _applyResize({
    required int? width,
    required int? height, // Se agregó el parámetro faltante
    required int jpgQuality,
    required bool overwriteFile,
  }) {
    if (_originalImageBytes == null) return;

    setState(() {
      _operations.add(EditOperation(
        type: TransformationType.resize,
        params: {
          if (width != null) 'width': width,
          if (height != null) 'height': height, // Se usa la variable local 'height'
        },
      ));

      final res = _processor.applyPipeline(
        originalBytes: _originalImageBytes!,
        operations: _operations,
        targetFormat: _currentFormat,
        jpgQuality: jpgQuality,
      );

      _previewImageBytes = res.bytes;
      _currentJpgQuality = jpgQuality;
      _shouldAddResizeSuffix = !overwriteFile;
    });

    if (mounted) {
      // CORRECCIÓN: Uso de las variables locales 'width' y 'height'
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ' Imagen redimensionada ${width != null ? 'ancho: $width' : ''}${width != null && height != null ? ' x ' : ''}${height != null ? 'alto: $height' : ''}',
          ),
        ),
      );
    }
  }

  Future<void> _showConvertFormatDialog() async {
    if (_originalImageBytes == null) {
      _showNotImplementedSnackbar('Primero cargá una imagen');
      return;
    }

    final result = await showDialog<ConvertFormatDialogResult>(
      context: context,
      builder: (context) => ConvertFormatDialog(
        currentFormat: _currentFormat,
      ),
    );

    if (result != null) {
      _applyFormatConversion(
        targetFormat: result.targetFormat,
        jpgQuality: result.jpgQuality,
        overwriteFile: result.overwriteFile,
      );
    }
  }

  void _applyFormatConversion({
    required OutputFormat targetFormat,
    required int jpgQuality,
    required bool overwriteFile,
  }) {
    if (_originalImageBytes == null) return;

    final oldFormat = _currentFormat;

    setState(() {
      _operations.add(EditOperation(
        type: TransformationType.convertFormat,
        params: {
          'to': targetFormat.name,
        },
      ));

      _currentFormat = targetFormat;

      final res = _processor.applyPipeline(
        originalBytes: _originalImageBytes!,
        operations: _operations,
        targetFormat: _currentFormat,
        jpgQuality: jpgQuality,
      );

      _previewImageBytes = res.bytes;
      _currentJpgQuality = jpgQuality;
      _shouldAddResizeSuffix = !overwriteFile;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ' Formato convertido de ${_getFormatDisplayName(oldFormat)} a ${_getFormatDisplayName(targetFormat)}',
          ),
        ),
      );
    }
  }

  String _getFormatDisplayName(OutputFormat format) {
    switch (format) {
      case OutputFormat.jpg:
        return 'JPG';
      case OutputFormat.png:
        return 'PNG';
      case OutputFormat.bmp:
        return 'BMP';
      case OutputFormat.gif:
        return 'GIF';
      case OutputFormat.webp:
        return 'WEBP';
    }
  }
}