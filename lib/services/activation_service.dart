import 'package:shared_preferences/shared_preferences.dart';

class ActivationService {
  static const _key = 'isActivated';
  static const _activationCode = '1234-ABCD'; // Exemple de clé valide

  static Future<bool> isActivated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<bool> activate(String code) async {
    if (code == _activationCode) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, true);
      return true;
    }
    return false;
  }

  static Future<void> resetActivation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
