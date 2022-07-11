part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class MakePin extends RegisterEvent {
  final String pin;

  MakePin(this.pin);
}

class ConfirmPin extends RegisterEvent {
  final String confirmPin;

  ConfirmPin(this.confirmPin);
}

class ActivateBiometry extends RegisterEvent {
  final Uint8List hash;

  ActivateBiometry(this.hash);
}
