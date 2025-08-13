import 'package:bloc/bloc.dart';
import 'package:farm1/Trader/Service/Service.dart';
import 'package:meta/meta.dart';

import '../../../Farmer/Service/repositories/products_repository.dart';

part 'visitfarmer_event.dart';
part 'visitfarmer_state.dart';

class VisitfarmerBloc extends Bloc<VisitfarmerEvent, VisitfarmerState> {
  final ProductsRepository repo;

  VisitfarmerBloc(this.repo) : super(VisitfarmerInitial()) {
    on<VisitFarmer>(_onvivstfarmer) ;}

    Future<void> _onvivstfarmer(VisitFarmer event , Emitter<VisitfarmerState> emit)async{
     emit(VisitfarmerLoading());
     try{
     final farmer=  await  repo.visitfarmer(event.id);
     emit(VisitfarmerLoaded(farmer));
     }catch(e){
       print("====================error====================$e");
       emit(VisitfarmerError(e.toString()));
     }


    }
    }
