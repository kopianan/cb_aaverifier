import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_encrypt/cb_encryption/encryption.dart';

import '../../../../core/services/storage.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Uint8List? globalHash;
  Uint8List? globalEncryptedSharedKey;
  Uint8List? globalEncryptedPresignKey;
  String? address;
  CBEncryptionHelper cbEncryptionHelper = CBEncryptionHelper();
  final storage = Storage();

  HomeBloc() : super(HomeInitial()) {
    on<SetHash>(
      (event, emit) {
        globalHash = event.hash;
      },
    );
    on<RetreiveEncryptedKeys>(
      (event, emit) async {
        address = await storage.getAddress();
        final presignTag = "presignKey-$address";
        final sharedTag = "sharedKey-$address";

        final encryptedPresign = await cbEncryptionHelper.loadEncryptedKey(
          event.hash,
          presignTag,
        );
        final encryptedKeyshared = await cbEncryptionHelper.loadEncryptedKey(
          event.hash,
          sharedTag,
        );

        globalEncryptedSharedKey = encryptedKeyshared;
        globalEncryptedPresignKey = encryptedPresign;
      },
    );

    on<GetAndDecryptPresign>(
      (event, emit) async {
        final address = await storage.getAddress();
        final presignTag = "presignKey-$address";
        final presign = await cbEncryptionHelper.decryptKeyWithHardware(
            globalEncryptedPresignKey!, presignTag);
        emit(OnGetDecryptedPresign(presign));
      },
    );
    on<WatchWalletExisting>(
      (event, emit) async {
        address = await storage.getAddress();
      },
    );
    on<ApproveRecoverRequst>(
      (event, emit) async {},
    );
  }
}
