part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class OnGetDecryptedPresign extends HomeState {
  final String presign;
  OnGetDecryptedPresign(this.presign);
}
