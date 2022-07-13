import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveSharedKey(String key, String value) async {
    try {
      await _storage.write(key: "${key}sk", value: value);
    } catch (e) {
      throw Exception();
    }
  }

  static Future<void> savePresignKey(String key, String value) async {
    try {
      await _storage.write(key: '${key}pk', value: value);
    } catch (e) {
      throw Exception();
    }
  }

  static Future<Map<String, String>> loadAllKey() async {
    final result = await _storage.readAll();
    return result;
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
