import 'package:bloc/bloc.dart';
import 'package:cloud_storage/cloud_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'recover_event.dart';
part 'recover_state.dart';

class RecoverBloc extends Bloc<RecoverEvent, RecoverState> {
  final cloudStorage = CloudStorage();
  RecoverBloc() : super(RecoverInitial()) {
    on<GetEncryptedKeyFromStorage>(
      (event, emit) {
        cloudStorage.downloadKeyFromGoogleDrive(event.fileId);
      },
    );
  }
}
