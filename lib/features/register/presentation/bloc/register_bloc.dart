import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_encrypt/cb_encryption/encryption.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  String pin = "";

  CBEncryption cbEncryption = CBEncryption();
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
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
          secureStorage.write(key: "session", value: "exist");
          final hash = await cbEncryption.generateHash(pin);
          emit(PinConfrimed(hash!));
        }
      },
    );
    on<ActivateBiometry>(
      (event, emit) async {
        emit(SavingHasWithBiometry());
        await cbEncryption.saveAndEncryptHash(hash: event.hash);
        emit(OnHashSavedWithBiometry());
      },
    );
  }
}
