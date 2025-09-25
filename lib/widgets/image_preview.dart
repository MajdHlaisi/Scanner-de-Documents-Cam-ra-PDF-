import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final Uint8List image;
  ImagePreview({required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.memory(image, fit: BoxFit.cover),
      ),
    );
  }
}
