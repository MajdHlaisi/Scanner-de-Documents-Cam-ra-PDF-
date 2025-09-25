import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  static Future<Uint8List> generatePdf(List<Uint8List> images) async {
    final pdf = pw.Document();
    for (var img in images) {
      final image = pw.MemoryImage(img);
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain));
          }));
    }
    return pdf.save();
  }
}
