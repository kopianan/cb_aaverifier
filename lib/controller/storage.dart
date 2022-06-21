import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveKey(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw Exception();
    }
  }

  static Future<String?> loadKey(String key) async {
    final result = await _storage.read(key: key);
    return result;
  }
}
