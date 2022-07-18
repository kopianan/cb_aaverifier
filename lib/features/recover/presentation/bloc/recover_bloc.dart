import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_storage/cloud_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:test_encrypt/cb_encryption/encryption.dart';

part 'recover_event.dart';
part 'recover_state.dart';

class RecoverBloc extends Bloc<RecoverEvent, RecoverState> {
  final cloudStorage = CloudStorage();
  final cbEncryption = CBEncryptionHelper();
  RecoverBloc() : super(RecoverInitial()) {
    on<GetEncryptedKeyFromStorage>(
      (event, emit) async {
        final result =
            await cloudStorage.downloadKeyFromGoogleDrive(event.fileId);
        emit(OnDownlodKeySuccess(result));
      },
    );
    on<DecryptKey>(
      (event, emit) async {
        final result =
            cbEncryption.decryptWithCustomHash(event.encryptedKey, event.hash);
        print(result);
      },
    );
  }
}
