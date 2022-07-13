import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rust_mpc_ffi/lib.dart';
import 'package:convert/convert.dart';

part 'sign_event.dart';
part 'sign_state.dart';

class SignBloc extends Bloc<SignEvent, SignState> {
  final cbRustMpc = CBRustMpc();
  SignBloc() : super(SignInitial()) {
    on<CreateSigning>(
      (event, emit) async {
        emit(Signing()); 

        var sign = await cbRustMpc.sign(
          event.index,
          event.presign,
          Uint8List.fromList(hex.decode(event.payload)),
        );
        emit(OnSigningComplete(sign));
      },
    );
  }
}
