part of 'counter_bloc.dart';

@immutable
sealed class RegistrationEvent {}

class SubmitRegistrationEvent extends RegistrationEvent {}


class RegisterUser extends RegistrationEvent {
  final UserModel user;

  RegisterUser({required this.user});
}