import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_encrypt/cb_encryption/encryption.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  CBEncryptionHelper cbEncryption = CBEncryptionHelper();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  SplashBloc() : super(SplashInitial()) {
    on<CheckUserLogin>(
      (event, emit) async {
        emit(OnCheckingUser());
        try {
          final result = await secureStorage.read(key: 'session');
          if (result != null) {
            emit(OnUserExist());
          } else {
            emit(OnUserNotExist());
          }
        } catch (e) {
          emit(OnUserNotExist());
        }
      },
    );
  }
}
