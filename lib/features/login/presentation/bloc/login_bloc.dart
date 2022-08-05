import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:coinbit_verifier/core/storage/security_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coinbit_secure_package/cb_encryption/encryption.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  CBEncryptionHelper cbEncryption = CBEncryptionHelper();
  SecurityServiceImpl securityService = SecurityServiceImpl();

  LoginBloc() : super(LoginInitial()) {
    on<LoginUsingBiometry>(
      (event, emit) async {
        try {
          /// get encrypted argon hash (layer1) from
          /// flutter secure storage
          /// and then decrypt with biometric
          await securityService.getDecryptHash();

          /// get encryption layer2 credentials
          /// (keyshare & presign) from flutter
          /// secure storage and then decrypt using argon hash
          /// (SecretBox)
          await securityService.getDecryptLayer2Credential();

          /// check if credetials (layer1) and argon hash already
          /// in memory
          final passed = await securityService.checkAllInMemory();
          if (passed) {
            emit(LoginSuccess());
          }
        } catch (e) {
          emit(LoginFailed('somethingwrong'));
        }
      },
    );
    on<LoginUsingPin>(
      (event, emit) async {
        try {
          /// get salt from flutter secure storage
          /// and then genereate with pin
          await securityService.getHash(pin: event.pin);

          /// get encryption layer2 credentials
          /// (keyshare & presign) from flutter
          /// secure storage and then decrypt using argon hash
          /// (SecretBox)
          await securityService.getDecryptLayer2Credential();

          /// check if credetials (layer1) and argon hash already
          /// in memory
          final passed = await securityService.checkAllInMemory();
          if (passed) {
            emit(LoginSuccess());
          }
        } on PlatformException catch (e) {
          emit(LoginFailed(e.message!));
        }
      },
    );
  }
}
