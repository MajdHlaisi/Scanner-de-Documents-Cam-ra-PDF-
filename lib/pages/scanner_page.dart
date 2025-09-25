import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:universal_html/html.dart' as html;
import '../services/pdf_generator.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  List<Uint8List> images = [];

  // Fonction pour ajouter une image depuis l'ordinateur ou la caméra
  void pickImage() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((e) {
          setState(() {
            images.add(Uint8List.fromList(reader.result as List<int>));
          });
          Fluttertoast.showToast(
            msg: "Image ajoutée",
            backgroundColor: Colors.blue,
            toastLength: Toast.LENGTH_SHORT,
          );
        });
      }
    });
  }

  // Fonction pour générer un PDF à partir des images
  void generatePdf() async {
    if (images.isEmpty) {
      Fluttertoast.showToast(
        msg: "Aucune image à convertir",
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    final pdfBytes = await PdfGenerator.generatePdf(images);
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'document.pdf')
      ..click();

    html.Url.revokeObjectUrl(url);

    Fluttertoast.showToast(
      msg: "PDF généré",
      backgroundColor: Colors.green,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner MVP')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Scanner / Upload'),
                ),
                ElevatedButton.icon(
                  onPressed: generatePdf,
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Générer PDF'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: images.isEmpty
                  ? const Center(
                      child: Text(
                        "Aucune image ajoutée",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.memory(images[index], fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
