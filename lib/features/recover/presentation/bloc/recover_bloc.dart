import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_storage/cloud_storage.dart';
import 'package:coinbit_secure_package/cb_encryption/encryption.dart';
import 'package:coinbit_verifier/core/services/fcm_service.dart';
import 'package:coinbit_verifier/core/storage/stash_in_memory.dart';
import 'package:coinbit_verifier/core/utils/utils_const.dart';
import 'package:flutter/material.dart';
import 'package:rust_mpc_ffi/lib.dart';

part 'recover_event.dart';
part 'recover_state.dart';

class RecoverBloc extends Bloc<RecoverEvent, RecoverState> {
  final cloudStorage = CloudStorage();
  final mpc = CBRustMpc();
  final cbEncryption = CBEncryptionHelper();
  final fcmService = FCMService();
  final stashInMemory = StashInMemory();

  RecoverBloc() : super(RecoverInitial()) {
    on<GetEncryptedKeyFromStorage>(
      (event, emit) async {
        final result =
            await cloudStorage.downloadKeyFromGoogleDrive(event.fileId);
        emit(OnDownlodKeySuccess(result));
      },
    );

    on<RecoverProccess>(
      (event, emit) async {
        final currentMemory = await stashInMemory.getCredential();

        final rawSharedKey = await cbEncryption.decryptKeyWithHardware(
          level1Encryption: currentMemory!.keyshare!,
          tag: sharedKeyTag,
        );

        //DO PRSIGN NOW
        final newPresign = await mpc.offlineSignWithJson(
          event.index,
          rawSharedKey,
        );
        final converted = CBConverter.convertStringToUint8List(newPresign);

        //Save and replace old presign
        Uint8List encryptedKey = await cbEncryption.encryptAndSaveKey(
          hash: currentMemory.argonHash!,
          rawKey: converted,
          tag: presignKeyTag,
        );

        await stashInMemory.credential.put(
          stashInMemory.credetialKey,
          currentMemory.copyWith(
            presign: encryptedKey,
          ),
        );

        emit(OnRecoverSuccess());
      },
    );
  }
}
