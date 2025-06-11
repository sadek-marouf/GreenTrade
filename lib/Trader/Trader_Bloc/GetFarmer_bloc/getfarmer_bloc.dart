import 'package:bloc/bloc.dart';
import 'package:farm1/Trader/Service/repositories/Trader_Repo.dart';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Service/Service.dart';

part 'getfarmer_event.dart';
part 'getfarmer_state.dart';

class GetfarmerBloc extends Bloc<GetfarmerEvent, GetfarmerState> {
  final TraderRepo repo;

  GetfarmerBloc(this.repo) : super(GetFarmerInitial()) {

  }
}