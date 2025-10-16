import 'package:flutter/material.dart';
import '../../../core/image_processing/enums/transformation.dart';

class ConvertFormatDialogResult {
  final OutputFormat targetFormat;
  final int jpgQuality;
  final bool overwriteFile;

  ConvertFormatDialogResult({
    required this.targetFormat,
    required this.jpgQuality,
    required this.overwriteFile,
  });
}

class ConvertFormatDialog extends StatefulWidget {
  final OutputFormat currentFormat;

  const ConvertFormatDialog({
    super.key,
    required this.currentFormat,
  });

  @override
  State<ConvertFormatDialog> createState() => _ConvertFormatDialogState();
}

class _ConvertFormatDialogState extends State<ConvertFormatDialog> {
  late OutputFormat _selectedFormat;
  double _jpgQuality = 90.0;
  bool _overwriteFile = false;

  @override
  void initState() {
    super.initState();
    // Inicializar con el primer formato que NO sea el actual
    _selectedFormat = OutputFormat.values.firstWhere(
      (format) => format != widget.currentFormat,
      orElse: () => OutputFormat.png,
    );
  }

  bool get _isTargetJpg => _selectedFormat == OutputFormat.jpg;

  String _getFormatDisplayName(OutputFormat format) {
    switch (format) {
      case OutputFormat.jpg:
        return 'JPG/JPEG';
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

  IconData _getFormatIcon(OutputFormat format) {
    switch (format) {
      case OutputFormat.jpg:
        return Icons.image;
      case OutputFormat.png:
        return Icons.image_outlined;
      case OutputFormat.bmp:
        return Icons.broken_image;
      case OutputFormat.gif:
        return Icons.gif;
      case OutputFormat.webp:
        return Icons.photo_library;
    }
  }

  void _handleConvert() {
    // Validación: el formato destino debe ser diferente al actual
    if (_selectedFormat == widget.currentFormat) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Seleccioná un formato diferente al actual'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Retornar resultado
    Navigator.of(context).pop(
      ConvertFormatDialogResult(
        targetFormat: _selectedFormat,
        jpgQuality: _jpgQuality.round(),
        overwriteFile: _overwriteFile,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('🔄 Convertir Formato'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Formato actual
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getFormatIcon(widget.currentFormat),
                      size: 24,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Formato actual',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          _getFormatDisplayName(widget.currentFormat).toUpperCase(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Selector de formato destino
              Text(
                'Convertir a:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Radio buttons para cada formato
              ...OutputFormat.values.map((format) {
                final isCurrentFormat = format == widget.currentFormat;

                return InkWell(
                  onTap: isCurrentFormat
                      ? null
                      : () {
                          setState(() {
                            _selectedFormat = format;
                          });
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Radio<OutputFormat>(
                          value: format,
                          groupValue: _selectedFormat,
                          onChanged: isCurrentFormat
                              ? null
                              : (value) {
                                  setState(() {
                                    _selectedFormat = value!;
                                  });
                                },
                        ),
                        Icon(
                          _getFormatIcon(format),
                          size: 20,
                          color: isCurrentFormat
                              ? theme.disabledColor
                              : theme.colorScheme.onSurface,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getFormatDisplayName(format),
                          style: TextStyle(
                            color: isCurrentFormat
                                ? theme.disabledColor
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        if (isCurrentFormat) ...[
                          const SizedBox(width: 8),
                          Text(
                            '(actual)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.disabledColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),

              // Slider de calidad JPG (solo visible si el formato destino es JPG)
              if (_isTargetJpg) ...[
                const SizedBox(height: 16),
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
                const SizedBox(height: 8),
              ],

              const Divider(),
              const SizedBox(height: 8),

              // Información sobre GIF animados
              if (_selectedFormat == OutputFormat.gif) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.tertiary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: theme.colorScheme.tertiary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Los GIF animados se convertirán usando el primer frame',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

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
                      : 'Agrega sufijo "-converted" al nombre',
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
          onPressed: _handleConvert,
          child: const Text('Convertir'),
        ),
      ],
    );
  }
}
