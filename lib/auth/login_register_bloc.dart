import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';



part 'login_register_event.dart';
part 'login_register_state.dart';

class LoginRegisterBloc extends Bloc<LoginRegisterEvent, LoginRegisterState> {
  LoginRegisterBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onloginbuttonpressed);
  }
}
Future<void> _onloginbuttonpressed(LoginButtonPressed event , Emitter<LoginRegisterState> emit) async{
  emit(LoginLoading() )  ;
  final url = Uri.parse("Api");
  try {


    final response = await http.post(url, headers: {
      "Content-Type": "application/json"
    }, body: jsonEncode({
      "email": event.email,
      "password": event.password,})
    ) ;
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
