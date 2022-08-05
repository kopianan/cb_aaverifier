part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class MakePin extends RegisterEvent {
  final String pin;

  MakePin(this.pin);
}

class ActivateBiometry extends RegisterEvent {
  ActivateBiometry();
}
