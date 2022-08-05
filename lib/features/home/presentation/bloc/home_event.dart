part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class GetAndDecryptPresign extends HomeEvent {
  GetAndDecryptPresign();
}

class ApproveRecoverRequst extends HomeEvent {
  final Uint8List encryptedSharedKey;
  ApproveRecoverRequst(this.encryptedSharedKey);
}
