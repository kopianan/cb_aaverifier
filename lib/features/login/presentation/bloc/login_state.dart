part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginFailed extends LoginState {
  final String message;
  LoginFailed(this.message);
}

class LoginSuccess extends LoginState {
  LoginSuccess();
}
