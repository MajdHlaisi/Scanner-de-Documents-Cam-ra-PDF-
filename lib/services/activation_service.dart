import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ActivationService {
  static final _storage = FlutterSecureStorage();
  static const _key = 'activation_key';
  static const _validKey = 'MA_CLE_123'; // reste privé

  // Vérifie si la clé fournie est valide
  static bool isKeyValid(String key) {
    return key == _validKey;
  }

  static Future<bool> checkActivation() async {
    String? key = await _storage.read(key: _key);
    return key == _validKey;
  }

  static Future<void> saveKey(String key) async {
    await _storage.write(key: _key, value: key);
  }
}
