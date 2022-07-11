import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'kyc_event.dart';
part 'kyc_state.dart';

class KycBloc extends Bloc<KycEvent, KycState> {
  KycBloc() : super(KycInitial()) {
    on<KycEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
