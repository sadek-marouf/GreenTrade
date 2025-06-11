part of 'login_bloc.dart';

@immutable
sealed class LoginState {}



class LoginInitial extends  LoginState{}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}


class LogoutInProgress extends LoginState {}

class LogoutSuccess extends LoginState {}

class LogoutFailure extends LoginState {
  final String error;
  LogoutFailure({required this.error});
}