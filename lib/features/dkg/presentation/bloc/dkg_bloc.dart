import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:coinbit_verifier/core/services/mpc_service.dart';
import 'package:coinbit_verifier/core/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rust_mpc_ffi/lib.dart';
import 'package:test_encrypt/cb_encryption/encryption.dart';

part 'dkg_event.dart';
part 'dkg_state.dart';

class DkgBloc extends Bloc<DkgEvent, DkgState> {
  CBRustMpc cbRustMpc = CBRustMpc();
  MPCService mpcService = MPCService();
  CBEncryptionHelper cbEncryption = CBEncryptionHelper();
  final storage = Storage();

  String? _shared = '';
  DkgBloc() : super(ProccessDKGInitial()) {
    on<ProccessDkg>(
      (event, emit) async {
        //Proccessing DKG
        emit(GeneratingSharedKey());
        final sharedKey = await cbRustMpc.proccessDkgString(event.index);
        //Get Address
        final eth = await mpcService.generateAddress(sharedKey.toString());
        //save has for generating tag
        await storage.saveAddress(eth.hex);
        final tag = "sharedKey-${eth.hex}";
        final converted = CBConverter.convertStringToUint8List(sharedKey);
        //Save with package
        Uint8List encryptedKey = await cbEncryption.encryptAndSaveKey(
          event.hash,
          converted,
          tag,
        );
        print(eth.hex);
        _shared = sharedKey;
        emit(OnSharedKeyGenerated(encryptedKey));
      },
    );

    on<ProccessPresign>(
      (event, emit) async {
        emit(GeneratingPresignKey()); 

        final presignKey = await cbRustMpc.offlineSignWithJson(
          event.index,
          _shared!,
        );
 
        final tag = "presignKey-${event.address}";
        final converted = CBConverter.convertStringToUint8List(presignKey);
        Uint8List encryptedKey = await cbEncryption.encryptAndSaveKey(
          event.hash,
          converted,
          tag,
        );
        emit(OnPresignKeyGenerated(encryptedKey));
      },
    );
  }
}
