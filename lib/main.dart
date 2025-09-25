import 'package:flutter/material.dart';
import 'pages/scanner_page.dart';
import 'pages/activation_page.dart';
import 'services/activation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isActivated = await ActivationService.checkActivation();
  runApp(MyApp(isActivated: isActivated));
}

class MyApp extends StatelessWidget {
  final bool isActivated;
  MyApp({required this.isActivated});

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      home: isActivated ? ScannerPage() : ActivationPage(),
    );
  }
}
