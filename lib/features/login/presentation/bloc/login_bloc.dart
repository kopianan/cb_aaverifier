import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coinbit_secure_package/cb_encryption/encryption.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  CBEncryptionHelper cbEncryption = CBEncryptionHelper();

  LoginBloc() : super(LoginInitial()) {
    on<LoginUsingBiometry>(
      (event, emit) async {
        try {
          final hash = await cbEncryption.loadAndDecryptHash();
          emit(LoginSuccess(hash!));
        } catch (e) {
          emit(LoginFailed('somethingwrong'));
        }
      },
    );
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
