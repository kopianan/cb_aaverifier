part of 'sign_bloc.dart';

abstract class SignState {}

class SignInitial extends SignState {}

class Signing extends SignState {}

class OnSigningComplete extends SignState {
  final RSVModel rsvKey;
  OnSigningComplete(this.rsvKey);
}
