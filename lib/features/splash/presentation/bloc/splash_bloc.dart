import 'package:bloc/bloc.dart';
import 'package:coinbit_secure_package/cb_encryption/encryption.dart';
import 'package:coinbit_verifier/core/services/storage.dart';
import 'package:flutter/material.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  CBEncryptionHelper cbEncryption = CBEncryptionHelper();
  final storage = Storage();
  SplashBloc() : super(SplashInitial()) {
    on<CheckUserLogin>(
      (event, emit) async {
        emit(OnCheckingUser());
        try {
          final result = await storage.getAddress(); 
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
