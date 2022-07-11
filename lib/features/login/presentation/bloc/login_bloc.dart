import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_encrypt/cb_encryption/encryption.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  CBEncryption cbEncryption = CBEncryption();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  LoginBloc() : super(LoginInitial()) {
    on<LoginUsingPin>(
      (event, emit) async {
        try {
          final hash = await cbEncryption.getHash(event.pin);

          emit(LoginSuccess(hash!));
        } on PlatformException catch (e) {
          emit(LoginFailed(e.message!));
        }
      },
    );
  }
}
