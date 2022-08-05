part of 'dkg_bloc.dart';

@immutable
abstract class DkgEvent {}

class ProccessDkg extends DkgEvent {
  final int index;
  ProccessDkg({required this.index});
}

class ProccessPresign extends DkgEvent {
  final int index;

  ///Address use to get the shared key from local storage
  final String address;
  ProccessPresign({
    required this.index,
    required this.address,
  });
}
