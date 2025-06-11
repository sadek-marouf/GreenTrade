import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';



part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onloginbuttonpressed);
    on<LogoutRequested>(_onLogoutRequested);
  }
}
Future<void> _onloginbuttonpressed(LoginButtonPressed event , Emitter<LoginState> emit) async{
  emit(LoginLoading() )  ;
  final url = Uri.parse("https://37aa017e77720a1063768fc6ea025329.serveo.net/api/login");
  try {


    final response = await http.post(url, headers: {
      "Content-Type": "application/json"
    }, body: jsonEncode({
      "email": event.email,
      "password": event.password,})
    ) ;
    print(response.body) ;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        print("Login Success 🎉");

        print("User Data: ${data['user']}")
        ;
        String userType = data['user']['userType'];
        String userEmail = event.email;
        String token = data['token'] ?? ''; // في حال فيه توكن

        // 🟢 التخزين في SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', userEmail);
        await prefs.setString('userType', userType);
        await prefs.setString('token', token);
        await prefs.setBool('isLoggedIn', true);
        emit(LoginSuccess()) ;



      }
      else  {
        print("Server Error: ${response.statusCode}");
        emit(LoginFailure(error: data['message']));

      }

    }
    else {
      emit(LoginFailure(error: 'Server Error: ${response.statusCode}'));
    }

} catch(e){
    
    emit(LoginFailure(error: e.toString())) ;
  }}
Future<void> _onLogoutRequested(LogoutRequested event, Emitter<LoginState> emit) async {
  emit(LogoutInProgress());

  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      emit(LogoutSuccess());
      return;
    }

    final url = Uri.parse("https://37aa017e77720a1063768fc6ea025329.serveo.net/api/logout");

    final response = await http.post(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      await prefs.clear(); // نمسح كل شيء محفوظ
      emit(LogoutSuccess());
    } else {
      emit(LogoutFailure(error: 'Server error: ${response.statusCode}'));
    }
  } catch (e) {
    emit(LogoutFailure(error: e.toString()));
  }
}
