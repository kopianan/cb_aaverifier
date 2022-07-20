part of 'recover_bloc.dart';

@immutable
abstract class RecoverState {}

class RecoverInitial extends RecoverState {}

class OnRequestRecover extends RecoverState {}

class OnRequestApproved extends RecoverState {
 final  String sharedKey;
 final  String presignKey;
  OnRequestApproved(this.sharedKey, this.presignKey);
}

class OnDownlodKeySuccess extends RecoverState {
  final Uint8List encryptedKey;
  OnDownlodKeySuccess(this.encryptedKey);
}
