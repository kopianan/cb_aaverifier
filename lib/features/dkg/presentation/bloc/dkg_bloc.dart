import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:coinbit_secure_package/cb_encryption/cb_converter.dart';
import 'package:coinbit_secure_package/cb_encryption/cb_encryption_helper.dart';
import 'package:coinbit_verifier/core/services/mpc_service.dart';
import 'package:coinbit_verifier/core/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rust_mpc_ffi/lib.dart';

import '../../../../core/storage/stash_in_memory.dart';

part 'dkg_event.dart';
part 'dkg_state.dart';

class DkgBloc extends Bloc<DkgEvent, DkgState> {
  CBRustMpc cbRustMpc = CBRustMpc();
  MPCService mpcService = MPCService();
  CBEncryptionHelper cbEncryption = CBEncryptionHelper();
  final storage = Storage();
  final stashInMemory = StashInMemory();

  dynamic rawKeyShare;
  DkgBloc() : super(ProccessDKGInitial()) {
    on<ProccessDkg>(
      (event, emit) async {
        late Uint8List layer1Keyshare;
        final currentInMemory = await stashInMemory.getCredential();

        //Proccessing DKG
        emit(GeneratingSharedKey());
        rawKeyShare = await cbRustMpc.proccessDkgString(event.index);

        if (rawKeyShare != 'null') {
          layer1Keyshare = await cbEncryption.encryptAndSaveKey(
            hash: currentInMemory!.argonHash!,
            rawKey:
                CBConverter.convertStringToUint8List(rawKeyShare.toString()),
            tag: 'evm-keyshare',
          );

          /// store keyshare in memory
          await stashInMemory.credential.put(
            stashInMemory.credetialKey,
            currentInMemory.copyWith(keyshare: layer1Keyshare),
          );
          //Get Address
          final eth = await mpcService.generateAddress(rawKeyShare.toString());
          //save has for generating tag
          await storage.saveAddress(eth.hex);

          emit(OnSharedKeyGenerated());
        }
      },
    );

    on<ProccessPresign>(
      (event, emit) async {
        final currentInMemory = await stashInMemory.getCredential();

        emit(GeneratingPresignKey());
        //if null just decrypt shared key from hardware
        rawKeyShare ??= await cbEncryption.decryptKeyWithHardware(
          level1Encryption: currentInMemory!.keyshare!,
          tag: 'evm-keyshare',
        );

        final presignKey = await cbRustMpc.offlineSignWithJson(
          event.index,
          rawKeyShare!,
        );
        //check if _shared key null
        //shared is local variable, hanya akan terisi di awal jika proses dkg selesai

        final converted = CBConverter.convertStringToUint8List(presignKey);
        Uint8List layer1PresignKey = await cbEncryption.encryptAndSaveKey(
          hash: currentInMemory!.argonHash!,
          rawKey: converted,
          tag: 'evm-presign',
        );

        await stashInMemory.credential.put(
          stashInMemory.credetialKey,
          currentInMemory.copyWith(presign: layer1PresignKey),
        );
        rawKeyShare = null;
        emit(OnPresignKeyGenerated());
      },
    );
  }
}
