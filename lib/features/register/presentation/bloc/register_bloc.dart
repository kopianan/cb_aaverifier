import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:coinbit_verifier/core/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_encrypt/cb_encryption/encryption.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  String pin = "";

  CBEncryptionHelper cbEncryption = CBEncryptionHelper();

  final storage = Storage();
  RegisterBloc() : super(RegisterInitial()) {
    on<MakePin>(
      (event, emit) async {
        pin = event.pin;
        emit(OnPinMade(1));
      },
    );

    on<ConfirmPin>(
      (event, emit) async {
        if (pin != event.confirmPin) {
          emit(WrongPin());
        } else {
          //Generate Hash with pin and generated salt
          //Save
          await storage.saveSession();
          log("Save session");
          final hash = await cbEncryption.generateHash(pin);
          emit(PinConfrimed(hash!));
        }
      },
    );
    on<ActivateBiometry>(
      (event, emit) async {
        emit(SavingHasWithBiometry());
        //Encrypt with biometric
        try {
          await cbEncryption.encrptAndSaveHash(hash: event.hash);
          emit(OnHashSavedWithBiometry());
        } catch (e) {
          emit(OnError(e.toString()));
        }
      },
    );
  }
}
