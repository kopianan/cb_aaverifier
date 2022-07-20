part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class SetHash extends HomeEvent {
  final Uint8List hash;
  SetHash(this.hash);
}

///this will retrieve presign and shared key
class RetreiveEncryptedKeys extends HomeEvent {
  final Uint8List hash;
  RetreiveEncryptedKeys(this.hash);
}

class GetAndDecryptPresign extends HomeEvent {
  GetAndDecryptPresign();
}

class ApproveRecoverRequst extends HomeEvent {
  final Uint8List encryptedSharedKey;
  ApproveRecoverRequst(this.encryptedSharedKey);
}

class WatchWalletExisting extends HomeEvent {}
