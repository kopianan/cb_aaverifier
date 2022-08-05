import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:coinbit_verifier/core/storage/stash_in_memory.dart';
import 'package:coinbit_verifier/core/utils/utils_const.dart';
import 'package:flutter/material.dart';
import 'package:coinbit_secure_package/cb_encryption/encryption.dart';

import '../../../../core/services/storage.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  String? address;
  CBEncryptionHelper cbEncryptionHelper = CBEncryptionHelper();
  final storage = Storage();
  final stashInMemory = StashInMemory();
  HomeBloc() : super(HomeInitial()) {
    on<GetAndDecryptPresign>(
      (event, emit) async {
        final currentInMemory = await stashInMemory.getCredential();

        final presign = await cbEncryptionHelper.decryptKeyWithHardware(
          level1Encryption: currentInMemory!.presign!,
          tag: presignKeyTag,
        );
        emit(OnGetDecryptedPresign(presign));
      },
    );

    on<ApproveRecoverRequst>(
      (event, emit) async {},
    );
  }
}
