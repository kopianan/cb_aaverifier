import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_storage/cloud_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 
import 'package:test_encrypt/cb_encryption/encryption.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  CloudStorage cloudStorage = CloudStorage();

  CBEncryptionHelper cbEncryptionHelper = CBEncryptionHelper();
  final storage = FlutterSecureStorage();

  SettingBloc() : super(SettingInitial()) {
    on<UploadFileToDrive>(
      (event, emit) async {
        final fileId =
            await cloudStorage.uploadFileToGoogleDrive(event.data.encrypted);
        emit(OnUploadSuccess(
          fileId,
          event.data.hash,
        ));
      },
    );
    on<EncryptDecrypt>(
      (event, emit) async {
        final address = await storage.read(key: 'address');
        final sharedTag = "sharedKey-$address";
        
        try {
          final rawSharedKey = await cbEncryptionHelper.decryptKeyWithHardware(
              event.encryptedSharedKey, sharedTag);
          final encryptedSecretBox =
              await CBEncryptionHelper().encryptWithCustomHash(
            CBConverter.convertStringToUint8List(rawSharedKey),
          );
          emit(OnDecryptSuccess(encryptedSecretBox));
        } catch (e) {
          print(e);
          print("ERROR DECRYPT");
          emit(OnDecryptError(e.toString()));
        }
      },
    );
  }
}
