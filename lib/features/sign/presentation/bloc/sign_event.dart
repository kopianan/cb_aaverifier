part of 'sign_bloc.dart';

@immutable
abstract class SignEvent {}

class CreateSigning extends SignEvent {
  final int index;
  final String payload;
  final String address;
  final String presign;
  CreateSigning(
      {required this.index,
      required this.payload,
      required this.address,
      required this.presign});
}
