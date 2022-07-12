part of 'register_bloc.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class WrongPin extends RegisterState {}

class PinConfrimed extends RegisterState {
  final Uint8List hash;
  PinConfrimed(this.hash);
}

class OnPinMade extends RegisterState {
  final int step;

  ///Step 0 = new Pin
  ///Step 1 = confirm Pin
  OnPinMade(this.step);
}

class SavingHasWithBiometry extends RegisterState {}

class OnHashSavedWithBiometry extends RegisterState {}

class OnError extends RegisterState {
  final String message;
  OnError(this.message);
}
