import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner de Documents')),
      body: Column(
        children: [
          Expanded(
            child: _images.isEmpty
                ? const Center(child: Text('Aucune image sélectionnée'))
                : ReorderableListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _images.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _images.removeAt(oldIndex);
                  _images.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                final img = _images[index];
                return Card(
                  key: ValueKey(img.path),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: kIsWeb
                        ? FutureBuilder<Uint8List>(
                      future: img.readAsBytes(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Image.memory(
                          snapshot.data!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                        : Image.file(
                      File(img.path),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text('Image ${index + 1}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => _removeImage(index),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _takePhoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Ajouter Photo'),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: _images.isNotEmpty ? _generatePDF : null,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Créer PDF'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    final XFile? pickedImage;
    if (kIsWeb) {
      pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    } else {
      pickedImage = await _picker.pickImage(source: ImageSource.camera);
    }

    if (pickedImage != null) {
      setState(() {
        _images.add(pickedImage!);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    for (var img in _images) {
      Uint8List bytes;
      if (kIsWeb) {
        bytes = await img.readAsBytes();
      } else {
        bytes = File(img.path).readAsBytesSync();
      }
      final image = pw.MemoryImage(bytes);
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(child: pw.Image(image)),
        ),
      );
    }

    final pdfBytes = await pdf.save();

    if (kIsWeb) {
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'document_scanner.pdf')
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/document_scanner.pdf");
      await file.writeAsBytes(pdfBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF créé : ${file.path}')),
      );
    }
  }
}
