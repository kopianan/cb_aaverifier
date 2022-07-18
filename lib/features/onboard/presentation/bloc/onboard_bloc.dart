import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboard_event.dart';
part 'onboard_state.dart';

class OnboardBloc extends Bloc<OnboardEvent, OnboardState> {
  OnboardBloc() : super(OnboardInitial()) {
    on<OnboardEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
