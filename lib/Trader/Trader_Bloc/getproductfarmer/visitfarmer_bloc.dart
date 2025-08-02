import 'package:bloc/bloc.dart';
import 'package:farm1/Trader/Service/Service.dart';
import 'package:meta/meta.dart';

part 'visitfarmer_event.dart';
part 'visitfarmer_state.dart';

class VisitfarmerBloc extends Bloc<VisitfarmerEvent, VisitfarmerState> {

  VisitfarmerBloc() : super(VisitfarmerInitial()) {
    on<VisitfarmerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
