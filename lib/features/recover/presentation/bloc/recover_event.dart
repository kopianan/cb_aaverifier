part of 'recover_bloc.dart';

@immutable
abstract class RecoverEvent {}

class GetEncryptedKeyFromStorage extends RecoverEvent {
  final String fileId;
  GetEncryptedKeyFromStorage(this.fileId);
}
