import 'package:flutter/material.dart';
import 'pages/scanner_page.dart';
import 'pages/activation_page.dart';
import 'services/activation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scanner MVP',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      home: const ActivationWrapper(),
    );
  }
}

class ActivationWrapper extends StatefulWidget {
  const ActivationWrapper({super.key});

  @override
  State<ActivationWrapper> createState() => _ActivationWrapperState();
}

class _ActivationWrapperState extends State<ActivationWrapper> {
  bool _loading = true;
  bool _activated = false;

  @override
  void initState() {
    super.initState();
    _checkActivation();
  }

  Future<void> _checkActivation() async {
    bool activated = await ActivationService.isActivated();
    setState(() {
      _activated = activated;
      _loading = false;
    });
  }

  void _onActivated() {
    setState(() {
      _activated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _activated
        ? const ScannerPage()
        : ActivationPage(onActivated: _onActivated);
  }
}
