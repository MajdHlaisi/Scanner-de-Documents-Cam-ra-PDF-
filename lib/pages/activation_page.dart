import 'package:flutter/material.dart';
import '../services/activation_service.dart';

class ActivationPage extends StatefulWidget {
  final VoidCallback onActivated;

  const ActivationPage({super.key, required this.onActivated});

  @override
  State<ActivationPage> createState() => _ActivationPageState();
}

class _ActivationPageState extends State<ActivationPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _submit() async {
    final code = _controller.text.trim();

    if (code.isEmpty) {
      setState(() {
        _error = "Veuillez entrer votre clé d’activation.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final success = await ActivationService.activate(code);
      if (success) {
        widget.onActivated();
      } else {
        setState(() {
          _error = "Clé invalide, réessayez.";
        });
      }
    } catch (e) {
      setState(() {
        _error = "Erreur lors de l’activation. Réessayez plus tard.";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(title: const Text("Activation")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Entrez votre clé d’activation :",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Clé d’activation",
                    errorText: _error,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                        : const Text("Valider"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
