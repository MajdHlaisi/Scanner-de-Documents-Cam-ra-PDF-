import 'package:flutter/material.dart';
import '../services/activation_service.dart';
import 'scanner_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ActivationPage extends StatefulWidget {
  @override
  _ActivationPageState createState() => _ActivationPageState();
}

class _ActivationPageState extends State<ActivationPage> {
  final TextEditingController _controller = TextEditingController();

  void _activate() async {
    if (ActivationService.isKeyValid(_controller.text)) {
      await ActivationService.saveKey(_controller.text);
      Fluttertoast.showToast(
          msg: "Activation réussie !", backgroundColor: Colors.green);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => ScannerPage()));
    } else {
      Fluttertoast.showToast(
          msg: "Clé invalide", backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Activation',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      labelText: 'Entrez votre clé',
                      border: OutlineInputBorder()),
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: _activate, child: Text('Activer'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
