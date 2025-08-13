import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Farmer/Service/framwork.dart';



part 'register_event.dart';
part 'register_state.dart';
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegisterInitial()) {
    on<SubmitRegistrationEvent>(_onSubmit);
  }


  Future<void> _onSubmit(
      SubmitRegistrationEvent event, Emitter<RegistrationState> emit) async {
    emit(RegisterLoading());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String type = prefs.getString('accountType') ?? '';
      String firstName = prefs.getString('first_name') ?? '';
      String lastName = prefs.getString('last_name') ?? '';
      String email = prefs.getString('email register') ?? '';
      String phone = prefs.getString('phone') ?? '';
      String password = prefs.getString('password') ?? '';
      String governorate = prefs.getString('governorate') ?? '';
      String city = prefs.getString('city') ?? '';
      String village = prefs.getString('village') ?? '';

      var url = Uri.parse("http://$ip:8000/api/register"); // API

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'type': type.toString(),
          'first_name': firstName.toString(),
          'last_name': lastName.toString(),
          'email': email,
          'password': password,
          'phone': phone,

          'governorate': governorate,
          'city': city,
          'village': village.toString()
        }),
      );
          print(response.body) ;
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        final token = responseData['token'];
        if (token != null) {
          await prefs.setString('token', token);
        }

        emit(RegisterSuccess());

      } else {
        emit(RegisterError('Server error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}

