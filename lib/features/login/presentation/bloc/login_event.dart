part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginUsingPin extends LoginEvent {
  final String pin;
  LoginUsingPin(this.pin);
}
