part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}


class LoginButtonPressed extends LoginEvent {
  final String email;

   final String password;

  LoginButtonPressed( this.email ,this.password);
}
class LogoutRequested extends LoginEvent {}
