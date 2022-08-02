part of 'recover_bloc.dart';

@immutable
abstract class RecoverEvent {}

class GetEncryptedKeyFromStorage extends RecoverEvent {
  final String fileId;
  GetEncryptedKeyFromStorage(this.fileId);
}

class RecoverProccess extends RecoverEvent {
  final int index;
  final String address;
  final Uint8List encryptedKeyShared;
  final Uint8List hash;
  RecoverProccess({
    required this.index,
    required this.encryptedKeyShared,
    required this.address,
    required this.hash,
  });
}

class DecryptKey extends RecoverEvent {
  final Uint8List encryptedKey;
  final Uint8List hash;

  DecryptKey(this.encryptedKey, this.hash);
}
