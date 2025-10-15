import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Helper class for printing images
///
/// Provides functionality to:
/// - Convert images to PDF format
/// - Show print dialog
/// - Handle printing across platforms
class PrintHelper {
  // Prevent instantiation
  PrintHelper._();

  /// Print an image
  ///
  /// Converts the image to PDF and opens the native print dialog
  ///
  /// Parameters:
  /// - imageBytes: The image data to print
  /// - imageName: Optional name for the print job
  /// - pageFormat: Optional page format (defaults to A4)
  /// - orientation: Page orientation (portrait or landscape)
  ///
  /// Returns true if print dialog was shown successfully
  static Future<bool> printImage({
    required Uint8List imageBytes,
    String imageName = 'Image',
    PdfPageFormat? pageFormat,
    PageOrientation orientation = PageOrientation.portrait,
  }) async {
    try {
      debugPrint('[PrintHelper] Preparing to print image: $imageName');

      await Printing.layoutPdf(
        name: imageName,
        format: pageFormat ?? PdfPageFormat.a4,
        onLayout: (PdfPageFormat format) async {
          return await _generatePdf(
            imageBytes: imageBytes,
            imageName: imageName,
            format: format,
            orientation: orientation,
          );
        },
      );

      debugPrint('[PrintHelper] Print dialog shown successfully');
      return true;
    } catch (e) {
      debugPrint('[PrintHelper] Error printing image: $e');
      return false;
    }
  }

  /// Generate PDF document with the image
  ///
  /// Internal method that creates a PDF with the image centered on the page
  static Future<Uint8List> _generatePdf({
    required Uint8List imageBytes,
    required String imageName,
    required PdfPageFormat format,
    required PageOrientation orientation,
  }) async {
    final pdf = pw.Document();

    // Create PDF image from bytes
    final image = pw.MemoryImage(imageBytes);

    // Determine page format with orientation
    final pageFormat = orientation == PageOrientation.landscape
        ? format.landscape
        : format.portrait;

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        orientation: orientation,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(
              image,
              fit: pw.BoxFit.contain,
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Print image with custom settings dialog
  ///
  /// Shows a dialog to let the user choose print settings before printing
  static Future<bool> printImageWithDialog({
    required BuildContext context,
    required Uint8List imageBytes,
    String imageName = 'Image',
  }) async {
    try {
      final settings = await showDialog<PrintSettings>(
        context: context,
        builder: (BuildContext context) => PrintSettingsDialog(
          imageName: imageName,
        ),
      );

      if (settings == null) {
        // User cancelled
        return false;
      }

      return await printImage(
        imageBytes: imageBytes,
        imageName: settings.name,
        pageFormat: settings.pageFormat,
        orientation: settings.orientation,
      );
    } catch (e) {
      debugPrint('[PrintHelper] Error in print dialog: $e');
      return false;
    }
  }

  /// Get available page formats
  static List<PdfPageFormat> getPageFormats() {
    return [
      PdfPageFormat.a4,
      PdfPageFormat.a3,
      PdfPageFormat.a5,
      PdfPageFormat.letter,
      PdfPageFormat.legal,
    ];
  }

  /// Get page format name
  static String getPageFormatName(PdfPageFormat format) {
    if (format == PdfPageFormat.a4) return 'A4';
    if (format == PdfPageFormat.a3) return 'A3';
    if (format == PdfPageFormat.a5) return 'A5';
    if (format == PdfPageFormat.letter) return 'Letter';
    if (format == PdfPageFormat.legal) return 'Legal';
    return 'Custom';
  }
}

// ============================================================================
// PRINT SETTINGS DATA CLASS
// ============================================================================

/// Settings for printing
class PrintSettings {
  final String name;
  final PdfPageFormat pageFormat;
  final PageOrientation orientation;

  const PrintSettings({
    required this.name,
    required this.pageFormat,
    required this.orientation,
  });
}

/// Enum for page orientation
enum PageOrientation {
  portrait,
  landscape,
}

// ============================================================================
// PRINT SETTINGS DIALOG
// ============================================================================

/// Dialog for configuring print settings
class PrintSettingsDialog extends StatefulWidget {
  final String imageName;

  const PrintSettingsDialog({
    super.key,
    required this.imageName,
  });

  @override
  State<PrintSettingsDialog> createState() => _PrintSettingsDialogState();
}

class _PrintSettingsDialogState extends State<PrintSettingsDialog> {
  late String _name;
  late PdfPageFormat _pageFormat;
  late PageOrientation _orientation;

  @override
  void initState() {
    super.initState();
    _name = widget.imageName;
    _pageFormat = PdfPageFormat.a4;
    _orientation = PageOrientation.portrait;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Configuración de impresión'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nombre del documento',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: _name),
              onChanged: (value) => _name = value,
            ),

            const SizedBox(height: 16),

            // Page format dropdown
            DropdownButtonFormField<PdfPageFormat>(
              decoration: const InputDecoration(
                labelText: 'Tamaño de página',
                border: OutlineInputBorder(),
              ),
              value: _pageFormat,
              items: PrintHelper.getPageFormats().map((format) {
                return DropdownMenuItem(
                  value: format,
                  child: Text(PrintHelper.getPageFormatName(format)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _pageFormat = value);
                }
              },
            ),

            const SizedBox(height: 16),

            // Orientation radio buttons
            const Text(
              'Orientación',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            RadioListTile<PageOrientation>(
              title: const Text('Vertical'),
              value: PageOrientation.portrait,
              groupValue: _orientation,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _orientation = value);
                }
              },
            ),
            RadioListTile<PageOrientation>(
              title: const Text('Horizontal'),
              value: PageOrientation.landscape,
              groupValue: _orientation,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _orientation = value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).pop(
              PrintSettings(
                name: _name,
                pageFormat: _pageFormat,
                orientation: _orientation,
              ),
            );
          },
          icon: const Icon(Icons.print),
          label: const Text('Imprimir'),
        ),
      ],
    );
  }
}
