part of 'recover_bloc.dart';

abstract class RecoverState extends Equatable {
  const RecoverState();

  @override
  List<Object> get props => [];
}

class RecoverInitial extends RecoverState {}

class OnDownlodKeySuccess extends RecoverState {
  Uint8List encryptedKey;
  OnDownlodKeySuccess(this.encryptedKey);
}
