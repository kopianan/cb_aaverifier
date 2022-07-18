part of 'recover_bloc.dart';

@immutable
abstract class RecoverEvent {}

class GetEncryptedKeyFromStorage extends RecoverEvent {
  final String fileId;
  GetEncryptedKeyFromStorage(this.fileId);
}

class DecryptKey extends RecoverEvent {
  final Uint8List encryptedKey;
  final Uint8List hash;

  DecryptKey(this.encryptedKey, this.hash);
}
