part of 'kyc_bloc.dart';

abstract class KycState extends Equatable {
  const KycState();  

  @override
  List<Object> get props => [];
}
class KycInitial extends KycState {}
