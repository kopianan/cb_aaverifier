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
  RecoverProccess({
    required this.index,
    required this.address,
  });
}

class DecryptKey extends RecoverEvent {
  final Uint8List encryptedKey;
  final Uint8List hash;

  DecryptKey(this.encryptedKey, this.hash);
}
