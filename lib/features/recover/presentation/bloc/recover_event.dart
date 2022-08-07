part of 'recover_bloc.dart';

@immutable
abstract class RecoverEvent {}

class GetEncryptedKeyFromStorage extends RecoverEvent {
  final String fileId;
  GetEncryptedKeyFromStorage(this.fileId);
}

class RecoverProccess extends RecoverEvent {
  final int index;
  RecoverProccess({required this.index});
}
