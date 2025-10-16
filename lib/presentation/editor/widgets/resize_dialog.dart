import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/image_processing/enums/transformation.dart';

class ResizeDialogResult {
  final int? width;
  final int? height;
  final int jpgQuality;
  final bool overwriteFile;

  ResizeDialogResult({
    this.width,
    this.height,
    required this.jpgQuality,
    required this.overwriteFile,
  });
}

class ResizeDialog extends StatefulWidget {
  final int originalWidth;
  final int originalHeight;
  final OutputFormat currentFormat;

  const ResizeDialog({
    super.key,
    required this.originalWidth,
    required this.originalHeight,
    required this.currentFormat,
  });

  @override
  State<ResizeDialog> createState() => _ResizeDialogState();
}

class _ResizeDialogState extends State<ResizeDialog> {
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  bool _maintainAspectRatio = true;
  double _jpgQuality = 90.0;
  bool _overwriteFile = false;

  bool _isUpdatingFromAspectRatio = false;

  @override
  void initState() {
    super.initState();
    // Inicializar con dimensiones originales
    _widthController.text = widget.originalWidth.toString();
    _heightController.text = widget.originalHeight.toString();

    // Listeners para recalcular automáticamente
    _widthController.addListener(_onWidthChanged);
    _heightController.addListener(_onHeightChanged);
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _onWidthChanged() {
    if (!_maintainAspectRatio || _isUpdatingFromAspectRatio) return;

    final width = int.tryParse(_widthController.text);
    if (width != null && width > 0) {
      _isUpdatingFromAspectRatio = true;
      final aspectRatio = widget.originalWidth / widget.originalHeight;
      final newHeight = (width / aspectRatio).round();
      _heightController.text = newHeight.toString();
      _isUpdatingFromAspectRatio = false;
    }
  }

  void _onHeightChanged() {
    if (!_maintainAspectRatio || _isUpdatingFromAspectRatio) return;

    final height = int.tryParse(_heightController.text);
    if (height != null && height > 0) {
      _isUpdatingFromAspectRatio = true;
      final aspectRatio = widget.originalWidth / widget.originalHeight;
      final newWidth = (height * aspectRatio).round();
      _widthController.text = newWidth.toString();
      _isUpdatingFromAspectRatio = false;
    }
  }

  bool get _isJpg => widget.currentFormat == OutputFormat.jpg;

  void _handleApply() {
    final width = int.tryParse(_widthController.text);
    final height = int.tryParse(_heightController.text);

    // Validaciones
    if ((width == null || width <= 0) && (height == null || height <= 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Ingresá al menos un valor válido para ancho o alto'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (width != null && width <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ El ancho debe ser mayor a 0'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (height != null && height <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ El alto debe ser mayor a 0'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Retornar resultado
    Navigator.of(context).pop(
      ResizeDialogResult(
        width: width,
        height: height,
        jpgQuality: _jpgQuality.round(),
        overwriteFile: _overwriteFile,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('📐 Redimensionar Imagen'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dimensiones originales
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Dimensiones originales: ${widget.originalWidth} x ${widget.originalHeight} px',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Ancho
              TextField(
                controller: _widthController,
                decoration: const InputDecoration(
                  labelText: 'Ancho (px)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.straighten),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 16),

              // Alto
              TextField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Alto (px)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.height),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 16),

              // Checkbox mantener proporción
              CheckboxListTile(
                value: _maintainAspectRatio,
                onChanged: (value) {
                  setState(() {
                    _maintainAspectRatio = value ?? true;
                    if (_maintainAspectRatio) {
                      // Recalcular altura basándose en ancho actual
                      _onWidthChanged();
                    }
                  });
                },
                title: const Text('Mantener proporción'),
                subtitle: const Text('Recalcula automáticamente ancho/alto'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),

              // Slider de calidad JPG (solo visible si es JPG)
              if (_isJpg) ...[
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  'Calidad JPG: ${_jpgQuality.round()}%',
                  style: theme.textTheme.titleSmall,
                ),
                Slider(
                  value: _jpgQuality,
                  min: 1,
                  max: 100,
                  divisions: 99,
                  label: '${_jpgQuality.round()}%',
                  onChanged: (value) {
                    setState(() {
                      _jpgQuality = value;
                    });
                  },
                ),
              ],

              const Divider(),
              const SizedBox(height: 8),

              // Checkbox sobreescribir
              CheckboxListTile(
                value: _overwriteFile,
                onChanged: (value) {
                  setState(() {
                    _overwriteFile = value ?? false;
                  });
                },
                title: const Text('Sobreescribir archivo'),
                subtitle: Text(
                  _overwriteFile
                      ? 'Mantiene el nombre original'
                      : 'Agrega sufijo "-resize" al nombre',
                  style: theme.textTheme.bodySmall,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _handleApply,
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}
