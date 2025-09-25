import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import '../services/pdf_generator.dart';
import '../widgets/image_preview.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  List<Uint8List> images = [];

  void pickImage() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final file = uploadInput.files?.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file!);
      reader.onLoadEnd.listen((event) {
        setState(() {
          images.add(Uint8List.fromList(reader.result as List<int>));
        });
        Fluttertoast.showToast(msg: "Image ajoutée", backgroundColor: Colors.blue);
      });
    });
  }

  void generatePdf() async {
    if (images.isEmpty) {
      Fluttertoast.showToast(msg: "Aucune image à convertir", backgroundColor: Colors.red);
      return;
    }
    final pdfBytes = await PdfGenerator.generatePdf(images);
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'document.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
    Fluttertoast.showToast(msg: "PDF généré", backgroundColor: Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scanner MVP')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: Icon(Icons.camera_alt),
                  label: Text('Scanner / Upload'),
                ),
                ElevatedButton.icon(
                  onPressed: generatePdf,
                  icon: Icon(Icons.picture_as_pdf),
                  label: Text('Générer PDF'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: images.isEmpty
                  ? Center(child: Text("Aucune image ajoutée", style: TextStyle(fontSize: 16)))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return ImagePreview(image: images[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
