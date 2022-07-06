part of 'dkg_bloc.dart';

@immutable
abstract class DkgState {}

class ProccessDKGInitial extends DkgState {
  final int step;
  ProccessDKGInitial({this.step = 0});
}

class GeneratingSharedKey extends DkgState {}

class OnSharedKeyGenerated extends DkgState {}

class GeneratingPresignKey extends DkgState {}

class OnPresignKeyGenerated extends DkgState {}
