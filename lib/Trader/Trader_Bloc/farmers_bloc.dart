import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Farmer/Service/framwork.dart';
import '../Service/Service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
part 'farmers_event.dart';
part 'farmers_state.dart';




class FarmersBloc extends Bloc<FarmersEvent, FarmersState> {
  FarmersBloc() : super(FarmersInitial()) {
    on<FetchFarmers>(_onFetchFarmers);
    on<SearchProduct>(_onSearchProduct);

  }

  Future<void> _onFetchFarmers(
      FetchFarmers event, Emitter<FarmersState> emit) async {
    emit(FarmersLoading());

    try {
      final response = await http.get(Uri.parse("http://$ip:8000/api/farmers-with-products"));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          List<Farmerd> farmers = (jsonData['data'] as List)
              .map((e) => Farmerd.fromJson(e))
              .toList();
          emit(FarmersLoaded(farmers));
        } else {
          emit(FarmersError(jsonData['message'] ?? "Unknown error"));
        }
      } else {
        emit(FarmersError("Server error: ${response.statusCode}"));
      }
    } catch (e) {
      emit(FarmersError("Exception: $e"));
    }
  }

  Future<void> _onSearchProduct(
      SearchProduct event, Emitter<FarmersState> emit) async {
    emit(SearchProductLoading());
    print(event.name);
    print(event.type);

    try {
      final uri = Uri.http(
        "$ip:8000",
        "/api/farmers/search-products",
        {
          'type': event.type,
          'name': event.name,
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        List<Farmerd> farmers = (jsonData as List)
            .map((e) => Farmerd.fromJson(e))
            .toList();

        emit(SearchProductLoaded(farmers));
      } else {

        emit(SearchProductError("Server error: ${response.statusCode}"));
      }
    } catch (e) {
      print(e);
      emit(SearchProductError("Exception: $e"));
    }
  }


  }

