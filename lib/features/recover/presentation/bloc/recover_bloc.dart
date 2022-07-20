import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_storage/cloud_storage.dart';
import 'package:coinbit_verifier/core/services/fcm_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rust_mpc_ffi/lib.dart';
import 'package:test_encrypt/cb_encryption/encryption.dart';

part 'recover_event.dart';
part 'recover_state.dart';

class RecoverBloc extends Bloc<RecoverEvent, RecoverState> {
  final cloudStorage = CloudStorage();
  final mpc = CBRustMpc();
  final cbEncryption = CBEncryptionHelper();
  final fcmService = FCMService();

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
        final shared =
            cbEncryption.decryptWithCustomHash(event.encryptedKey, event.hash);
        await fcmService.createRecoverRequest();
        emit(OnRequestRecover());
        final presign = await mpc.offlineSignWithJson(1, shared);
        emit(OnRequestApproved(shared, presign));
      },
    );
    on<RecoverProccess>(
      (event, emit) async {
        final tag = "sharedKey-${event.address}";
        final rawSharedKey = await cbEncryption.decryptKeyWithHardware(
          event.encryptedKeyShared,
          tag,
        );

        //DO PRSIGN NOW
        final newPresign =
            await mpc.offlineSignWithJson(event.index, rawSharedKey);
        print("NEW PRESGIN");
        print(newPresign);
      },
    );
  }
}
