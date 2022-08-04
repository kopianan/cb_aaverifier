part of 'dkg_bloc.dart';

@immutable
abstract class DkgEvent {}

class ProccessDkg extends DkgEvent {
  final int index;
  final Uint8List hash;
  ProccessDkg({required this.index, required this.hash});
}

class ProccessPresign extends DkgEvent {
  final int index;
  final Uint8List hash;
  final Uint8List? layer1SharedKey;

  ///Address use to get the shared key from local storage
  final String address;
  ProccessPresign({
    required this.index,
    required this.address,
    required this.hash,
    this.layer1SharedKey,
  });
}
