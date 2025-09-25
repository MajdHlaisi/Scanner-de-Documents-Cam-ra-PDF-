import 'package:flutter/material.dart';
import 'pages/scanner_page.dart';
import 'pages/activation_page.dart';
import 'services/activation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isActivated = await ActivationService.isActivated();
  runApp(MyApp(isActivated: isActivated));
}

class MyApp extends StatelessWidget {
  final bool isActivated;
  const MyApp({super.key, required this.isActivated});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scanner MVP',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
     home: isActivated ? ScannerPage() : ActivationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
