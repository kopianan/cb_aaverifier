import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static final Storage _singleton = Storage._internal();

  factory Storage() {
    return _singleton;
  }

  Storage._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  IOSOptions _getIOSOptions() => const IOSOptions();

  AndroidOptions _getAndroidOptions() => const AndroidOptions();

  String session = 'session';
  String address = 'address';

  Future<void> saveSession() async {
    try {
      await _storage.write(
        key: session,
        value: 'cb session',
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<String?> getSession() async {
    try {
      final result = await _storage.read(
        key: session,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
      return result;
    } on Exception catch (e) {
      throw Exception("No Salt Found");
    }
  }

  Future<void> saveAddress(String cbAddress) async {
    try {
      await _storage.write(
        key: address,
        value: cbAddress,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<String?> getAddress() async {
    try {
      final result = await _storage.read(
        key: address,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
      return result;
    } on Exception catch (e) {
      throw Exception("No Salt Found");
    }
  }
}
