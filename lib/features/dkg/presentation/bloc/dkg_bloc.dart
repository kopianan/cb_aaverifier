import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:coinbit_verifier/core/services/fcm_service.dart';
import 'package:coinbit_verifier/core/services/mpc_service.dart';
import 'package:coinbit_verifier/core/services/storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rust_mpc_ffi/lib.dart';

part 'dkg_event.dart';
part 'dkg_state.dart';

class DkgBloc extends Bloc<DkgEvent, DkgState> {
  CBRustMpc cbRustMpc = CBRustMpc();
  MPCService mpcService = MPCService();

  DkgBloc() : super(ProccessDKGInitial()) {
    on<ProccessDkg>(
      (event, emit) async {
        //Proccessing DKG
        emit(GeneratingSharedKey());
        final sharedKey = await cbRustMpc.proccessDkgString(event.index);
        log("SAVE SHARE KEY TO LOCAL");
        //Get Address
        final eth = await mpcService.generateAddress(sharedKey);
        //Save with package
        await Storage.saveSharedKey(eth.hex, sharedKey.toString());
        emit(OnSharedKeyGenerated());
      },
    );

    on<ProccessPresign>(
      (event, emit) async {
        emit(GeneratingPresignKey());
        print(event.address);

        final sharedKey = await Storage.loadSharedKey(event.address);
        print("Shared key loaded");
        final presignKey =
            await cbRustMpc.offlineSignWithJson(event.index, sharedKey!);
        print("Presing key");
        Storage.savePresignKey(event.address, presignKey);
        emit(OnPresignKeyGenerated());
      },
    );
  }
}
