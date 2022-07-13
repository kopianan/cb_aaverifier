import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_encrypt/cb_encryption/encryption.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Uint8List? globalHash;
  String? globalEncryptedSharedKey;
  String? globalEncryptedPresignKey;

  CBEncryptionHelper cbEncryptionHelper = CBEncryptionHelper();
  final storage = FlutterSecureStorage();

  HomeBloc() : super(HomeInitial()) {
    on<SetHash>(
      (event, emit) async {
        globalHash = event.hash;
      },
    );
    on<RetreiveEncryptedKeys>(
      (event, emit) async {
        final address = await storage.read(key: 'address');
        print(address);
        final presignTag = "presignKey-$address";
        final sharedTag = "sharedKey-$address";
        log(presignTag, name: "Presign Tag");
        log(sharedTag, name: "Shared Tag");
        final encryptedPresign =
            await cbEncryptionHelper.loadEncryptedKey(event.hash, presignTag);
        log(encryptedPresign, name: "ENCRYPTED PRESIGN");
        final encryptedKeyshared =
            await cbEncryptionHelper.loadEncryptedKey(event.hash, sharedTag);

        globalEncryptedSharedKey = encryptedKeyshared;
        globalEncryptedPresignKey = encryptedPresign;
      },
    );

    on<GetAndDecryptPresign>(
      (event, emit) async {
        final address = await storage.read(key: 'address');
        final presignTag = "presignKey-$address";
        final presign = await cbEncryptionHelper.decryptKeyWithHardware(
            globalEncryptedPresignKey!, presignTag);
        emit(OnGetDecryptedPresign(presign));
      },
    );
  }
}
