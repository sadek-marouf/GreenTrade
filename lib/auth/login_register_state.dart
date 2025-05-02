part of 'login_register_bloc.dart';

@immutable
sealed class LoginRegisterState {}



class LoginInitial extends  LoginRegisterState{}

class LoginLoading extends LoginRegisterState {}

class LoginSuccess extends LoginRegisterState {}

class LoginFailure extends LoginRegisterState {
  final String error;

  LoginFailure({required this.error});
}