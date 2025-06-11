import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';



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
      String firstName = prefs.getString('firstName') ?? '';
      String lastName = prefs.getString('lastName') ?? '';
      String email = prefs.getString('email register') ?? '';
      String phone = prefs.getString('phone') ?? '';
      String password = prefs.getString('password') ?? '';
      String governorate = prefs.getString('Governorate') ?? '';
      String city = prefs.getString('City') ?? '';
      String village = prefs.getString('Village') ?? '';

      var url = Uri.parse("https://7c798e618e6b5601c7c9b354e769f139.serveo.net/api/register"); // API

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'type': type,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
          'phone': phone,

          'governorate': governorate,
          'city': city,
          'village': village
        }),
      );
          print(response.body) ;
      if (response.statusCode == 201) {

        emit(RegisterSuccess());
      } else {
        emit(RegisterError('Server error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}

