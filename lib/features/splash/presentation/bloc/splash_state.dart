part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class OnCheckingUser extends SplashState {}

class OnUserExist extends SplashState {}

class OnUserNotExist extends SplashState {}
