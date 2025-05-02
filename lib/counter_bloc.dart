import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/register.dart';

part 'counter_event.dart';
part 'counter_state.dart';
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegisterInitial()) {
    on<SubmitRegistrationEvent>(_onSubmit);
  }


  Future<void> _onSubmit(
      SubmitRegistrationEvent event, Emitter<RegistrationState> emit) async {
    emit(RegisterLoading());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String accountType = prefs.getString('accountType') ?? '';
      String firstName = prefs.getString('firstName') ?? '';
      String lastName = prefs.getString('lastName') ?? '';
      String email = prefs.getString('email') ?? '';
      String phone = prefs.getString('phone') ?? '';
      String password = prefs.getString('password') ?? '';
      String governorate = prefs.getString('Governorate') ?? '';
      String city = prefs.getString('City') ?? '';
      String village = prefs.getString('Village') ?? '';

      var url = Uri.parse('https://your-api-url.com/registration'); // مكان الAPI

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'accountType': accountType,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phone': phone,
          'password': password,
          'governorate': governorate,
          'city': city,
          'village': village
        }),
      );

      if (response.statusCode == 200) {
        emit(RegisterSuccess());
      } else {
        emit(RegisterError('Server error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}

