import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ActivationService {
  static const _validKey = "MA_CLE_123";
  static const _storage = FlutterSecureStorage();

  /// Vérifie si la clé entrée est correcte
  static bool isKeyValid(String key) {
    return key == _validKey;
  }

  /// Sauvegarde la clé dans le stockage sécurisé
  static Future<void> saveKey(String key) async {
    await _storage.write(key: 'activation_key', value: key);
  }

  /// Vérifie si l’app est déjà activée
  static Future<bool> isActivated() async {
    final key = await _storage.read(key: 'activation_key');
    return key == _validKey;
  }
}
