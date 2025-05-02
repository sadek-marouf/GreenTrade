part of 'login_register_bloc.dart';

@immutable
sealed class LoginRegisterEvent {}


class LoginButtonPressed extends LoginRegisterEvent {
  final String email;

   final String password;

  LoginButtonPressed( this.email ,this.password);
}