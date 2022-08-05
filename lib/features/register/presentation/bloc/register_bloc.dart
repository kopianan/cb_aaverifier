import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:coinbit_verifier/core/services/storage.dart';
import 'package:coinbit_verifier/core/storage/stash_in_memory.dart';
import 'package:flutter/material.dart';
import 'package:coinbit_secure_package/cb_encryption/encryption.dart';

import '../../../../core/storage/security_service.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  String pin = "";

  CBEncryptionHelper cbEncryption = CBEncryptionHelper();
  StashInMemory stashInMemory = StashInMemory();

  final storage = Storage();
  RegisterBloc() : super(RegisterInitial()) {
    on<MakePin>(
      (event, emit) async {
        pin = event.pin;
        emit(OnPinMade(1));
      },
    );

    on<ActivateBiometry>(
      (event, emit) async {
        emit(SavingHasWithBiometry());
        //Encrypt with biometric

        try {
          /// custom security services
          final SecurityService securityService = SecurityServiceImpl();

          final res = await securityService.encryptAndSaveHash();
          if (res != false) {
            emit(OnError("Can not enroll biometry"));
          }

          emit(OnHashSavedWithBiometry());
        } catch (e) {
          emit(OnError(e.toString()));
        }
      },
    );
  }
}
