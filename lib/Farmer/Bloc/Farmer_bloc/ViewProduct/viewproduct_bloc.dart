import 'dart:convert';

import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Service/framwork.dart';





part 'viewproduct_event.dart';
part 'viewproduct_state.dart';

class ViewproductBloc extends Bloc<ViewproductEvent, ViewproductState> {
  ViewproductBloc() : super(ViewproductInitial()) {

    on<GetProducts>(_Viewproduct);
  }
  Future<void> _Viewproduct(
      GetProducts event, Emitter<ViewproductState> emit) async {
    emit(ViewProductLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      print("🚀 Sending request to API...");

      final response = await http.get(
        Uri.parse("http://10.154.48.169:8000/api/products"),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      print("📬 Response status: ${response.statusCode}");
      print("📦 Response body: ${response.body}");

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      print("🔑 Token is: $token");


      if (response.statusCode == 200) {


        final decoded = jsonDecode(response.body);
        print(response) ;


       
        final List<dynamic> data = decoded['products'];


        final getProducts = data.map((e) => Get_Products.fromJson(e)).toList();

        emit(ViewProductLoaded(getProducts));
      } else {
        emit(ViewProductError('Server error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ViewProductError('Exception: $e'));
    }
  }


}


