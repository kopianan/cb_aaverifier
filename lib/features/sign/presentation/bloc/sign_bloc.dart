import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rust_mpc_ffi/lib.dart';

import '../../../../core/services/storage.dart';

part 'sign_event.dart';
part 'sign_state.dart';

class SignBloc extends Bloc<SignEvent, SignState> {
  final cbRustMpc = CBRustMpc();
  SignBloc() : super(SignInitial()) {
    on<CreateSigning>(
      (event, emit) async {
        emit(Signing());
        var presignKey = await Storage.loadPresignKey(event.address);
        print("Presign here");

        var sign = await cbRustMpc.sign(
          event.index,
          presignKey!,
          Uint8List.fromList(event.payload.codeUnits),
        );
        print("Sign ");
        emit(OnSigningComplete(sign));
      },
    );
  }
}
